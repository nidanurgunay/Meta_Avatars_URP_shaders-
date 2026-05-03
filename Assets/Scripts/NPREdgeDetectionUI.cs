#if USING_XR_MANAGEMENT && (USING_XR_SDK_OCULUS || USING_XR_SDK_OPENXR) && !OVRPLUGIN_UNSUPPORTED_PLATFORM
#define USING_XR_SDK
#endif

using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using UnityEngine.InputSystem;

/// In-VR panel for tuning NPR edge detection parameters on Avatar/MetaNPR shader.
/// Parameters are applied globally via Shader.SetGlobalFloat/Color so every
/// avatar using that shader responds instantly.
/// Toggle visibility with B (right controller), Y (left controller), or Tab.
/// Attach to OVRCameraRig or any persistent scene object.
public class NPREdgeDetectionUI : MonoBehaviour
{
    [Header("Panel placement")]
    [SerializeField] private Transform _camera;
    [SerializeField] private float _spawnDistance = 1.5f;
    [SerializeField] private float _spawnYOffset   = 0.1f;

    // ── Default parameter values (matching MetaNPRShaderConfiguration) ─────────
    [Header("Initial Values")]
    [SerializeField, Range(0f,   0.5f)] private float _initThreshold    = 0.05f;
    [SerializeField, Range(0.05f, 2f)]  private float _initMax          = 0.5f;
    [SerializeField, Range(0f,   1f)]   private float _initColorWeight  = 0.5f;
    [SerializeField, Range(0f,   1f)]   private float _initLineStrength = 1.0f;
    [SerializeField]                    private Color _initLineColor     = Color.black;

    // ── Internals ─────────────────────────────────────────────────────────────
    private GameObject _panel;
    private bool       _visible;

    private struct SliderRow
    {
        public Slider        slider;
        public Text          valueText;
        public Action<float> apply;
        public Func<float>   read;
    }
    private readonly List<SliderRow> _rows = new List<SliderRow>();

    // Live color state (preset buttons write here)
    private Color  _currentColor;
    private Image  _colorSwatch;

    // Shader property IDs (cached for efficiency)
    private static readonly int ID_Threshold    = Shader.PropertyToID("_EdgeThreshold");
    private static readonly int ID_Max          = Shader.PropertyToID("_EdgeMax");
    private static readonly int ID_ColorWeight  = Shader.PropertyToID("_ColorEdgeWeight");
    private static readonly int ID_LineStrength = Shader.PropertyToID("_InnerLineStrength");
    private static readonly int ID_LineColor    = Shader.PropertyToID("_InnerLineColor");

    // ─────────────────────────────────────────────────────────────────────────
    void Start()
    {
        if (_camera == null)
        {
            if (Camera.main != null)
                _camera = Camera.main.transform;
            else
            {
                var cam = GetComponentInChildren<Camera>(true);
                if (cam != null) _camera = cam.transform;
            }
        }

        _currentColor = _initLineColor;

        // Push initial values so the shader starts with Inspector defaults
        Shader.SetGlobalFloat(ID_Threshold,    _initThreshold);
        Shader.SetGlobalFloat(ID_Max,          _initMax);
        Shader.SetGlobalFloat(ID_ColorWeight,  _initColorWeight);
        Shader.SetGlobalFloat(ID_LineStrength, _initLineStrength);
        Shader.SetGlobalColor(ID_LineColor,    _initLineColor);

        EnsureEventSystem();
        BuildPanel();
        SetVisible(false);
    }

    void Update()
    {
        bool toggle = false;
#if USING_XR_SDK
        toggle |= OVRInput.GetDown(OVRInput.Button.Two);   // B
        toggle |= OVRInput.GetDown(OVRInput.Button.Four);  // Y
#endif
        toggle |= Keyboard.current?.tabKey.wasPressedThisFrame == true;

        if (toggle)
            SetVisible(!_visible);

        if (_visible && _camera != null)
        {
            Vector3 toCam = _camera.position - _panel.transform.position;
            toCam.y = 0f;
            if (toCam.sqrMagnitude > 0.001f)
                _panel.transform.rotation = Quaternion.LookRotation(-toCam.normalized, Vector3.up);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    void SetVisible(bool v)
    {
        _visible = v;
        if (v)
        {
            foreach (var row in _rows)
                row.slider.SetValueWithoutNotify(row.read());
            PlaceInFrontOfCamera();
        }
        _panel.SetActive(v);
    }

    void PlaceInFrontOfCamera()
    {
        if (_camera == null) return;
        Vector3 fwd = _camera.forward;
        fwd.y = 0f;
        if (fwd.sqrMagnitude < 0.001f) fwd = Vector3.forward;
        fwd.Normalize();
        _panel.transform.position = _camera.position
                                  + fwd   * _spawnDistance
                                  + Vector3.up * _spawnYOffset;
        _panel.transform.rotation = Quaternion.LookRotation(fwd, Vector3.up);
    }

    // ─────────────────────────────────────────────────────────────────────────
    void BuildPanel()
    {
        _panel = new GameObject("NPREdgePanel");
        _panel.transform.SetParent(transform, false);

        var canvas = _panel.AddComponent<Canvas>();
        canvas.renderMode = RenderMode.WorldSpace;
        _panel.AddComponent<GraphicRaycaster>();

        var canvasRt = _panel.GetComponent<RectTransform>();
        canvasRt.sizeDelta  = new Vector2(520, 620);
        canvasRt.localScale = Vector3.one * 0.05f;

        // Background
        var bg = NewGo("Background", _panel.transform);
        bg.AddComponent<Image>().color = new Color(0.06f, 0.06f, 0.06f, 0.93f);
        StretchRect(bg.GetComponent<RectTransform>());

        // Vertical layout host
        var host = NewGo("Host", _panel.transform);
        var vlg  = host.AddComponent<VerticalLayoutGroup>();
        vlg.padding               = new RectOffset(18, 18, 14, 14);
        vlg.spacing               = 7;
        vlg.childControlWidth     = true;
        vlg.childControlHeight    = false;
        vlg.childForceExpandWidth = true;
        StretchRect(host.GetComponent<RectTransform>());

        var t = host.transform;

        MakeLabel(t, "NPR  EDGE  DETECTION", 17, new Color(0.4f, 0.9f, 1f));
        MakeLabel(t, "B / Y button  or  Tab  to  close", 10, new Color(0.55f, 0.55f, 0.55f));
        Spacer(t, 6);

        // ── Sliders ───────────────────────────────────────────────────────────
        SectionLabel(t, "Edge Detection");

        AddRow(t, "Threshold",    0f,    0.5f,
            v => Shader.SetGlobalFloat(ID_Threshold,    v),
            () => Shader.GetGlobalFloat(ID_Threshold));

        AddRow(t, "Max Cutoff",   0.05f, 2f,
            v => Shader.SetGlobalFloat(ID_Max,          v),
            () => Shader.GetGlobalFloat(ID_Max));

        AddRow(t, "Color Weight", 0f,    1f,
            v => Shader.SetGlobalFloat(ID_ColorWeight,  v),
            () => Shader.GetGlobalFloat(ID_ColorWeight));

        AddRow(t, "Line Strength", 0f,   1f,
            v => Shader.SetGlobalFloat(ID_LineStrength, v),
            () => Shader.GetGlobalFloat(ID_LineStrength));

        Spacer(t, 6);

        // ── Color presets ─────────────────────────────────────────────────────
        SectionLabel(t, "Line Color");
        BuildColorPresets(t);
    }

    // ── Color preset row ──────────────────────────────────────────────────────
    void BuildColorPresets(Transform parent)
    {
        // Swatch row showing current color
        {
            var row = NewGo("SwatchRow", parent);
            var hlg = row.AddComponent<HorizontalLayoutGroup>();
            hlg.spacing = 8;
            hlg.childControlHeight = true;
            hlg.childControlWidth  = false;
            hlg.childForceExpandHeight = false;
            row.GetComponent<RectTransform>().sizeDelta = new Vector2(0, 28);

            var lbl = NewGo("Lbl", row.transform);
            var txt = lbl.AddComponent<Text>();
            txt.text      = "Current";
            txt.font      = BuiltinFont();
            txt.fontSize  = 13;
            txt.color     = Color.white;
            txt.alignment = TextAnchor.MiddleLeft;
            lbl.GetComponent<RectTransform>().sizeDelta = new Vector2(90, 28);

            var sw = NewGo("Swatch", row.transform);
            _colorSwatch = sw.AddComponent<Image>();
            _colorSwatch.color = _currentColor;
            sw.GetComponent<RectTransform>().sizeDelta = new Vector2(60, 24);
        }

        Spacer(parent, 4);

        // Preset button grid – 2 rows of 4
        var presets = new (string label, Color color)[]
        {
            ("Black",    Color.black),
            ("Navy",     new Color(0.05f, 0.05f, 0.25f)),
            ("Dark Red", new Color(0.25f, 0.02f, 0.02f)),
            ("Brown",    new Color(0.2f,  0.1f,  0.0f)),
            ("Gray",     new Color(0.3f,  0.3f,  0.3f)),
            ("White",    Color.white),
            ("Cyan",     new Color(0.0f,  0.6f,  0.8f)),
            ("Gold",     new Color(0.8f,  0.6f,  0.0f)),
        };

        for (int i = 0; i < presets.Length; i += 4)
            BuildPresetButtonRow(parent, presets, i, Mathf.Min(i + 4, presets.Length));
    }

    void BuildPresetButtonRow(Transform parent, (string label, Color color)[] presets, int from, int to)
    {
        var row = NewGo("PresetRow", parent);
        var hlg = row.AddComponent<HorizontalLayoutGroup>();
        hlg.spacing = 6;
        hlg.childControlHeight    = true;
        hlg.childControlWidth     = false;
        hlg.childForceExpandHeight = false;
        row.GetComponent<RectTransform>().sizeDelta = new Vector2(0, 34);

        for (int i = from; i < to; i++)
        {
            var (label, color) = presets[i];
            var c = color;  // capture

            var btn = NewGo($"Btn_{label}", row.transform);
            var img = btn.AddComponent<Image>();
            img.color = new Color(0.22f, 0.22f, 0.22f);
            var b = btn.AddComponent<Button>();
            btn.GetComponent<RectTransform>().sizeDelta = new Vector2(110, 30);

            var txtGo = NewGo("BtnText", btn.transform);
            var txt   = txtGo.AddComponent<Text>();
            txt.text      = label;
            txt.font      = BuiltinFont();
            txt.fontSize  = 11;
            txt.color     = Color.white;
            txt.alignment = TextAnchor.MiddleCenter;
            StretchRect(txtGo.GetComponent<RectTransform>());

            b.onClick.AddListener(() =>
            {
                _currentColor = c;
                if (_colorSwatch != null) _colorSwatch.color = c;
                Shader.SetGlobalColor(ID_LineColor, c);
            });
        }
    }

    // ── Slider row ────────────────────────────────────────────────────────────
    void AddRow(Transform parent, string label, float min, float max,
                Action<float> apply, Func<float> read)
    {
        var row = NewGo($"Row_{label}", parent);
        var hlg = row.AddComponent<HorizontalLayoutGroup>();
        hlg.spacing = 8;
        hlg.childControlHeight    = true;
        hlg.childControlWidth     = false;
        hlg.childForceExpandHeight = false;
        row.GetComponent<RectTransform>().sizeDelta = new Vector2(0, 28);

        var nameGo   = NewGo("Name", row.transform);
        var nameText = nameGo.AddComponent<Text>();
        nameText.text      = label;
        nameText.font      = BuiltinFont();
        nameText.fontSize  = 13;
        nameText.color     = Color.white;
        nameText.alignment = TextAnchor.MiddleLeft;
        nameGo.GetComponent<RectTransform>().sizeDelta = new Vector2(130, 28);

        float initial = read();
        var valGo   = NewGo("Val", row.transform);
        var valText = valGo.AddComponent<Text>();
        valText.text      = initial.ToString("F3");
        valText.font      = BuiltinFont();
        valText.fontSize  = 13;
        valText.color     = new Color(1f, 0.85f, 0.35f);
        valText.alignment = TextAnchor.MiddleRight;
        valGo.GetComponent<RectTransform>().sizeDelta = new Vector2(48, 28);

        var slider = BuildSlider(row.transform, min, max, initial);
        slider.GetComponent<RectTransform>().sizeDelta = new Vector2(280, 22);

        slider.onValueChanged.AddListener(v =>
        {
            valText.text = v.ToString("F3");
            apply(v);
        });

        _rows.Add(new SliderRow { slider = slider, valueText = valText, apply = apply, read = read });
    }

    // ── Slider factory ────────────────────────────────────────────────────────
    Slider BuildSlider(Transform parent, float min, float max, float initial)
    {
        var go = NewGo("Slider", parent);
        go.AddComponent<Image>().color = new Color(0.22f, 0.22f, 0.22f);

        var slider    = go.AddComponent<Slider>();
        slider.minValue = min;
        slider.maxValue = max;

        var fillArea = NewGo("Fill Area", go.transform);
        var faRt     = fillArea.GetComponent<RectTransform>();
        faRt.anchorMin = new Vector2(0f, 0.25f);
        faRt.anchorMax = new Vector2(1f, 0.75f);
        faRt.offsetMin = new Vector2(4f, 0f);
        faRt.offsetMax = new Vector2(-14f, 0f);

        var fill    = NewGo("Fill", fillArea.transform);
        var fillImg = fill.AddComponent<Image>();
        fillImg.color = new Color(0.25f, 0.65f, 1f);
        fill.GetComponent<RectTransform>().sizeDelta = Vector2.zero;

        var handleArea = NewGo("Handle Area", go.transform);
        var haRt       = handleArea.GetComponent<RectTransform>();
        haRt.anchorMin = Vector2.zero;
        haRt.anchorMax = Vector2.one;
        haRt.offsetMin = new Vector2(8f, 0f);
        haRt.offsetMax = new Vector2(-8f, 0f);

        var handle    = NewGo("Handle", handleArea.transform);
        var handleImg = handle.AddComponent<Image>();
        handleImg.color = Color.white;
        handle.GetComponent<RectTransform>().sizeDelta = new Vector2(18f, 0f);

        slider.fillRect      = fill.GetComponent<RectTransform>();
        slider.handleRect    = handle.GetComponent<RectTransform>();
        slider.targetGraphic = handleImg;
        slider.SetValueWithoutNotify(initial);

        return slider;
    }

    // ── UI helpers ────────────────────────────────────────────────────────────
    void MakeLabel(Transform parent, string text, int size, Color color)
    {
        var go  = NewGo("Label", parent);
        var txt = go.AddComponent<Text>();
        txt.text      = text;
        txt.font      = BuiltinFont();
        txt.fontSize  = size;
        txt.color     = color;
        txt.fontStyle = FontStyle.Bold;
        txt.alignment = TextAnchor.MiddleCenter;
        go.GetComponent<RectTransform>().sizeDelta = new Vector2(0, size + 6);
    }

    void SectionLabel(Transform parent, string text)
    {
        var go  = NewGo("Section", parent);
        var txt = go.AddComponent<Text>();
        txt.text      = "— " + text + " —";
        txt.font      = BuiltinFont();
        txt.fontSize  = 12;
        txt.color     = new Color(0.55f, 0.85f, 0.55f);
        txt.fontStyle = FontStyle.Bold;
        txt.alignment = TextAnchor.MiddleLeft;
        go.GetComponent<RectTransform>().sizeDelta = new Vector2(0, 20);
    }

    void Spacer(Transform parent, float height)
    {
        var go = NewGo("Spacer", parent);
        go.GetComponent<RectTransform>().sizeDelta = new Vector2(0, height);
    }

    static GameObject NewGo(string name, Transform parent)
    {
        var go = new GameObject(name);
        go.transform.SetParent(parent, false);
        go.AddComponent<RectTransform>();
        return go;
    }

    static void StretchRect(RectTransform rt)
    {
        rt.anchorMin = Vector2.zero;
        rt.anchorMax = Vector2.one;
        rt.offsetMin = rt.offsetMax = Vector2.zero;
    }

    static Font _builtinFont;
    static Font BuiltinFont()
    {
        if (_builtinFont == null)
            _builtinFont = Resources.GetBuiltinResource<Font>("LegacyRuntime.ttf");
        return _builtinFont;
    }

    // ── EventSystem ───────────────────────────────────────────────────────────
    static void EnsureEventSystem()
    {
        var es = FindObjectOfType<EventSystem>();
        if (es == null)
        {
            var go = new GameObject("EventSystem");
            es = go.AddComponent<EventSystem>();
#if USING_XR_SDK
            go.AddComponent<OVRInputModule>();
#else
            go.AddComponent<StandaloneInputModule>();
#endif
        }
#if USING_XR_SDK
        if (es.GetComponent<OVRInputModule>() == null)
            es.gameObject.AddComponent<OVRInputModule>();
#endif
    }
}
