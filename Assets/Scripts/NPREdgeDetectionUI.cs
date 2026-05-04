using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.InputSystem;

/// In-VR panel for live-tuning the Avatar/MetaNPR edge-detection parameters.
/// Finds every renderer that uses the Avatar/MetaNPR shader and pushes values
/// directly to those material instances — no shader-swapper needed.
/// Controls: B/Y/Tab = toggle panel | point ray at row | hold Trigger = drag slider
public class NPREdgeDetectionUI : MonoBehaviour
{
    [Header("Panel placement")]
    [SerializeField] private Transform _anchor;
    [SerializeField] private float _spawnDistance = 1.5f;
    [SerializeField] private float _spawnYOffset   = 0f;

    [Header("Panel size")]
    [SerializeField] private float _panelWidth = 1.5f;

    private const float CANVAS_W = 1000f;

    // ── Row data ──────────────────────────────────────────────────────────────
    private enum RowKind { Float, Color }
    [System.NonSerialized] private readonly List<Row> _rows = new();

    private struct Row
    {
        public RowKind     kind;
        public string      label;
        public string      propName;
        public float       currentValue;
        public float       min, max, step;
        public int         colorIndex;
        public Text        valueText;
        public Image       highlight;
        public Text        cursorText;
        public BoxCollider collider;
        public Image       sliderFill;
    }

    // ── Color presets ─────────────────────────────────────────────────────────
    private static readonly (string name, Color color)[] _colorPresets =
    {
        ("Black",    Color.black),
        ("Navy",     new Color(0.05f, 0.05f, 0.25f)),
        ("Dark Red", new Color(0.25f, 0.02f, 0.02f)),
        ("Brown",    new Color(0.20f, 0.10f, 0.00f)),
        ("Gray",     new Color(0.30f, 0.30f, 0.30f)),
        ("White",    Color.white),
        ("Cyan",     new Color(0.00f, 0.60f, 0.80f)),
        ("Gold",     new Color(0.80f, 0.60f, 0.00f)),
    };

    private int  _cursor     = -1;
    private int  _hoveredRow = -1;
    private bool _visible;

    private GameObject     _panel;
    private RectTransform  _panelRt;
    private Transform      _camTransform;
    private Transform      _controllerTransform;
    private LineRenderer   _lr;

    // Materials collected from any renderer using the Avatar/MetaNPR shader.
    [System.NonSerialized] private readonly List<Material> _nprMaterials = new();
    private float _materialRefreshTimer;
    private const float MATERIAL_REFRESH_INTERVAL = 3f;

    private float _decCooldown;
    private const float FIRST_REPEAT = 0.45f;
    private const float HOLD_REPEAT  = 0.12f;

    private float _debugTimer;
    private readonly RaycastHit[] _hitBuffer = new RaycastHit[16];

    // ─────────────────────────────────────────────────────────────────────────
    void Start()
    {
        Debug.Log("[NPREdgeDetectionUI] Start() on " + gameObject.name);
        ResolveCamera();
        ResolveController();
        RefreshNPRMaterials();
        BuildPanel();
        BuildRayLine();
        SetVisible(false);
        Debug.Log("[NPREdgeDetectionUI] Ready — B/Y/Tab to open.");
    }

    // ── Material collection ───────────────────────────────────────────────────
    void RefreshNPRMaterials()
    {
        _nprMaterials.Clear();
        foreach (var rend in FindObjectsOfType<Renderer>())
        {
            if (rend == null) continue;
            foreach (var mat in rend.sharedMaterials)
            {
                if (mat != null && mat.shader != null &&
                    (mat.shader.name.Contains("MetaNPR") || mat.shader.name.Contains("Avatar/Meta")) &&
                    !_nprMaterials.Contains(mat))
                {
                    _nprMaterials.Add(mat);
                }
            }
        }
        Debug.Log("[NPREdgeDetectionUI] Found " + _nprMaterials.Count + " MetaNPR material(s).");
    }

    void SetShaderFloat(string prop, float val)
    {
        int hits = 0;
        foreach (var mat in _nprMaterials)
            if (mat != null && mat.HasProperty(prop)) { mat.SetFloat(prop, val); hits++; }

        if (hits == 0)
        {
            // Materials not ready yet — refresh and try once more
            RefreshNPRMaterials();
            foreach (var mat in _nprMaterials)
                if (mat != null && mat.HasProperty(prop)) mat.SetFloat(prop, val);
        }
    }

    void SetShaderColor(string prop, Color c)
    {
        int hits = 0;
        foreach (var mat in _nprMaterials)
            if (mat != null && mat.HasProperty(prop)) { mat.SetColor(prop, c); hits++; }

        if (hits == 0)
        {
            RefreshNPRMaterials();
            foreach (var mat in _nprMaterials)
                if (mat != null && mat.HasProperty(prop)) mat.SetColor(prop, c);
        }
    }

    void PushAllValues()
    {
        RefreshNPRMaterials();
        foreach (var row in _rows)
        {
            if (row.kind == RowKind.Float)
                SetShaderFloat(row.propName, row.currentValue);
            else
            {
                var (_, c) = _colorPresets[row.colorIndex];
                SetShaderColor(row.propName, c);
            }
        }
        Debug.Log("[NPREdgeDetectionUI] PushAll — materials=" + _nprMaterials.Count);
    }

    // ─────────────────────────────────────────────────────────────────────────
    void Update()
    {
        // Periodic heartbeat + material refresh
        _debugTimer += Time.deltaTime;
        if (_debugTimer >= 5f)
        {
            _debugTimer = 0f;
            Debug.Log("[NPREdgeDetectionUI] Heartbeat visible=" + _visible +
                      " nprMats=" + _nprMaterials.Count);
        }

        // Periodic re-push while panel is visible (handles SDK recreating materials on LOD switch)
        if (_visible)
        {
            _materialRefreshTimer += Time.deltaTime;
            if (_materialRefreshTimer >= MATERIAL_REFRESH_INTERVAL)
            {
                _materialRefreshTimer = 0f;
                PushAllValues();
            }
        }

        bool bBtn = OVRInput.GetDown(OVRInput.Button.Two);
        bool yBtn = OVRInput.GetDown(OVRInput.Button.Four);
        bool tab  = Keyboard.current != null && Keyboard.current.tabKey.wasPressedThisFrame;
        if (bBtn || yBtn || tab) SetVisible(!_visible);

        if (!_visible)
        {
            if (_lr != null) _lr.gameObject.SetActive(false);
            return;
        }

        if (_camTransform != null)
        {
            Vector3 toCam = _camTransform.position - _panel.transform.position;
            toCam.y = 0f;
            if (toCam.sqrMagnitude > 0.001f)
                _panel.transform.rotation = Quaternion.LookRotation(-toCam.normalized, Vector3.up);
        }

        UpdateRayInteraction();
    }

    void UpdateRayInteraction()
    {
        if (_controllerTransform == null) return;

        var ray      = new Ray(_controllerTransform.position, _controllerTransform.forward);
        int hitCount = Physics.RaycastNonAlloc(ray, _hitBuffer, 5f);

        int     newHover    = -1;
        float   closest     = float.MaxValue;
        Vector3 rowHitPoint = Vector3.zero;

        for (int j = 0; j < hitCount; j++)
        {
            var h = _hitBuffer[j];
            for (int i = 0; i < _rows.Count; i++)
            {
                if (_rows[i].collider != null && _rows[i].collider == h.collider && h.distance < closest)
                {
                    closest     = h.distance;
                    newHover    = i;
                    rowHitPoint = h.point;
                }
            }
        }

        if (_lr != null)
        {
            _lr.gameObject.SetActive(true);
            _lr.SetPosition(0, ray.origin);
            _lr.SetPosition(1, newHover >= 0 ? rowHitPoint : ray.origin + ray.direction * 3f);
        }

        if (newHover != _hoveredRow)
        {
            SetHover(_hoveredRow, false);
            _hoveredRow  = newHover;
            _cursor      = newHover;
            SetHover(_hoveredRow, true);
            _decCooldown = 0f;
        }

        if (_hoveredRow < 0) return;

        bool trigHeld = OVRInput.Get(OVRInput.Button.PrimaryIndexTrigger)
                     || OVRInput.Get(OVRInput.Button.SecondaryIndexTrigger);
        bool decDown  = OVRInput.GetDown(OVRInput.Button.PrimaryHandTrigger)
                     || OVRInput.GetDown(OVRInput.Button.SecondaryHandTrigger);
        bool decHeld  = OVRInput.Get(OVRInput.Button.PrimaryHandTrigger)
                     || OVRInput.Get(OVRInput.Button.SecondaryHandTrigger);

        var row = _rows[_hoveredRow];
        if (row.kind == RowKind.Float)
        {
            if (trigHeld) DragSlider(_hoveredRow, rowHitPoint);

            if (decDown) { AdjustStep(-1f); _decCooldown = FIRST_REPEAT; }
            else if (decHeld) { _decCooldown -= Time.deltaTime; if (_decCooldown <= 0f) { _decCooldown = HOLD_REPEAT; AdjustStep(-1f); } }
            else _decCooldown = 0f;
        }
        else
        {
            bool trigDown = OVRInput.GetDown(OVRInput.Button.PrimaryIndexTrigger)
                         || OVRInput.GetDown(OVRInput.Button.SecondaryIndexTrigger);
            if (trigDown) AdjustColor(+1);
            if (decDown)  AdjustColor(-1);
        }
    }

    void DragSlider(int rowIndex, Vector3 worldHitPoint)
    {
        var row  = _rows[rowIndex];
        var bgRt = row.sliderFill.rectTransform.parent as RectTransform;
        if (bgRt == null) return;

        float width = bgRt.rect.width;
        if (width < 1f) return;

        Vector3 localPt = bgRt.InverseTransformPoint(worldHitPoint);
        float   t       = Mathf.Clamp01((localPt.x + width * 0.5f) / width);
        float   newVal  = Mathf.Lerp(row.min, row.max, t);

        row.currentValue           = newVal;
        row.valueText.text         = newVal.ToString("F3");
        row.sliderFill.rectTransform.anchorMax = new Vector2(t, 1f);
        _rows[rowIndex]            = row;

        SetShaderFloat(row.propName, newVal);
    }

    void AdjustStep(float direction)
    {
        if (_cursor < 0 || _cursor >= _rows.Count) return;
        var row  = _rows[_cursor];
        if (row.kind != RowKind.Float) return;

        float next = Mathf.Clamp(row.currentValue + direction * row.step, row.min, row.max);
        float t    = Mathf.InverseLerp(row.min, row.max, next);

        row.currentValue  = next;
        row.valueText.text = next.ToString("F3");
        if (row.sliderFill != null)
            row.sliderFill.rectTransform.anchorMax = new Vector2(t, 1f);
        _rows[_cursor] = row;

        SetShaderFloat(row.propName, next);
    }

    void AdjustColor(int direction)
    {
        if (_cursor < 0 || _cursor >= _rows.Count) return;
        var row = _rows[_cursor];
        if (row.kind != RowKind.Color) return;

        row.colorIndex = (int)Mathf.Repeat(row.colorIndex + direction, _colorPresets.Length);
        var (cname, c) = _colorPresets[row.colorIndex];
        row.valueText.text  = cname;
        row.valueText.color = (c.r + c.g + c.b < 0.3f) ? new Color(0.7f, 0.7f, 0.7f) : c;
        _rows[_cursor] = row;

        SetShaderColor(row.propName, c);
    }

    void SetHover(int index, bool on)
    {
        if (index < 0 || index >= _rows.Count) return;
        var row = _rows[index];
        if (row.highlight  != null) row.highlight.color  = on ? new Color(0.25f, 0.65f, 1f, 0.25f) : Color.clear;
        if (row.cursorText != null) row.cursorText.color = on ? new Color(0.4f, 0.9f, 1f)           : Color.clear;
    }

    void SetVisible(bool v)
    {
        _visible = v;
        _panel.SetActive(v);
        if (v) { PlacePanel(); _materialRefreshTimer = MATERIAL_REFRESH_INTERVAL; PushAllValues(); }
        if (!v && _lr != null) _lr.gameObject.SetActive(false);
    }

    void ApplyPanelScale() { if (_panelRt != null) _panelRt.localScale = Vector3.one * (_panelWidth / CANVAS_W); }
    void OnValidate()      => ApplyPanelScale();

    void PlacePanel()
    {
        if (_camTransform == null) { ResolveCamera(); if (_camTransform == null) return; }
        ApplyPanelScale();
        Vector3 fwd = _camTransform.forward; fwd.y = 0f;
        if (fwd.sqrMagnitude < 0.001f) fwd = Vector3.forward;
        fwd.Normalize();
        _panel.transform.SetPositionAndRotation(
            _camTransform.position + fwd * _spawnDistance + Vector3.up * _spawnYOffset,
            Quaternion.LookRotation(fwd, Vector3.up));
    }

    // ─────────────────────────────────────────────────────────────────────────
    void BuildPanel()
    {
        _panel = new GameObject("NPREdgePanel");
        _panel.transform.SetParent(transform, false);

        var canvas = _panel.AddComponent<Canvas>();
        canvas.renderMode = RenderMode.WorldSpace;

        _panelRt = _panel.GetComponent<RectTransform>();
        _panelRt.sizeDelta = new Vector2(CANVAS_W, 680f);
        ApplyPanelScale();

        var bg = Go("BG", _panel.transform);
        bg.AddComponent<Image>().color = new Color(0.07f, 0.07f, 0.07f, 0.95f);
        Stretch(bg);

        var host = Go("Host", _panel.transform);
        var vlg  = host.AddComponent<VerticalLayoutGroup>();
        vlg.padding               = new RectOffset(30, 30, 24, 24);
        vlg.spacing               = 10;
        vlg.childControlWidth     = true;
        vlg.childControlHeight    = false;
        vlg.childForceExpandWidth = true;
        Stretch(host);

        var t = host.transform;
        Label(t, "NPR EDGE DETECTION",                                  28, new Color(0.4f, 0.9f, 1f));
        Label(t, "Point ray   hold Trigger = drag   Grip = step   B/Y close", 16, new Color(0.5f, 0.5f, 0.5f));
        Space(t, 8);

        SectionLabel(t, "Edge Parameters");
        AddFloatRow(t, "Threshold",       "_EdgeThreshold",     0f,    0.5f, 0.005f, 0.05f);
        AddFloatRow(t, "Edge Max",        "_EdgeMax",           0.05f, 2f,   0.05f,  0.50f);
        AddFloatRow(t, "Color Weight",    "_ColorEdgeWeight",   0f,    1f,   0.01f,  0.50f);
        AddFloatRow(t, "Line Strength",   "_InnerLineStrength", 0f,    1f,   0.01f,  1.00f);
        Space(t, 4);
        SectionLabel(t, "Line Color");
        AddColorRow(t, "Color", "_InnerLineColor", 0);
    }

    // ── Row builders ──────────────────────────────────────────────────────────
    void AddFloatRow(Transform parent, string label, string propName,
                     float min, float max, float step, float initial)
    {
        var (_, hl, valTxt, curTxt, col, slFill) = MakeRowShell(parent, label, hasSlider: true);
        valTxt.text = initial.ToString("F3");
        if (slFill != null)
        {
            float t = Mathf.InverseLerp(min, max, initial);
            slFill.rectTransform.anchorMax = new Vector2(t, 1f);
        }
        _rows.Add(new Row
        {
            kind = RowKind.Float, label = label, propName = propName,
            currentValue = initial, min = min, max = max, step = step,
            valueText = valTxt, highlight = hl, cursorText = curTxt,
            collider = col, sliderFill = slFill,
        });
    }

    void AddColorRow(Transform parent, string label, string propName, int startIndex)
    {
        var (_, hl, valTxt, curTxt, col, _) = MakeRowShell(parent, label, hasSlider: false);
        valTxt.text  = _colorPresets[startIndex].name;
        valTxt.color = new Color(0.7f, 0.7f, 0.7f);
        _rows.Add(new Row
        {
            kind = RowKind.Color, label = label, propName = propName,
            colorIndex = startIndex,
            valueText = valTxt, highlight = hl, cursorText = curTxt,
            collider = col, sliderFill = null,
        });
    }

    (GameObject, Image, Text, Text, BoxCollider, Image)
    MakeRowShell(Transform parent, string label, bool hasSlider)
    {
        const float ROW_H   = 56f;
        const float CHILD_H = 44f;

        var rowGo = Go("Row_" + label, parent);
        rowGo.GetComponent<RectTransform>().sizeDelta = new Vector2(0, ROW_H);

        var hlImg = rowGo.AddComponent<Image>();
        hlImg.color = Color.clear;

        var bc = rowGo.AddComponent<BoxCollider>();
        bc.size   = new Vector3(940f, ROW_H, 100f);
        bc.center = Vector3.zero;

        var hlg = rowGo.AddComponent<HorizontalLayoutGroup>();
        hlg.padding                = new RectOffset(10, 10, 6, 6);
        hlg.spacing                = 8;
        hlg.childAlignment         = TextAnchor.MiddleLeft;
        hlg.childControlHeight     = false;
        hlg.childControlWidth      = false;
        hlg.childForceExpandHeight = false;
        hlg.childForceExpandWidth  = false;

        // ► cursor indicator
        var cursorGo = Go("Cursor", rowGo.transform);
        var curTxt   = cursorGo.AddComponent<Text>();
        curTxt.text = "►"; curTxt.font = BuiltinFont(); curTxt.fontSize = 22;
        curTxt.color = Color.clear; curTxt.alignment = TextAnchor.MiddleCenter;
        cursorGo.GetComponent<RectTransform>().sizeDelta = new Vector2(28, CHILD_H);

        // Label
        var lGo  = Go("Lbl", rowGo.transform);
        var lTxt = lGo.AddComponent<Text>();
        lTxt.text = label; lTxt.font = BuiltinFont(); lTxt.fontSize = 22;
        lTxt.color = Color.white; lTxt.alignment = TextAnchor.MiddleLeft;
        lGo.GetComponent<RectTransform>().sizeDelta = new Vector2(220, CHILD_H);

        // Slider bar
        Image sliderFill = null;
        if (hasSlider)
        {
            var bgGo = Go("SliderBG", rowGo.transform);
            bgGo.AddComponent<Image>().color = new Color(0.18f, 0.18f, 0.18f, 1f);
            bgGo.GetComponent<RectTransform>().sizeDelta = new Vector2(480, CHILD_H);

            var fillGo  = Go("Fill", bgGo.transform);
            var fillImg = fillGo.AddComponent<Image>();
            fillImg.color = new Color(0.20f, 0.75f, 0.45f, 1f);
            var fillRt = fillGo.GetComponent<RectTransform>();
            fillRt.anchorMin = Vector2.zero;
            fillRt.anchorMax = new Vector2(0f, 1f);
            fillRt.offsetMin = fillRt.offsetMax = Vector2.zero;
            sliderFill = fillImg;
        }

        // Value text
        float valW = hasSlider ? 160f : 660f;
        var vGo  = Go("Val", rowGo.transform);
        var vTxt = vGo.AddComponent<Text>();
        vTxt.font = BuiltinFont(); vTxt.fontSize = 22;
        vTxt.color = new Color(1f, 0.85f, 0.35f);
        vTxt.alignment = hasSlider ? TextAnchor.MiddleRight : TextAnchor.MiddleLeft;
        vGo.GetComponent<RectTransform>().sizeDelta = new Vector2(valW, CHILD_H);

        return (rowGo, hlImg, vTxt, curTxt, bc, sliderFill);
    }

    // ── Ray line ──────────────────────────────────────────────────────────────
    void BuildRayLine()
    {
        var go = new GameObject("NPRRayLine");
        go.transform.SetParent(transform, false);
        _lr = go.AddComponent<LineRenderer>();
        _lr.positionCount = 2;
        _lr.startWidth = 0.003f; _lr.endWidth = 0.001f;
        _lr.useWorldSpace = true;
        _lr.material   = new Material(Shader.Find("Sprites/Default"));
        _lr.startColor = new Color(0.4f, 0.9f, 1f, 1f);
        _lr.endColor   = new Color(0.4f, 0.9f, 1f, 0.15f);
        _lr.gameObject.SetActive(false);
    }

    // ── Camera / controller lookup ────────────────────────────────────────────
    void ResolveCamera()
    {
        if (_anchor != null) { _camTransform = _anchor; return; }
        if (Camera.main != null) { _camTransform = Camera.main.transform; return; }
        foreach (var cam in FindObjectsOfType<Camera>())
        {
            string n = cam.gameObject.name;
            if (n.Contains("Eye") || n.Contains("Camera") || n.Contains("camera"))
            { _camTransform = cam.transform; return; }
        }
        var any = FindObjectOfType<Camera>();
        if (any != null) _camTransform = any.transform;
    }

    void ResolveController()
    {
        string[] names = { "RightControllerAnchor", "RightHandAnchor", "RightAnchor", "RightController" };
        foreach (var n in names) { var go = GameObject.Find(n); if (go != null) { _controllerTransform = go.transform; return; } }
        foreach (var go in FindObjectsOfType<GameObject>())
        {
            string n = go.name;
            if ((n.Contains("Right") || n.Contains("right")) && (n.Contains("Controller") || n.Contains("Hand") || n.Contains("Anchor")))
            { _controllerTransform = go.transform; return; }
        }
        _controllerTransform = _camTransform;
        Debug.LogWarning("[NPREdgeDetectionUI] Right controller not found; using camera fallback");
    }

    // ── UI helpers ────────────────────────────────────────────────────────────
    void Label(Transform parent, string text, int size, Color color)
    {
        var go = Go("Label", parent); var txt = go.AddComponent<Text>();
        txt.text = text; txt.font = BuiltinFont(); txt.fontSize = size;
        txt.color = color; txt.fontStyle = FontStyle.Bold; txt.alignment = TextAnchor.MiddleCenter;
        go.GetComponent<RectTransform>().sizeDelta = new Vector2(0, size + 10);
    }

    void SectionLabel(Transform parent, string text)
    {
        var go = Go("Section", parent); var txt = go.AddComponent<Text>();
        txt.text = "— " + text + " —"; txt.font = BuiltinFont(); txt.fontSize = 18;
        txt.color = new Color(0.55f, 0.85f, 0.55f); txt.fontStyle = FontStyle.Bold;
        txt.alignment = TextAnchor.MiddleLeft;
        go.GetComponent<RectTransform>().sizeDelta = new Vector2(0, 28);
    }

    void Space(Transform parent, float h)
        => Go("Space", parent).GetComponent<RectTransform>().sizeDelta = new Vector2(0, h);

    static GameObject Go(string name, Transform parent)
    {
        var go = new GameObject(name);
        go.transform.SetParent(parent, false);
        go.AddComponent<RectTransform>();
        return go;
    }

    static void Stretch(GameObject go)
    {
        var rt = go.GetComponent<RectTransform>();
        rt.anchorMin = Vector2.zero; rt.anchorMax = Vector2.one;
        rt.offsetMin = rt.offsetMax = Vector2.zero;
    }

    static Font _font;
    static Font BuiltinFont()
    {
        if (_font == null) _font = Resources.GetBuiltinResource<Font>("LegacyRuntime.ttf");
        return _font;
    }
}
