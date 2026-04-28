using System.Collections;
using UnityEngine;
using Oculus.Avatar2;

/// Replaces all MeshRenderer materials on this avatar with a custom shader
/// once the avatar has finished loading its renderers.
public class AvatarShaderSwapper : MonoBehaviour
{
    [SerializeField] private Shader _customShader;
    [SerializeField] private Texture2D _toonRamp;
    [SerializeField] private Color _baseColor = Color.white;
    [SerializeField] private bool _copyBaseTexture = true;

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
        // Poll until the avatar has spawned at least one MeshRenderer
        MeshRenderer[] renderers = null;
        float timeout = 30f;
        float elapsed = 0f;

        while (elapsed < timeout)
        {
            renderers = GetComponentsInChildren<MeshRenderer>(true);
            if (renderers.Length > 0) break;
            elapsed += Time.deltaTime;
            yield return null;
        }

        if (renderers == null || renderers.Length == 0)
        {
            Debug.LogWarning($"[AvatarShaderSwapper] No MeshRenderers found on '{gameObject.name}' after {timeout}s.");
            yield break;
        }

        // Extra frame so SDK finishes assigning materials
        yield return null;

        ApplyShaders(GetComponentsInChildren<MeshRenderer>(true));
    }

    private void ApplyShaders(MeshRenderer[] renderers)
    {
        int swapped = 0;
        foreach (var rend in renderers)
        {
            var origMats = rend.sharedMaterials;
            var newMats = new Material[origMats.Length];
            for (int i = 0; i < origMats.Length; i++)
            {
                var orig = origMats[i];
                var newMat = new Material(_customShader);
                newMat.name = orig != null ? $"{orig.name}_NPR" : $"mat{i}_NPR";

                if (_copyBaseTexture && orig != null)
                {
                    foreach (var prop in new[] { "_BaseMap", "_MainTex", "_BaseColorMap" })
                    {
                        if (!orig.HasProperty(prop)) continue;
                        var tex = orig.GetTexture(prop);
                        if (tex == null) continue;
                        newMat.SetTexture("_BaseMap", tex);
                        break;
                    }
                }

                if (_toonRamp != null)
                    newMat.SetTexture("_ToonRamp", _toonRamp);

                newMat.SetColor("_BaseColor", _baseColor);
                newMats[i] = newMat;
            }
            rend.materials = newMats;
            swapped++;
        }

        Debug.Log($"[AvatarShaderSwapper] Applied '{_customShader.name}' to {swapped} renderers on '{gameObject.name}'.");
    }
}
