using System.Collections;
using UnityEngine;
using Oculus.Avatar2;

/// Waits for the local OvrAvatarEntity on this GameObject to load its MeshRenderers,
/// then clones them to a second world position with a custom shader.
/// Attach to the working avatar entity (the one with _isLocal = 1).
public class AvatarMeshCloner : MonoBehaviour
{
    [SerializeField] private Shader _nprShader;
    [SerializeField] private Texture2D _toonRamp;
    [SerializeField] private Vector3 _cloneWorldPosition = new Vector3(-0.8f, 0f, 1f);
    [SerializeField] private float _pollTimeout = 30f;

    private GameObject _cloneRoot;

    private IEnumerator Start()
    {
        if (_nprShader == null)
        {
            Debug.LogWarning("[AvatarMeshCloner] No NPR shader assigned — skipping clone.");
            yield break;
        }

        // Wait until the avatar has MeshRenderers (same strategy as AvatarShaderSwapper)
        float elapsed = 0f;
        MeshRenderer[] renderers = null;
        while (elapsed < _pollTimeout)
        {
            renderers = GetComponentsInChildren<MeshRenderer>(true);
            if (renderers.Length > 0) break;
            elapsed += Time.deltaTime;
            yield return null;
        }

        if (renderers == null || renderers.Length == 0)
        {
            Debug.LogWarning($"[AvatarMeshCloner] No MeshRenderers found after {_pollTimeout}s — aborting clone.");
            yield break;
        }

        // One extra frame so the SDK finishes material assignment
        yield return null;
        renderers = GetComponentsInChildren<MeshRenderer>(true);

        BuildClone(renderers);
    }

    private void BuildClone(MeshRenderer[] renderers)
    {
        _cloneRoot = new GameObject("AvatarClone_NPR");
        _cloneRoot.transform.position = _cloneWorldPosition;
        _cloneRoot.transform.rotation = transform.rotation;

        foreach (var rend in renderers)
        {
            var cloneGO = new GameObject(rend.gameObject.name + "_NPR");
            cloneGO.transform.SetParent(_cloneRoot.transform, false);

            // Preserve the renderer's offset relative to the avatar root
            cloneGO.transform.localPosition = transform.InverseTransformPoint(rend.transform.position);
            cloneGO.transform.localRotation = Quaternion.Inverse(transform.rotation) * rend.transform.rotation;
            cloneGO.transform.localScale = rend.transform.lossyScale;

            var mf = rend.GetComponent<MeshFilter>();
            if (mf != null)
                cloneGO.AddComponent<MeshFilter>().sharedMesh = mf.sharedMesh;

            var cloneMR = cloneGO.AddComponent<MeshRenderer>();
            var origMats = rend.sharedMaterials;
            var newMats = new Material[origMats.Length];
            for (int i = 0; i < origMats.Length; i++)
            {
                var mat = new Material(_nprShader);
                mat.name = $"Clone_NPR_mat{i}";
                if (_toonRamp != null)
                    mat.SetTexture("_ToonRamp", _toonRamp);
                if (origMats[i] != null)
                {
                    foreach (var prop in new[] { "_BaseMap", "_MainTex", "_BaseColorMap" })
                    {
                        if (!origMats[i].HasProperty(prop)) continue;
                        var tex = origMats[i].GetTexture(prop);
                        if (tex == null) continue;
                        mat.SetTexture("_BaseMap", tex);
                        break;
                    }
                }
                newMats[i] = mat;
            }
            cloneMR.sharedMaterials = newMats;
        }

        Debug.Log($"[AvatarMeshCloner] Cloned {renderers.Length} renderers to {_cloneWorldPosition}.");
    }

    private void OnDestroy()
    {
        if (_cloneRoot != null)
            Destroy(_cloneRoot);
    }
}
