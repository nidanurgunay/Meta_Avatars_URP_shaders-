using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Oculus.Avatar2;

/// Swaps avatar materials to an NPR shader using OvrAvatarRenderable.SetShader(),
/// which preserves the SDK's GPU/compute-skinning keywords and MaterialPropertyBlock
/// buffer assignments. Works for ALL skinning types: Unity, GPU, and Compute.
///
/// All NPR parameters are exposed in the Inspector. Changes made during Play Mode
/// are applied immediately via OnValidate. Call ApplyParameters() from any script
/// to update materials at runtime.
///
/// Attach to any OvrAvatarEntity root GameObject.
public class AvatarNPRSwapper : MonoBehaviour
{
    // ── Shader assignment ─────────────────────────────────────────────────────
    [Header("Shader")]
    [SerializeField] private Shader _nprShader;
    [SerializeField] private float _pollTimeout = 30f;

    // ── Texture / Base ────────────────────────────────────────────────────────
    [Header("Base Appearance")]
    [Tooltip("Toon ramp texture (XToon: 2D ramp, V1-V4: used as toon ramp if assigned)")]
    [SerializeField] private Texture2D _toonRamp;
    [Tooltip("Multiplied with the avatar's diffuse texture (V1-V4: _Color, XToon: _BaseColor)")]
    [SerializeField] private Color _baseColor = Color.white;
    [Tooltip("How strongly the diffuse texture contributes (V1-V4 only)")]
    [SerializeField, Range(0f, 1f)] private float _textureIntensity = 1f;

    // ── Toon Shading ──────────────────────────────────────────────────────────
    [Header("Toon Shading")]
    [SerializeField, Range(1f, 10f)] private float _toonSteps     = 3f;
    [SerializeField, Range(0f, 1f)]  private float _toonThreshold = 0.5f;
    [SerializeField, Range(0.001f, 0.1f)] private float _toonSmoothness = 0.01f;
    [SerializeField, Range(0f, 1f)]  private float _shadowStrength = 0.7f;
    [Tooltip("Shadow tint color (XToon only)")]
    [SerializeField] private Color _shadowColor = new Color(0.25f, 0.25f, 0.35f, 1f);
    [Tooltip("Overall lighting effect intensity (XToon only)")]
    [SerializeField, Range(0f, 1f)] private float _lightingStrength = 1f;

    // ── Outline ───────────────────────────────────────────────────────────────
    [Header("Outline")]
    [SerializeField] private Color _outlineColor = Color.black;
    [SerializeField, Range(0f, 0.05f)] private float _outlineWidth = 0.003f;

    // ── Rim Light ─────────────────────────────────────────────────────────────
    [Header("Rim Light")]
    [SerializeField] private Color _rimColor = new Color(0.408f, 0.408f, 0.408f, 1f);
    [SerializeField, Range(0.5f, 10f)] private float _rimPower = 3f;
    [Tooltip("Rim light blend strength (XToon only; V1-V4 always full)")]
    [SerializeField, Range(0f, 1f)] private float _rimStrength = 0.3f;
    [SerializeField, Range(0f, 1f)] private float _rimThreshold = 0.1f;

    // ── Specular (XToon) ──────────────────────────────────────────────────────
    [Header("Specular  (XToon only)")]
    [SerializeField] private Color _specularColor = Color.white;
    [SerializeField, Range(0f, 1f)] private float _specularSize       = 0.03f;
    [SerializeField, Range(0.001f, 0.5f)] private float _specularSmoothness = 0.02f;
    [SerializeField, Range(0f, 1f)] private float _specularStrength   = 0.5f;

    // ── X-Toon Abstraction ────────────────────────────────────────────────────
    [Header("X-Toon Abstraction  (XToon only)")]
    [SerializeField, Range(0f, 1f)] private float _rampSmoothing  = 0.01f;
    [SerializeField, Range(0f, 1f)] private float _lightSensitivity = 1f;
    [SerializeField, Range(0f, 1f)] private float _detailBias     = 0.5f;
    [SerializeField] private float _depthNear = 5f;
    [SerializeField] private float _depthFar  = 50f;
    [SerializeField, Range(0f, 1f)] private float _manualDetail   = 0f;
    [SerializeField, Range(0f, 1f)] private float _normalSmoothing = 0f;

    // ── Inner Edge Detection (V3 / V4) ────────────────────────────────────────
    [Header("Inner Edge Detection  (V3/V4 only)")]
    [Tooltip("Threshold for low-saturation areas (skin). Higher = fewer edges on skin.")]
    [SerializeField, Range(0f, 1f)] private float _innerLineThresholdSkin    = 0.4f;
    [Tooltip("Threshold for high-saturation areas (clothes/hair). Lower = more detail.")]
    [SerializeField, Range(0f, 1f)] private float _innerLineThresholdClothes = 0.1f;
    [Tooltip("Saturation value below which a pixel is considered skin. Raise if clothes bleed into skin mode.")]
    [SerializeField, Range(0f, 0.5f)] private float _skinSaturationCutoff   = 0.15f;
    [SerializeField, Range(0f, 0.01f)] private float _innerLineBlur          = 0.002f;
    [SerializeField, Range(0f, 1f)] private float _innerLineStrength         = 0.8f;
    [SerializeField] private Color _innerLineColor = Color.black;

    // ── Internal state ────────────────────────────────────────────────────────
    private readonly List<Material> _nprMaterials = new List<Material>();

    // Avatar SDK material property names for base color texture (checked in order)
    private static readonly string[] _sdkBaseTex =
        { "u_BaseColorSampler", "_BaseMap", "_MainTex", "_BaseColorMap" };

    // ─────────────────────────────────────────────────────────────────────────
    private IEnumerator Start()
    {
        if (_nprShader == null)
        {
            Debug.LogWarning($"[AvatarNPRSwapper] No NPR shader assigned on '{gameObject.name}' — skipping.");
            yield break;
        }

        // Poll until the SDK has spawned at least one OvrAvatarRenderable
        float elapsed = 0f;
        OvrAvatarRenderable[] renderables = null;
        while (elapsed < _pollTimeout)
        {
            renderables = GetComponentsInChildren<OvrAvatarRenderable>(true);
            if (renderables.Length > 0) break;
            elapsed += Time.deltaTime;
            yield return null;
        }

        if (renderables == null || renderables.Length == 0)
        {
            Debug.LogWarning($"[AvatarNPRSwapper] No OvrAvatarRenderable found on '{gameObject.name}' " +
                             $"after {_pollTimeout}s — skipping.");
            yield break;
        }

        // One extra frame so the SDK finishes keyword / buffer initialisation
        yield return null;
        renderables = GetComponentsInChildren<OvrAvatarRenderable>(true);

        _nprMaterials.Clear();
        int swapped = 0;

        foreach (var renderable in renderables)
        {
            if (renderable == null || renderable.rendererComponent == null) continue;

            // Capture the avatar's diffuse texture BEFORE the shader swap, because the
            // SDK property name (u_BaseColorSampler) won't exist on our NPR shader after.
            Texture avatarDiffuse = CaptureBaseTexture(renderable.rendererComponent.sharedMaterial);

            // SetShader() copies the Avatar material and swaps only the shader.
            // The SDK keeps managing vertex-fetch keywords and MaterialPropertyBlock
            // buffer references on that copy — GPU/Compute skinning remains transparent.
            renderable.SetShader(_nprShader);

            Material mat = renderable.rendererComponent.sharedMaterial;
            if (mat == null) continue;

            // Assign the captured diffuse texture to whichever property the new shader uses
            if (avatarDiffuse != null)
                SetTextureToAnyProp(mat, avatarDiffuse, "_BaseMap", "_MainTex");

            ApplyToMaterial(mat);
            _nprMaterials.Add(mat);
            swapped++;
        }

        Debug.Log($"[AvatarNPRSwapper] Applied '{_nprShader.name}' to {swapped} renderables on '{gameObject.name}'.");
    }

    // ─────────────────────────────────────────────────────────────────────────
    /// Re-applies all Inspector parameters to the live NPR materials.
    /// Call this from any external script whenever you change a field at runtime.
    public void ApplyParameters()
    {
        foreach (var mat in _nprMaterials)
            if (mat != null) ApplyToMaterial(mat);
    }

    // Applied automatically in the Editor when any Inspector value is changed
    private void OnValidate()
    {
        if (!Application.isPlaying) return;
        ApplyParameters();
    }

    // ─────────────────────────────────────────────────────────────────────────
    private void ApplyToMaterial(Material mat)
    {
        // ── Toon ramp texture ────────────────────────────────────────────────
        if (_toonRamp != null)
            SetTextureToAnyProp(mat, _toonRamp, "_ToonRamp");

        // ── Base color ───────────────────────────────────────────────────────
        // V1-V4 use _Color, XToon uses _BaseColor
        TrySet(mat, "_Color",     _baseColor);
        TrySet(mat, "_BaseColor", _baseColor);
        TrySet(mat, "_TextureIntensity", _textureIntensity);

        // ── Toon shading ─────────────────────────────────────────────────────
        TrySet(mat, "_ToonSteps",       _toonSteps);
        TrySet(mat, "_ToonThreshold",   _toonThreshold);
        TrySet(mat, "_ToonSmoothness",  _toonSmoothness);
        TrySet(mat, "_ShadowStrength",  _shadowStrength);
        TrySet(mat, "_ShadowColor",     _shadowColor);
        TrySet(mat, "_LightingStrength",_lightingStrength);

        // ── Outline ──────────────────────────────────────────────────────────
        // V1-V4 use _OuterOutlineColor / _OuterOutlineWidth; XToon uses _OutlineColor / _OutlineWidth
        TrySet(mat, "_OutlineColor",        _outlineColor);
        TrySet(mat, "_OuterOutlineColor",   _outlineColor);
        TrySet(mat, "_OutlineWidth",        _outlineWidth);
        TrySet(mat, "_OuterOutlineWidth",   _outlineWidth);

        // ── Rim ──────────────────────────────────────────────────────────────
        TrySet(mat, "_RimColor",     _rimColor);
        TrySet(mat, "_RimPower",     _rimPower);
        TrySet(mat, "_RimStrength",  _rimStrength);
        TrySet(mat, "_RimThreshold", _rimThreshold);

        // ── Specular (XToon) ─────────────────────────────────────────────────
        TrySet(mat, "_SpecularColor",       _specularColor);
        TrySet(mat, "_SpecularSize",        _specularSize);
        TrySet(mat, "_SpecularSmoothness",  _specularSmoothness);
        TrySet(mat, "_SpecularStrength",    _specularStrength);

        // ── X-Toon ramp / abstraction ────────────────────────────────────────
        TrySet(mat, "_RampSmoothing",    _rampSmoothing);
        TrySet(mat, "_LightSensitivity", _lightSensitivity);
        TrySet(mat, "_DetailBias",       _detailBias);
        TrySet(mat, "_DepthNear",        _depthNear);
        TrySet(mat, "_DepthFar",         _depthFar);
        TrySet(mat, "_ManualDetail",     _manualDetail);
        TrySet(mat, "_NormalSmoothing",  _normalSmoothing);

        // ── Inner edge detection (V3/V4) ─────────────────────────────────────
        TrySet(mat, "_InnerLineThresholdSkin",    _innerLineThresholdSkin);
        TrySet(mat, "_InnerLineThresholdClothes", _innerLineThresholdClothes);
        TrySet(mat, "_SkinSaturationCutoff",      _skinSaturationCutoff);
        TrySet(mat, "_InnerLineBlur",             _innerLineBlur);
        TrySet(mat, "_InnerLineStrength",         _innerLineStrength);
        TrySet(mat, "_InnerLineColor",            _innerLineColor);
    }

    // ─────────────────────────────────────────────────────────────────────────
    private static Texture CaptureBaseTexture(Material mat)
    {
        if (mat == null) return null;
        foreach (var prop in _sdkBaseTex)
        {
            if (!mat.HasProperty(prop)) continue;
            var tex = mat.GetTexture(prop);
            if (tex != null) return tex;
        }
        return null;
    }

    // Set texture to the first matching property name the material/shader has
    private static void SetTextureToAnyProp(Material mat, Texture tex, params string[] propNames)
    {
        foreach (var prop in propNames)
        {
            if (mat.HasProperty(prop))
            {
                mat.SetTexture(prop, tex);
                // Don't break — assign to all matching props so every shader variant works
            }
        }
    }

    private static void TrySet(Material mat, string prop, Color val)
    {
        if (mat.HasProperty(prop)) mat.SetColor(prop, val);
    }

    private static void TrySet(Material mat, string prop, float val)
    {
        if (mat.HasProperty(prop)) mat.SetFloat(prop, val);
    }
}
