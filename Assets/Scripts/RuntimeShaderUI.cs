#if USING_XR_MANAGEMENT && (USING_XR_SDK_OCULUS || USING_XR_SDK_OPENXR) && !OVRPLUGIN_UNSUPPORTED_PLATFORM
#define USING_XR_SDK
#endif

using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using UnityEngine.InputSystem;

/// In-VR shader parameter panel.
/// Toggle with B (right controller) or Tab (keyboard/editor).
/// Attach to OVRCameraRig (or any persistent scene object).
/// Assign one or more AvatarShaderSwapper targets — sliders control all of them.
public class RuntimeShaderUI : MonoBehaviour
{
    [Header("Targets — all swappers are controlled together")]
    [SerializeField] private AvatarShaderSwapper[] _swappers;

    [Header("Panel placement")]
    [Tooltip("The transform to spawn the panel in front of. Leave empty to use Camera.main.")]
    [SerializeField] private Transform _camera;
    [SerializeField] private float _spawnDistance = 1.5f;
    [SerializeField] private float _spawnYOffset  = 0f;

    // ── Internals ─────────────────────────────────────────────────────────────
    private GameObject _panel;
    private bool       _visible;

    private struct Row
    {
        public Slider          slider;
        public Text            valueText;
        public Action<float>   apply;
        public Func<float>     read;
    }
    private readonly List<Row> _rows = new List<Row>();

    // ─────────────────────────────────────────────────────────────────────────
    void Start()
    {
        if (_camera == null)
        {
            if (Camera.main != null)
                _camera = Camera.main.transform;
            else
            {
                // OVR scenes don't tag CenterEyeAnchor as MainCamera — search children instead
                var cam = GetComponentInChildren<Camera>(true);
                if (cam != null) _camera = cam.transform;
            }
        }

        EnsureEventSystem();
        BuildPanel();
        SetVisible(false);
    }

    void Update()
    {
        bool toggle = false;
        toggle |= OVRInput.GetDown(OVRInput.Button.Two);  // B (right controller)
        toggle |= OVRInput.GetDown(OVRInput.Button.Four); // Y (left controller)
        toggle |= Keyboard.current?.tabKey.wasPressedThisFrame == true;

        if (toggle)
            SetVisible(!_visible);

        // Keep the panel facing the camera while open
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
            // Refresh sliders to reflect current swapper values before showing
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
                                  + fwd * _spawnDistance
                                  + Vector3.up * _spawnYOffset;
        _panel.transform.rotation = Quaternion.LookRotation(fwd, Vector3.up);
    }

    // ─────────────────────────────────────────────────────────────────────────
    void BuildPanel()
    {
        // Root canvas
        _panel = new GameObject("RuntimeShaderPanel");
        _panel.transform.SetParent(transform, false);

        var canvas = _panel.AddComponent<Canvas>();
        canvas.renderMode = RenderMode.WorldSpace;
        _panel.AddComponent<GraphicRaycaster>();

        var canvasRt = _panel.GetComponent<RectTransform>();
        canvasRt.sizeDelta  = new Vector2(520, 760);
        canvasRt.localScale = Vector3.one * 0.05f;

        // Dark background
        var bg = NewGo("Background", _panel.transform);
        var bgImg = bg.AddComponent<Image>();
        bgImg.color = new Color(0.06f, 0.06f, 0.06f, 0.93f);
        StretchRect(bg.GetComponent<RectTransform>());

        // Vertical layout host
        var host = NewGo("Host", _panel.transform);
        var vlg   = host.AddComponent<VerticalLayoutGroup>();
        vlg.padding              = new RectOffset(18, 18, 14, 14);
        vlg.spacing              = 7;
        vlg.childControlWidth    = true;
        vlg.childControlHeight   = false;
        vlg.childForceExpandWidth = true;
        StretchRect(host.GetComponent<RectTransform>());

        var t = host.transform;

        // Title
        MakeLabel(t, "SHADER  DEBUG  PANEL", 17, new Color(0.4f, 0.9f, 1f));
        MakeLabel(t, "B button or Tab to close", 11, new Color(0.6f, 0.6f, 0.6f));
        Spacer(t, 4);

        // ── Inner Edge Detection ──────────────────────────────────────────────
        SectionLabel(t, "Inner Edge Detection  (V3/V4)");
        AddRow(t, "Skin Threshold",    0f, 1f,
            v => Each(s => s.InnerLineThresholdSkin    = v),
            () => First()?.InnerLineThresholdSkin    ?? 0.4f);
        AddRow(t, "Clothes Threshold", 0f, 1f,
            v => Each(s => s.InnerLineThresholdClothes = v),
            () => First()?.InnerLineThresholdClothes ?? 0.1f);
        AddRow(t, "Sat. Cutoff",       0f, 0.5f,
            v => Each(s => s.SkinSaturationCutoff      = v),
            () => First()?.SkinSaturationCutoff      ?? 0.25f);
        AddRow(t, "Seam Max",          0.1f, 8f,
            v => Each(s => s.InnerLineMax              = v),
            () => First()?.InnerLineMax              ?? 2f);
        AddRow(t, "Seam Range Lmt",    0f, 1f,
            v => Each(s => s.SeamRangeLimit            = v),
            () => First()?.SeamRangeLimit            ?? 0.6f);
        AddRow(t, "Edge Blur",         0f, 10f,
            v => Each(s => s.InnerLineBlur              = v),
            () => First()?.InnerLineBlur              ?? 0.5f);
        AddRow(t, "Edge Strength",     0f, 1f,
            v => Each(s => s.InnerLineStrength          = v),
            () => First()?.InnerLineStrength          ?? 1f);

        Spacer(t, 4);

        // ── Toon Shading ──────────────────────────────────────────────────────
        SectionLabel(t, "Toon Shading");
        AddRow(t, "Steps",            1f, 10f,
            v => Each(s => s.ToonSteps      = v),
            () => First()?.ToonSteps      ?? 3f);
        AddRow(t, "Shadow Strength",  0f, 1f,
            v => Each(s => s.ShadowStrength = v),
            () => First()?.ShadowStrength ?? 0.7f);

        Spacer(t, 4);

        // ── Outline ───────────────────────────────────────────────────────────
        SectionLabel(t, "Outer Outline");
        AddRow(t, "Width",    0f, 0.05f,
            v => Each(s => s.OutlineWidth = v),
            () => First()?.OutlineWidth ?? 0.003f);

        Spacer(t, 4);

        // ── Rim ───────────────────────────────────────────────────────────────
        SectionLabel(t, "Rim Light");
        AddRow(t, "Rim Power", 0.5f, 10f,
            v => Each(s => s.RimPower = v),
            () => First()?.RimPower ?? 3f);
    }

    // ── Row builder ───────────────────────────────────────────────────────────
    void AddRow(Transform parent, string label, float min, float max,
                Action<float> apply, Func<float> read)
    {
        var row = NewGo($"Row_{label}", parent);
        var hlg = row.AddComponent<HorizontalLayoutGroup>();
        hlg.spacing            = 8;
        hlg.childControlHeight = true;
        hlg.childControlWidth  = false;
        hlg.childForceExpandHeight = false;
        row.GetComponent<RectTransform>().sizeDelta = new Vector2(0, 28);

        // Name text
        var nameGo = NewGo("Name", row.transform);
        var nameText = nameGo.AddComponent<Text>();
        nameText.text      = label;
        nameText.font      = BuiltinFont();
        nameText.fontSize  = 13;
        nameText.color     = Color.white;
        nameText.alignment = TextAnchor.MiddleLeft;
        nameGo.GetComponent<RectTransform>().sizeDelta = new Vector2(150, 28);

        // Value text
        float initial = read();
        var valGo = NewGo("Val", row.transform);
        var valText = valGo.AddComponent<Text>();
        valText.text      = initial.ToString("F3");
        valText.font      = BuiltinFont();
        valText.fontSize  = 13;
        valText.color     = new Color(1f, 0.85f, 0.35f);
        valText.alignment = TextAnchor.MiddleRight;
        valGo.GetComponent<RectTransform>().sizeDelta = new Vector2(48, 28);

        // Slider
        var slider = BuildSlider(row.transform, min, max, initial);
        slider.GetComponent<RectTransform>().sizeDelta = new Vector2(260, 22);

        slider.onValueChanged.AddListener(v =>
        {
            valText.text = v.ToString("F3");
            apply(v);
        });

        _rows.Add(new Row { slider = slider, valueText = valText, apply = apply, read = read });
    }

    // ── Slider factory ────────────────────────────────────────────────────────
    Slider BuildSlider(Transform parent, float min, float max, float initial)
    {
        var go = NewGo("Slider", parent);
        var bgImg = go.AddComponent<Image>();
        bgImg.color = new Color(0.22f, 0.22f, 0.22f, 1f);

        var slider = go.AddComponent<Slider>();
        slider.minValue = min;
        slider.maxValue = max;

        // Fill area
        var fillArea = NewGo("Fill Area", go.transform);
        var faRt = fillArea.GetComponent<RectTransform>();
        faRt.anchorMin = new Vector2(0f, 0.25f);
        faRt.anchorMax = new Vector2(1f, 0.75f);
        faRt.offsetMin = new Vector2(4f, 0f);
        faRt.offsetMax = new Vector2(-14f, 0f);

        var fill = NewGo("Fill", fillArea.transform);
        var fillImg = fill.AddComponent<Image>();
        fillImg.color = new Color(0.25f, 0.65f, 1f);
        var fillRt = fill.GetComponent<RectTransform>();
        fillRt.sizeDelta = Vector2.zero;

        // Handle
        var handleArea = NewGo("Handle Area", go.transform);
        var haRt = handleArea.GetComponent<RectTransform>();
        haRt.anchorMin = Vector2.zero;
        haRt.anchorMax = Vector2.one;
        haRt.offsetMin = new Vector2(8f, 0f);
        haRt.offsetMax = new Vector2(-8f, 0f);

        var handle = NewGo("Handle", handleArea.transform);
        var handleImg = handle.AddComponent<Image>();
        handleImg.color = Color.white;
        handle.GetComponent<RectTransform>().sizeDelta = new Vector2(18f, 0f);

        slider.fillRect     = fillRt;
        slider.handleRect   = handle.GetComponent<RectTransform>();
        slider.targetGraphic = handleImg;
        slider.SetValueWithoutNotify(initial);

        return slider;
    }

    // ── UI helpers ────────────────────────────────────────────────────────────
    void MakeLabel(Transform parent, string text, int size, Color color)
    {
        var go = NewGo("Label", parent);
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
        var go = NewGo("Section", parent);
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

    // ── Swapper helpers ───────────────────────────────────────────────────────
    void Each(Action<AvatarShaderSwapper> action)
    {
        if (_swappers == null) return;
        foreach (var s in _swappers)
            if (s != null) action(s);
    }

    AvatarShaderSwapper First()
        => (_swappers != null && _swappers.Length > 0) ? _swappers[0] : null;

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
        // Patch an existing EventSystem that only has StandaloneInputModule
        if (es.GetComponent<OVRInputModule>() == null)
            es.gameObject.AddComponent<OVRInputModule>();
#endif
    }
}
