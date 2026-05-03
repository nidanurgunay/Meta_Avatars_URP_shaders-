using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Oculus.Avatar2;

/// Replaces all MeshRenderer materials on this avatar with a custom shader
/// once the avatar has finished loading its renderers.
/// All shader parameters are exposed in the Inspector and applied live
/// during Play Mode via OnValidate / ApplyParameters().
public class AvatarShaderSwapper : MonoBehaviour
{
    // ── Shader ────────────────────────────────────────────────────────────────
    [Header("Shader")]
    [SerializeField] private Shader _customShader;
    [SerializeField] private bool _copyBaseTexture = true;

    // ── Base Appearance ───────────────────────────────────────────────────────
    [Header("Base Appearance")]
    [SerializeField] private Texture2D _toonRamp;
    [SerializeField] private Color _baseColor = Color.white;
    [SerializeField, Range(0f, 1f)] private float _textureIntensity = 1f;

    // ── Toon Shading ──────────────────────────────────────────────────────────
    [Header("Toon Shading")]
    [SerializeField, Range(1f, 10f)] private float _toonSteps      = 3f;
    [SerializeField, Range(0f, 1f)]  private float _toonThreshold  = 0.5f;
    [SerializeField, Range(0.001f, 0.1f)] private float _toonSmoothness = 0.01f;
    [SerializeField, Range(0f, 1f)]  private float _shadowStrength  = 0.7f;

    // ── Outline ───────────────────────────────────────────────────────────────
    [Header("Outer Outline")]
    [SerializeField] private Color _outlineColor = Color.black;
    [SerializeField, Range(0f, 0.05f)] private float _outlineWidth  = 0.003f;

    // ── Rim Light ─────────────────────────────────────────────────────────────
    [Header("Rim Light")]
    [SerializeField] private Color _rimColor = new Color(0.408f, 0.408f, 0.408f, 1f);
    [SerializeField, Range(0.5f, 10f)] private float _rimPower      = 3f;

    // ── Inner Edge Detection (V3 / V4) ────────────────────────────────────────
    [Header("Inner Edge Detection  (V3/V4 only)")]
    [Tooltip("Threshold for low-saturation areas (skin). Higher = fewer edges on skin.")]
    [SerializeField, Range(0f, 1f)] private float _innerLineThresholdSkin    = 0.4f;
    [Tooltip("Threshold for high-saturation areas (clothes/hair). Lower = more edge detail.")]
    [SerializeField, Range(0f, 1f)] private float _innerLineThresholdClothes = 0.15f;
    [Tooltip("Edges above this magnitude are suppressed as UV-seam spikes. Lower = stricter seam rejection.")]
    [SerializeField, Range(0.1f, 8f)] private float _innerLineMax            = 2f;
    [Tooltip("If neighbour luminance range exceeds this, the pixel is on a UV seam and edges are hidden.")]
    [SerializeField, Range(0f, 1f)]   private float _seamRangeLimit          = 0.6f;
    [Tooltip("Saturation below this value is classified as skin. Raise if neutral-coloured clothes show patches.")]
    [SerializeField, Range(0f, 0.5f)] private float _skinSaturationCutoff   = 0.25f;
    [SerializeField, Range(0f, 10f)]  private float _innerLineBlur           = 0.5f;
    [SerializeField, Range(0f, 1f)]   private float _innerLineStrength       = 1f;
    [SerializeField] private Color _innerLineColor = Color.black;

    // ── Internal ──────────────────────────────────────────────────────────────
    private readonly List<Material> _swappedMaterials = new List<Material>();

    private static readonly string[] _sdkBaseTex =
        { "u_BaseColorSampler", "_BaseMap", "_MainTex", "_BaseColorMap" };

    private static readonly string[] _sdkNormalTex =
        { "u_NormalSampler", "_NormalMap", "_BumpMap" };

    // ─────────────────────────────────────────────────────────────────────────
    [Header("LOD Re-application")]
    [Tooltip("Seconds between re-checks for SDK-managed LOD renderers that reverted to the original shader.")]
    [SerializeField] private float _reapplyInterval = 2f;

    private void Start()
    {
        if (_customShader == null)
        {
            Debug.LogWarning($"[AvatarShaderSwapper] No shader assigned on '{gameObject.name}' — skipping.");
            return;
        }
        StartCoroutine(WaitForRenderersAndSwap());
    }

    private IEnumerator WaitForRenderersAndSwap()
    {
        Renderer[] renderers = null;
        float timeout = 30f;
        float elapsed = 0f;

        while (elapsed < timeout)
        {
            renderers = GetComponentsInChildren<Renderer>(true);
            if (renderers.Length > 0) break;
            elapsed += Time.deltaTime;
            yield return null;
        }

        if (renderers == null || renderers.Length == 0)
        {
            Debug.LogWarning($"[AvatarShaderSwapper] No renderers found on '{gameObject.name}' after {timeout}s.");
            yield break;
        }

        yield return null; // extra frame — SDK finishes assigning materials

        _swappedMaterials.Clear();
        ApplyShaders(GetComponentsInChildren<Renderer>(true));

        if (_reapplyInterval > 0f)
            StartCoroutine(PeriodicReapply());
    }

    // Re-applies the custom shader to any renderer the SDK swapped back during LOD transitions.
    private IEnumerator PeriodicReapply()
    {
        var wait = new WaitForSeconds(_reapplyInterval);
        while (true)
        {
            yield return wait;
            foreach (var rend in GetComponentsInChildren<Renderer>(true))
            {
                if (rend == null) continue;
                var mats = rend.sharedMaterials;
                bool needsSwap = false;
                foreach (var m in mats)
                    if (m != null && m.shader != _customShader) { needsSwap = true; break; }
                if (needsSwap)
                    ApplyShaders(new[] { rend });
            }
        }
    }

    private void ApplyShaders(Renderer[] renderers)
    {
        int swapped = 0;
        foreach (var rend in renderers)
        {
            var origMats = rend.sharedMaterials;
            var newMats  = new Material[origMats.Length];
            for (int i = 0; i < origMats.Length; i++)
            {
                var orig   = origMats[i];
                var newMat = new Material(_customShader);
                newMat.name = orig != null ? $"{orig.name}_NPR" : $"mat{i}_NPR";

                if (_copyBaseTexture && orig != null)
                {
                    Texture baseTex = null;
                    foreach (var prop in _sdkBaseTex)
                    {
                        if (!orig.HasProperty(prop)) continue;
                        var tex = orig.GetTexture(prop);
                        if (tex == null) continue;
                        baseTex = tex;
                        break;
                    }
                    if (baseTex != null)
                    {
                        if (newMat.HasProperty("_BaseMap")) newMat.SetTexture("_BaseMap", baseTex);
                        if (newMat.HasProperty("_MainTex")) newMat.SetTexture("_MainTex", baseTex);
                    }

                    Texture normalTex = null;
                    foreach (var prop in _sdkNormalTex)
                    {
                        if (!orig.HasProperty(prop)) continue;
                        var tex = orig.GetTexture(prop);
                        if (tex == null) continue;
                        normalTex = tex;
                        break;
                    }
                    if (normalTex != null && newMat.HasProperty("_NormalMap"))
                        newMat.SetTexture("_NormalMap", normalTex);
                }

                ApplyToMaterial(newMat);
                _swappedMaterials.Add(newMat);
                newMats[i] = newMat;
            }
            rend.materials = newMats;
            swapped++;
        }

        Debug.Log($"[AvatarShaderSwapper] Applied '{_customShader.name}' to {swapped} renderers on '{gameObject.name}'.");
    }

    // ── Public properties — setting any of these immediately re-applies materials ─
    public float InnerLineThresholdSkin
    {
        get => _innerLineThresholdSkin;
        set { _innerLineThresholdSkin = value; ApplyParameters(); }
    }
    public float InnerLineThresholdClothes
    {
        get => _innerLineThresholdClothes;
        set { _innerLineThresholdClothes = value; ApplyParameters(); }
    }
    public float InnerLineMax
    {
        get => _innerLineMax;
        set { _innerLineMax = value; ApplyParameters(); }
    }
    public float SeamRangeLimit
    {
        get => _seamRangeLimit;
        set { _seamRangeLimit = value; ApplyParameters(); }
    }
    public float SkinSaturationCutoff
    {
        get => _skinSaturationCutoff;
        set { _skinSaturationCutoff = value; ApplyParameters(); }
    }
    public float InnerLineBlur
    {
        get => _innerLineBlur;
        set { _innerLineBlur = value; ApplyParameters(); }
    }
    public float InnerLineStrength
    {
        get => _innerLineStrength;
        set { _innerLineStrength = value; ApplyParameters(); }
    }
    public float ToonSteps
    {
        get => _toonSteps;
        set { _toonSteps = value; ApplyParameters(); }
    }
    public float ShadowStrength
    {
        get => _shadowStrength;
        set { _shadowStrength = value; ApplyParameters(); }
    }
    public float OutlineWidth
    {
        get => _outlineWidth;
        set { _outlineWidth = value; ApplyParameters(); }
    }
    public float RimPower
    {
        get => _rimPower;
        set { _rimPower = value; ApplyParameters(); }
    }

    // ─────────────────────────────────────────────────────────────────────────
    /// Re-applies all Inspector parameters to every live material.
    /// Call this from any external script to update at runtime.
    public void ApplyParameters()
    {
        foreach (var mat in _swappedMaterials)
            if (mat != null) ApplyToMaterial(mat);
    }

    private void OnValidate()
    {
        if (!Application.isPlaying) return;
        ApplyParameters();
    }

    // ─────────────────────────────────────────────────────────────────────────
    private void ApplyToMaterial(Material mat)
    {
        // Base
        TrySet(mat, "_Color",            _baseColor);
        TrySet(mat, "_BaseColor",        _baseColor);
        TrySet(mat, "_TextureIntensity", _textureIntensity);

        // Toon ramp
        if (_toonRamp != null && mat.HasProperty("_ToonRamp"))
            mat.SetTexture("_ToonRamp", _toonRamp);

        // Toon shading
        TrySet(mat, "_ToonSteps",      _toonSteps);
        TrySet(mat, "_ToonThreshold",  _toonThreshold);
        TrySet(mat, "_ToonSmoothness", _toonSmoothness);
        TrySet(mat, "_ShadowStrength", _shadowStrength);

        // Outline (V1-V4 names and XToon names)
        TrySet(mat, "_OutlineColor",      _outlineColor);
        TrySet(mat, "_OuterOutlineColor", _outlineColor);
        TrySet(mat, "_OutlineWidth",      _outlineWidth);
        TrySet(mat, "_OuterOutlineWidth", _outlineWidth);

        // Rim
        TrySet(mat, "_RimColor", _rimColor);
        TrySet(mat, "_RimPower", _rimPower);

        // Inner edge (V3/V4)
        TrySet(mat, "_InnerLineThresholdSkin",    _innerLineThresholdSkin);
        TrySet(mat, "_InnerLineThresholdClothes", _innerLineThresholdClothes);
        TrySet(mat, "_InnerLineMax",              _innerLineMax);
        TrySet(mat, "_SeamRangeLimit",            _seamRangeLimit);
        TrySet(mat, "_SkinSaturationCutoff",      _skinSaturationCutoff);
        TrySet(mat, "_InnerLineBlur",             _innerLineBlur);
        TrySet(mat, "_InnerLineStrength",         _innerLineStrength);
        TrySet(mat, "_InnerLineColor",            _innerLineColor);
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
