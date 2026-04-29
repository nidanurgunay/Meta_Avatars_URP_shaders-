using System.Collections;
using UnityEngine;
using Oculus.Avatar2;

/// Swaps avatar materials to an NPR shader using OvrAvatarRenderable.SetShader(),
/// which preserves the SDK's GPU/compute-skinning keywords and MaterialPropertyBlock
/// buffer assignments. Works for ALL skinning types: Unity, GPU, and Compute.
///
/// Usage: Attach to any OvrAvatarEntity root GameObject (same as AvatarShaderSwapper).
/// Use this instead of AvatarShaderSwapper when the scene has GPU or Compute skinned
/// avatars (e.g. SkinningTypesExample).
public class AvatarNPRSwapper : MonoBehaviour
{
    [SerializeField] private Shader _nprShader;
    [SerializeField] private Texture2D _toonRamp;
    [SerializeField] private Color _baseColor = Color.white;
    [SerializeField] private float _pollTimeout = 30f;

    private static readonly string[] _baseTexProps =
        { "u_BaseColorSampler", "_BaseMap", "_MainTex", "_BaseColorMap" };

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
                             $"after {_pollTimeout}s — skipping shader swap.");
            yield break;
        }

        // One extra frame so the SDK finishes its own keyword / buffer initialization
        yield return null;
        renderables = GetComponentsInChildren<OvrAvatarRenderable>(true);

        int swapped = 0;
        foreach (var renderable in renderables)
        {
            if (renderable == null || renderable.rendererComponent == null) continue;

            // Capture the avatar's diffuse texture BEFORE the shader swap, because the
            // property name (u_BaseColorSampler) won't exist on our NPR shader after the swap.
            Texture baseTexture = GetBaseTexture(renderable.rendererComponent.sharedMaterial);

            // SetShader() copies the current Avatar material and changes only the shader.
            // The SDK continues to manage vertex-fetch keywords (OVR_VERTEX_FETCH_EXTERNAL_BUFFER,
            // OVR_VERTEX_FETCH_TEXTURE, …) and MaterialPropertyBlock buffer refs on this copy,
            // so GPU/Compute skinning keeps working transparently.
            renderable.SetShader(_nprShader);

            // Apply NPR-specific parameters to the material copy now on the renderer
            var mat = renderable.rendererComponent.sharedMaterial;
            if (mat == null) continue;

            if (baseTexture != null)
                mat.SetTexture("_BaseMap", baseTexture);

            if (_toonRamp != null)
                mat.SetTexture("_ToonRamp", _toonRamp);

            mat.SetColor("_BaseColor", _baseColor);

            swapped++;
        }

        Debug.Log($"[AvatarNPRSwapper] Applied '{_nprShader.name}' to {swapped} renderables " +
                  $"on '{gameObject.name}'.");
    }

    private static Texture GetBaseTexture(Material mat)
    {
        if (mat == null) return null;
        foreach (var prop in _baseTexProps)
        {
            if (!mat.HasProperty(prop)) continue;
            var tex = mat.GetTexture(prop);
            if (tex != null) return tex;
        }
        return null;
    }
}
