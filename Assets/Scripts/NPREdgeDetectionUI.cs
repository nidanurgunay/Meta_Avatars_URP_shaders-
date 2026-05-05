using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.InputSystem;

/// In-VR panel for live-tuning Avatar/MetaNPR edge-detection parameters.
/// Techniques: Derivative | Sobel | Normal+Fresnel | Gauss Sobel | Hierarchical | Kuwahara
/// Controls: B/Y/Tab = toggle | point ray + hold Trigger = drag slider | Grip = step | Trigger on Technique row = next
public class NPREdgeDetectionUI : MonoBehaviour
{
    [Header("Panel placement")]
    [SerializeField] private Transform _anchor;
    [SerializeField] private float _spawnDistance = 1.5f;
    [SerializeField] private float _spawnYOffset   = 0f;

    [Header("Panel size")]
    [SerializeField] private float _panelWidth = 1.5f;

    private const float CANVAS_W = 1000f;

    // ── Technique ─────────────────────────────────────────────────────────────
    private enum Technique { Derivative = 0, Sobel = 1, NormalEdge = 2, GaussSobel = 3, Hierarchical = 4, Kuwahara = 5 }
    private static readonly string[] TechniqueNames    = { "Derivative", "Sobel", "Normal+Fresnel", "Gauss Sobel", "Hierarchical", "Kuwahara" };
    private static readonly string[] TechniqueKeywords = { "", "EFFECT_SOBEL", "EFFECT_NORMAL_EDGE", "EFFECT_GAUSS_SOBEL", "EFFECT_HIERARCHICAL", "EFFECT_KUWAHARA" };
    private Technique _currentTechnique = Technique.Derivative;

    // ── Row data ──────────────────────────────────────────────────────────────
    private enum RowKind { Float, Color, TechSelector, Toggle }

    private struct Row
    {
        public RowKind     kind;
        public string      label;
        public string      propName;
        public float       currentValue;
        public float       min, max, step;
        public int         colorIndex;
        public int         techniqueFilter; // -1 = always visible, 0/1/2 = per technique
        public Text        valueText;
        public Image       highlight;
        public Text        cursorText;
        public BoxCollider collider;
        public Image       sliderFill;
        public GameObject  rowGo;
    }

    // ── Color presets ─────────────────────────────────────────────────────────
    private static readonly (string name, Color color)[] ColorPresets =
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

    [System.NonSerialized] private readonly List<Row> _rows = new();

    private int  _cursor     = -1;
    private int  _hoveredRow = -1;
    private bool _visible;

    private GameObject    _panel;
    private RectTransform _panelRt;
    private Transform     _camTransform;
    private Transform     _controllerTransform;
    private LineRenderer  _lr;

    [System.NonSerialized] private readonly List<Material> _nprMaterials = new();
    private float _materialRefreshTimer;
    private const float MATERIAL_REFRESH = 3f;

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
        PushAllValues();
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
                    _nprMaterials.Add(mat);
            }
        }
        Debug.Log("[NPREdgeDetectionUI] Found " + _nprMaterials.Count + " MetaNPR material(s).");
    }

    void SetShaderFloat(string prop, float val)
    {
        bool hit = false;
        foreach (var mat in _nprMaterials)
            if (mat != null && mat.HasProperty(prop)) { mat.SetFloat(prop, val); hit = true; }
        if (!hit) { RefreshNPRMaterials(); foreach (var mat in _nprMaterials) if (mat != null && mat.HasProperty(prop)) mat.SetFloat(prop, val); }
    }

    void SetShaderColor(string prop, Color c)
    {
        bool hit = false;
        foreach (var mat in _nprMaterials)
            if (mat != null && mat.HasProperty(prop)) { mat.SetColor(prop, c); hit = true; }
        if (!hit) { RefreshNPRMaterials(); foreach (var mat in _nprMaterials) if (mat != null && mat.HasProperty(prop)) mat.SetColor(prop, c); }
    }

    void SetPassEnabled(string passName, bool enabled)
    {
        foreach (var mat in _nprMaterials)
            if (mat != null) mat.SetShaderPassEnabled(passName, enabled);
    }

    void PushAllValues()
    {
        RefreshNPRMaterials();
        foreach (var row in _rows)
        {
            if (row.kind == RowKind.Float)
                SetShaderFloat(row.propName, row.currentValue);
            else if (row.kind == RowKind.Color)
            {
                var (_, c) = ColorPresets[row.colorIndex];
                SetShaderColor(row.propName, c);
            }
            else if (row.kind == RowKind.Toggle)
                SetPassEnabled(row.propName, row.currentValue > 0.5f);
        }
        ApplyTechniqueKeywords();
        Debug.Log("[NPREdgeDetectionUI] PushAll mats=" + _nprMaterials.Count
                  + " technique=" + TechniqueNames[(int)_currentTechnique]);
    }

    // ── Technique switching ───────────────────────────────────────────────────
    void SwitchTechnique(int delta)
    {
        int count = System.Enum.GetValues(typeof(Technique)).Length;
        _currentTechnique = (Technique)(((int)_currentTechnique + delta + count) % count);
        ApplyTechniqueKeywords();
        ApplyTechniqueVisibility();
        UpdateTechniqueLabel();
        // Push current values so the new technique gets the right starting values
        foreach (var row in _rows)
            if (row.kind == RowKind.Float && (row.techniqueFilter == -1 || row.techniqueFilter == (int)_currentTechnique))
                SetShaderFloat(row.propName, row.currentValue);
    }

    void ApplyTechniqueKeywords()
    {
        foreach (var mat in _nprMaterials)
        {
            if (mat == null) continue;
            foreach (var kw in TechniqueKeywords) if (kw.Length > 0) mat.DisableKeyword(kw);
            string active = TechniqueKeywords[(int)_currentTechnique];
            if (active.Length > 0) mat.EnableKeyword(active);
        }
    }

    void ApplyTechniqueVisibility()
    {
        int t = (int)_currentTechnique;
        for (int i = 0; i < _rows.Count; i++)
        {
            if (_rows[i].techniqueFilter == -1) continue; // always visible
            if (_rows[i].rowGo != null)
                _rows[i].rowGo.SetActive(_rows[i].techniqueFilter == t);
        }
    }

    void UpdateTechniqueLabel()
    {
        // Find the TechSelector row and update its value text
        for (int i = 0; i < _rows.Count; i++)
        {
            if (_rows[i].kind == RowKind.TechSelector && _rows[i].valueText != null)
            {
                _rows[i].valueText.text = TechniqueNames[(int)_currentTechnique];
                break;
            }
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    void Update()
    {
        _debugTimer += Time.deltaTime;
        if (_debugTimer >= 5f)
        {
            _debugTimer = 0f;
            Debug.Log("[NPREdgeDetectionUI] Heartbeat visible=" + _visible + " mats=" + _nprMaterials.Count);
        }

        if (_visible)
        {
            _materialRefreshTimer += Time.deltaTime;
            if (_materialRefreshTimer >= MATERIAL_REFRESH) { _materialRefreshTimer = 0f; PushAllValues(); }
        }

        bool bBtn = OVRInput.GetDown(OVRInput.Button.Two);
        bool yBtn = OVRInput.GetDown(OVRInput.Button.Four);
        bool tab  = Keyboard.current != null && Keyboard.current.tabKey.wasPressedThisFrame;
        if (bBtn || yBtn || tab) SetVisible(!_visible);

        if (!_visible) { if (_lr != null) _lr.gameObject.SetActive(false); return; }

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
                { closest = h.distance; newHover = i; rowHitPoint = h.point; }
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
        bool trigDown = OVRInput.GetDown(OVRInput.Button.PrimaryIndexTrigger)
                     || OVRInput.GetDown(OVRInput.Button.SecondaryIndexTrigger);
        bool decDown  = OVRInput.GetDown(OVRInput.Button.PrimaryHandTrigger)
                     || OVRInput.GetDown(OVRInput.Button.SecondaryHandTrigger);
        bool decHeld  = OVRInput.Get(OVRInput.Button.PrimaryHandTrigger)
                     || OVRInput.Get(OVRInput.Button.SecondaryHandTrigger);

        var row = _rows[_hoveredRow];

        switch (row.kind)
        {
            case RowKind.TechSelector:
                if (trigDown) SwitchTechnique(+1);
                if (decDown)  SwitchTechnique(-1);
                break;

            case RowKind.Float:
                if (trigHeld) DragSlider(_hoveredRow, rowHitPoint);
                if (decDown) { AdjustStep(-1f); _decCooldown = FIRST_REPEAT; }
                else if (decHeld) { _decCooldown -= Time.deltaTime; if (_decCooldown <= 0f) { _decCooldown = HOLD_REPEAT; AdjustStep(-1f); } }
                else _decCooldown = 0f;
                break;

            case RowKind.Color:
                if (trigDown) AdjustColor(+1);
                if (decDown)  AdjustColor(-1);
                break;

            case RowKind.Toggle:
                if (trigDown || decDown)
                {
                    var r = _rows[_hoveredRow];
                    r.currentValue = r.currentValue > 0.5f ? 0f : 1f;
                    bool on = r.currentValue > 0.5f;
                    r.valueText.text  = on ? "ON" : "OFF";
                    r.valueText.color = on ? new Color(0.4f, 0.9f, 1f) : new Color(0.5f, 0.5f, 0.5f);
                    _rows[_hoveredRow] = r;
                    SetPassEnabled(r.propName, on);
                }
                break;
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

        row.currentValue = newVal;
        row.valueText.text = newVal.ToString("F3");
        row.sliderFill.rectTransform.anchorMax = new Vector2(t, 1f);
        _rows[rowIndex] = row;
        SetShaderFloat(row.propName, newVal);
    }

    void AdjustStep(float direction)
    {
        if (_cursor < 0 || _cursor >= _rows.Count) return;
        var row = _rows[_cursor];
        if (row.kind != RowKind.Float) return;
        float next = Mathf.Clamp(row.currentValue + direction * row.step, row.min, row.max);
        float t    = Mathf.InverseLerp(row.min, row.max, next);
        row.currentValue = next;
        row.valueText.text = next.ToString("F3");
        if (row.sliderFill != null) row.sliderFill.rectTransform.anchorMax = new Vector2(t, 1f);
        _rows[_cursor] = row;
        SetShaderFloat(row.propName, next);
    }

    void AdjustColor(int direction)
    {
        if (_cursor < 0 || _cursor >= _rows.Count) return;
        var row = _rows[_cursor];
        if (row.kind != RowKind.Color) return;
        row.colorIndex = (int)Mathf.Repeat(row.colorIndex + direction, ColorPresets.Length);
        var (cname, c) = ColorPresets[row.colorIndex];
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
        if (row.cursorText != null) row.cursorText.color = on ? new Color(0.4f,  0.9f,  1f)         : Color.clear;
    }

    void SetVisible(bool v)
    {
        _visible = v;
        _panel.SetActive(v);
        if (v) { PlacePanel(); _materialRefreshTimer = MATERIAL_REFRESH; PushAllValues(); }
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
        _panelRt.sizeDelta = new Vector2(CANVAS_W, 1000f);
        ApplyPanelScale();

        var bg = Go("BG", _panel.transform);
        bg.AddComponent<Image>().color = new Color(0.07f, 0.07f, 0.07f, 0.95f);
        Stretch(bg);

        var host = Go("Host", _panel.transform);
        var vlg  = host.AddComponent<VerticalLayoutGroup>();
        vlg.padding               = new RectOffset(30, 30, 24, 24);
        vlg.spacing               = 8;
        vlg.childControlWidth     = true;
        vlg.childControlHeight    = false;
        vlg.childForceExpandWidth = true;
        Stretch(host);

        var t = host.transform;
        Label(t, "NPR EDGE DETECTION",                                      28, new Color(0.4f, 0.9f, 1f));
        Label(t, "Trigger = drag/next   Grip = step/prev   B/Y = close",    16, new Color(0.5f, 0.5f, 0.5f));
        Space(t, 6);

        // ── Technique selector (always visible) ──────────────────────────────
        AddTechSelectorRow(t);
        Space(t, 6);

        // ── Derivative parameters (technique 0) ──────────────────────────────
        SectionLabel(t, "Derivative Edge");
        AddFloatRow(t, 0, "Threshold",     "_EdgeThreshold",     0f,    0.5f, 0.005f, 0.05f);
        AddFloatRow(t, 0, "Edge Max",      "_EdgeMax",           0.05f, 2f,   0.05f,  0.50f);
        AddFloatRow(t, 0, "Color Weight",  "_ColorEdgeWeight",   0f,    1f,   0.01f,  0.50f);
        AddFloatRow(t, 0, "Line Strength", "_InnerLineStrength", 0f,    1f,   0.01f,  1.00f);

        // ── Sobel parameters (technique 1) ───────────────────────────────────
        SectionLabel(t, "Sobel Edge");
        AddFloatRow(t, 1, "Sample Dist",   "_SobelSampleDist",    0f,    10f,  0.1f,  0.5f);
        AddFloatRow(t, 1, "Thresh Skin",   "_SobelThreshSkin",    0f,    1f,   0.01f, 0.40f);
        AddFloatRow(t, 1, "Thresh Cloth",  "_SobelThreshClothes", 0f,    1f,   0.01f, 0.15f);
        AddFloatRow(t, 1, "Sobel Max",     "_SobelMax",           0.1f,  8f,   0.1f,  2.0f);
        AddFloatRow(t, 1, "Seam Limit",    "_SobelSeamLimit",     0f,    1f,   0.01f, 0.60f);
        AddFloatRow(t, 1, "Skin Sat Cut",  "_SobelSkinSatCutoff", 0f,    0.5f, 0.01f, 0.25f);
        AddFloatRow(t, 1, "Strength",      "_SobelStrength",      0f,    1f,   0.01f, 1.00f);

        // ── Normal+Fresnel parameters (technique 2) ──────────────────────────
        SectionLabel(t, "Normal+Fresnel Edge");
        AddFloatRow(t, 2, "Norm Thresh",    "_NormalEdgeThreshold",  0f,    1f,    0.01f, 0.30f);
        AddFloatRow(t, 2, "Norm Strength",  "_NormalEdgeStrength",   0f,    1f,    0.01f, 0.80f);
        AddFloatRow(t, 2, "Norm Smooth",    "_NormalEdgeSmoothness", 0.01f, 0.5f,  0.01f, 0.10f);
        AddFloatRow(t, 2, "Fresnel Thresh", "_FresnelEdgeThreshold", 0f,    1f,    0.01f, 0.30f);
        AddFloatRow(t, 2, "Fresnel Str",    "_FresnelEdgeStrength",  0f,    1f,    0.01f, 0.50f);

        // ── Gaussian Sobel parameters (technique 3) ──────────────────────────
        SectionLabel(t, "Gaussian Sobel Edge");
        AddFloatRow(t, 3, "Sample Dist",  "_GSobelSampleDist", 0f,    10f,  0.1f,  1.00f);
        AddFloatRow(t, 3, "Blur Radius",  "_GSobelBlurRadius", 0f,    5f,   0.1f,  1.00f);
        AddFloatRow(t, 3, "Threshold",    "_GSobelThreshold",  0f,    0.5f, 0.005f,0.15f);
        AddFloatRow(t, 3, "Strength",     "_GSobelStrength",   0f,    1f,   0.01f, 1.00f);

        // ── Hierarchical parameters (technique 4) ────────────────────────────
        SectionLabel(t, "Hierarchical Edge");
        AddFloatRow(t, 4, "Depth Thresh",  "_HDepthThreshold",   0.001f,0.2f, 0.005f,0.02f);
        AddFloatRow(t, 4, "Norm Thresh",   "_HNormalThreshold",  0.05f, 1f,   0.01f, 0.30f);
        AddFloatRow(t, 4, "Color Thresh",  "_HColorThreshold",   0.01f, 0.5f, 0.01f, 0.10f);
        AddFloatRow(t, 4, "Depth Weight",  "_HDepthWeight",      0f,    1f,   0.01f, 0.80f);
        AddFloatRow(t, 4, "Norm Weight",   "_HNormalWeight",     0f,    1f,   0.01f, 0.80f);
        AddFloatRow(t, 4, "Color Weight",  "_HColorWeight",      0f,    1f,   0.01f, 0.60f);
        AddFloatRow(t, 4, "Edge Width",    "_HEdgeWidth",        0.5f,  10f,  0.1f,  1.50f);
        AddFloatRow(t, 4, "Adaptive Str",  "_HAdaptiveStrength", 0f,    1f,   0.01f, 0.50f);

        // ── Kuwahara parameters (technique 5) ────────────────────────────────
        SectionLabel(t, "Kuwahara Filter");
        AddFloatRow(t, 5, "Radius",   "_KuwaharaRadius",   0.5f, 8f, 0.1f, 2.0f);
        AddFloatRow(t, 5, "Strength", "_KuwaharaStrength", 0f,   1f, 0.01f, 1.0f);

        // ── Inverted Hull Outline (always visible) ────────────────────────────
        Space(t, 4);
        SectionLabel(t, "Inverted Hull Outline");
        AddToggleRow(t, -1, "Outline",       "NPROutline",    false);
        AddFloatRow( t, -1, "Width",         "_OutlineWidth", 0.5f, 10f, 0.1f, 2.0f);
        AddColorRow( t, -1, "Outline Color", "_OutlineColor", 0);

        // ── Color (always visible) ────────────────────────────────────────────
        Space(t, 4);
        SectionLabel(t, "Line Color");
        AddColorRow(t, -1, "Color", "_InnerLineColor", 0);

        ApplyTechniqueVisibility();
    }

    // ── Row builders ──────────────────────────────────────────────────────────
    void AddTechSelectorRow(Transform parent)
    {
        var (rowGo, hl, valTxt, curTxt, col, _) = MakeRowShell(parent, "Technique", hasSlider: false);
        valTxt.text  = TechniqueNames[(int)_currentTechnique];
        valTxt.color = new Color(0.4f, 0.9f, 1f);
        _rows.Add(new Row
        {
            kind = RowKind.TechSelector, label = "Technique", techniqueFilter = -1,
            valueText = valTxt, highlight = hl, cursorText = curTxt,
            collider = col, rowGo = rowGo,
        });
    }

    void AddFloatRow(Transform parent, int techniqueFilter, string label, string propName,
                     float min, float max, float step, float initial)
    {
        var (rowGo, hl, valTxt, curTxt, col, slFill) = MakeRowShell(parent, label, hasSlider: true);
        valTxt.text = initial.ToString("F3");
        if (slFill != null)
            slFill.rectTransform.anchorMax = new Vector2(Mathf.InverseLerp(min, max, initial), 1f);
        _rows.Add(new Row
        {
            kind = RowKind.Float, label = label, propName = propName,
            currentValue = initial, min = min, max = max, step = step,
            techniqueFilter = techniqueFilter,
            valueText = valTxt, highlight = hl, cursorText = curTxt,
            collider = col, sliderFill = slFill, rowGo = rowGo,
        });
    }

    void AddToggleRow(Transform parent, int techniqueFilter, string label, string passName, bool initial)
    {
        var (rowGo, hl, valTxt, curTxt, col, _) = MakeRowShell(parent, label, hasSlider: false);
        valTxt.text  = initial ? "ON" : "OFF";
        valTxt.color = initial ? new Color(0.4f, 0.9f, 1f) : new Color(0.5f, 0.5f, 0.5f);
        _rows.Add(new Row
        {
            kind = RowKind.Toggle, label = label, propName = passName,
            currentValue = initial ? 1f : 0f, techniqueFilter = techniqueFilter,
            valueText = valTxt, highlight = hl, cursorText = curTxt,
            collider = col, rowGo = rowGo,
        });
    }

    void AddColorRow(Transform parent, int techniqueFilter, string label, string propName, int startIndex)
    {
        var (rowGo, hl, valTxt, curTxt, col, _) = MakeRowShell(parent, label, hasSlider: false);
        valTxt.text  = ColorPresets[startIndex].name;
        valTxt.color = new Color(0.7f, 0.7f, 0.7f);
        _rows.Add(new Row
        {
            kind = RowKind.Color, label = label, propName = propName,
            colorIndex = startIndex, techniqueFilter = techniqueFilter,
            valueText = valTxt, highlight = hl, cursorText = curTxt,
            collider = col, rowGo = rowGo,
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

        var cursorGo = Go("Cursor", rowGo.transform);
        var curTxt   = cursorGo.AddComponent<Text>();
        curTxt.text = "►"; curTxt.font = BuiltinFont(); curTxt.fontSize = 22;
        curTxt.color = Color.clear; curTxt.alignment = TextAnchor.MiddleCenter;
        cursorGo.GetComponent<RectTransform>().sizeDelta = new Vector2(28, CHILD_H);

        var lGo  = Go("Lbl", rowGo.transform);
        var lTxt = lGo.AddComponent<Text>();
        lTxt.text = label; lTxt.font = BuiltinFont(); lTxt.fontSize = 22;
        lTxt.color = Color.white; lTxt.alignment = TextAnchor.MiddleLeft;
        lGo.GetComponent<RectTransform>().sizeDelta = new Vector2(220, CHILD_H);

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
