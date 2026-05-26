using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

/// General-purpose ShaderGUI for all Avaturn NPR shaders.
///
/// Features
/// ─────────
/// • Auto-detects the avatar slot (Head / Body / Hair / Eyelash / Look) from the
///   material name; the user can override with the 5-button selector.
/// • "Save as [Slot] Preset"  — captures every float/range/color property of the
///   current material into AvaturnSlotPresets.asset (committed to source control).
/// • "Apply [Slot] Preset"    — writes the saved values back to the material and
///   calls Repaint() so the Inspector sliders update immediately.
/// • Diff view               — each saved property is shown green (✓ matches) or
///   orange (current → saved) so you can see drift at a glance.
/// • Debug Defaults toggle   — shown automatically when the shader exposes
///   _UseDebugDefaults (V1 compatibility); applies values and keeps toggle ON.
///
/// Usage: add   CustomEditor "AvaturnPresetShaderGUI"   to any NPR shader.
public class AvaturnPresetShaderGUI : ShaderGUI
{
    // ── Constants ─────────────────────────────────────────────────────────────

    static readonly string[] SlotNames  = { "Head", "Body", "Hair", "Eyelash", "Look" };
    const string PresetAssetPath = "Assets/Editor/AvaturnSlotPresets.asset";

    // ── Per-session state (keyed by material asset path for stability) ─────────

    static readonly Dictionary<string, int>  s_SelectedSlot = new Dictionary<string, int>();
    static readonly Dictionary<string, bool> s_PresetFoldout = new Dictionary<string, bool>();
    static readonly Dictionary<string, bool> s_DiffFoldout   = new Dictionary<string, bool>();

    // ── ShaderGUI entry point ─────────────────────────────────────────────────

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
    {
        var material  = materialEditor.target as Material;
        string matKey = AssetDatabase.GetAssetPath(material);
        if (string.IsNullOrEmpty(matKey)) matKey = material.name;

        // Initialise foldout defaults
        if (!s_PresetFoldout.ContainsKey(matKey)) s_PresetFoldout[matKey] = true;
        if (!s_DiffFoldout.ContainsKey(matKey))   s_DiffFoldout[matKey]   = false;
        if (!s_SelectedSlot.ContainsKey(matKey))
            s_SelectedSlot[matKey] = DetectSlot(material.name);

        DrawPresetPanel(materialEditor, props, material, matKey);

        DrawDebugDefaultsToggle(materialEditor, props);

        EditorGUILayout.Space(6);
        base.OnGUI(materialEditor, props);
    }

    // ── Preset panel ──────────────────────────────────────────────────────────

    void DrawPresetPanel(MaterialEditor materialEditor, MaterialProperty[] props,
                         Material material, string matKey)
    {
        s_PresetFoldout[matKey] = EditorGUILayout.BeginFoldoutHeaderGroup(
            s_PresetFoldout[matKey], "Avaturn Slot Presets");

        if (s_PresetFoldout[matKey])
        {
            EditorGUI.indentLevel++;

            // ── Slot selector ────────────────────────────────────────────────
            EditorGUILayout.LabelField("Slot", EditorStyles.boldLabel);
            int newSlot = GUILayout.SelectionGrid(
                s_SelectedSlot[matKey], SlotNames, 5, EditorStyles.miniButton);
            if (newSlot != s_SelectedSlot[matKey])
                s_SelectedSlot[matKey] = newSlot;

            string slotName    = SlotNames[s_SelectedSlot[matKey]];
            string shaderName  = material.shader.name;
            var    presets     = LoadOrCreatePresetAsset();
            var    preset      = presets?.Get(shaderName, slotName);

            EditorGUILayout.Space(4);

            // ── Status ───────────────────────────────────────────────────────
            if (preset == null || (preset.floats.Count == 0 && preset.colors.Count == 0))
            {
                EditorGUILayout.HelpBox(
                    $"No preset saved for \"{slotName}\" on this shader yet.\n" +
                    "Tune the material and press  Save as ... Preset.",
                    MessageType.Info);
            }
            else
            {
                bool matches   = MatchesPreset(props, preset);
                var  headStyle = new GUIStyle(EditorStyles.label) { fontStyle = FontStyle.Bold };
                headStyle.normal.textColor = matches
                    ? new Color(0.2f, 0.7f, 0.2f)
                    : new Color(0.75f, 0.45f, 0f);
                EditorGUILayout.LabelField(
                    matches ? $"✓  Matches {slotName} preset"
                            : $"○  Differs from {slotName} preset",
                    headStyle);

                // Collapsible diff
                s_DiffFoldout[matKey] = EditorGUILayout.Foldout(
                    s_DiffFoldout[matKey], "Show property diff", true);
                if (s_DiffFoldout[matKey])
                {
                    EditorGUI.indentLevel++;
                    DrawDiff(props, preset);
                    EditorGUI.indentLevel--;
                }
            }

            EditorGUILayout.Space(4);

            // ── Buttons ──────────────────────────────────────────────────────
            using (new EditorGUILayout.HorizontalScope())
            {
                using (new EditorGUI.DisabledScope(preset == null ||
                    (preset.floats.Count == 0 && preset.colors.Count == 0)))
                {
                    if (GUILayout.Button($"Apply  {slotName}  Preset", GUILayout.Height(26)))
                    {
                        Undo.RecordObject(material, $"Apply {slotName} Preset");
                        ApplyPreset(props, preset);
                        EditorUtility.SetDirty(material);
                        materialEditor.Repaint();
                    }
                }

                if (GUILayout.Button($"Save as  {slotName}  Preset", GUILayout.Height(26)))
                {
                    if (presets != null)
                    {
                        Undo.RecordObject(presets, $"Save {slotName} Preset");
                        SavePreset(presets, shaderName, slotName, props);
                        EditorUtility.SetDirty(presets);
                        AssetDatabase.SaveAssets();
                    }
                }
            }

            EditorGUI.indentLevel--;
        }

        EditorGUILayout.EndFoldoutHeaderGroup();
    }

    // ── Debug Defaults toggle (V1 / shaders with _UseDebugDefaults) ───────────

    static void DrawDebugDefaultsToggle(MaterialEditor materialEditor,
                                        MaterialProperty[] props)
    {
        var toggleProp = FindProperty("_UseDebugDefaults", props, false);
        if (toggleProp == null) return;

        EditorGUILayout.Space(4);
        EditorGUI.BeginChangeCheck();
        bool current  = toggleProp.floatValue > 0.5f;
        bool newValue = EditorGUILayout.Toggle("Use Debug Defaults", current);
        if (EditorGUI.EndChangeCheck())
        {
            toggleProp.floatValue = newValue ? 1f : 0f;
            if (newValue && !current)
                materialEditor.Repaint();
        }
    }

    // ── Preset helpers ────────────────────────────────────────────────────────

    static void SavePreset(AvaturnSlotPresets store, string shaderName,
                           string slotName, MaterialProperty[] props)
    {
        var slot = store.GetOrCreate(shaderName, slotName);
        slot.floats.Clear();
        slot.colors.Clear();

        foreach (var p in props)
        {
            if ((p.flags & MaterialProperty.PropFlags.HideInInspector) != 0) continue;
            if (p.type == MaterialProperty.PropType.Float ||
                p.type == MaterialProperty.PropType.Range)
            {
                slot.floats.Add(new AvaturnSlotPresets.FloatProp
                    { name = p.name, value = p.floatValue });
            }
            else if (p.type == MaterialProperty.PropType.Color)
            {
                slot.colors.Add(new AvaturnSlotPresets.ColorProp
                    { name = p.name, value = p.colorValue });
            }
        }
    }

    static void ApplyPreset(MaterialProperty[] props, AvaturnSlotPresets.SlotPreset preset)
    {
        foreach (var fp in preset.floats)
        {
            var p = FindProperty(fp.name, props, false);
            if (p != null) p.floatValue = fp.value;
        }
        foreach (var cp in preset.colors)
        {
            var p = FindProperty(cp.name, props, false);
            if (p != null) p.colorValue = cp.value;
        }
    }

    static bool MatchesPreset(MaterialProperty[] props, AvaturnSlotPresets.SlotPreset preset)
    {
        foreach (var fp in preset.floats)
        {
            var p = FindProperty(fp.name, props, false);
            if (p != null && !Mathf.Approximately(p.floatValue, fp.value)) return false;
        }
        foreach (var cp in preset.colors)
        {
            var p = FindProperty(cp.name, props, false);
            if (p != null && p.colorValue != cp.value) return false;
        }
        return true;
    }

    static void DrawDiff(MaterialProperty[] props, AvaturnSlotPresets.SlotPreset preset)
    {
        foreach (var fp in preset.floats)
        {
            var p = FindProperty(fp.name, props, false);
            if (p == null) continue;
            bool match = Mathf.Approximately(p.floatValue, fp.value);
            var  style = new GUIStyle(EditorStyles.miniLabel);
            style.normal.textColor = match
                ? new Color(0.3f, 0.6f, 0.3f) : new Color(0.8f, 0.35f, 0.1f);
            EditorGUILayout.LabelField(
                fp.name,
                match ? $"{p.floatValue:G4}  ✓"
                      : $"{p.floatValue:G4}  →  {fp.value:G4}",
                style);
        }
        foreach (var cp in preset.colors)
        {
            var p = FindProperty(cp.name, props, false);
            if (p == null) continue;
            bool match = p.colorValue == cp.value;
            var  style = new GUIStyle(EditorStyles.miniLabel);
            style.normal.textColor = match
                ? new Color(0.3f, 0.6f, 0.3f) : new Color(0.8f, 0.35f, 0.1f);
            string cur = ColorStr(p.colorValue);
            string ref_ = ColorStr(cp.value);
            EditorGUILayout.LabelField(
                cp.name,
                match ? $"{cur}  ✓" : $"{cur}  →  {ref_}",
                style);
        }
    }

    // ── Utility ───────────────────────────────────────────────────────────────

    static int DetectSlot(string materialName)
    {
        string lower = materialName.ToLowerInvariant();
        if (lower.Contains("head"))    return 0;
        if (lower.Contains("body"))    return 1;
        if (lower.Contains("hair"))    return 2;
        if (lower.Contains("eyelash")) return 3;
        if (lower.Contains("look"))    return 4;
        return 0;
    }

    static string ColorStr(Color c) =>
        $"({c.r:F2}, {c.g:F2}, {c.b:F2})";

    static AvaturnSlotPresets LoadOrCreatePresetAsset()
    {
        var asset = AssetDatabase.LoadAssetAtPath<AvaturnSlotPresets>(PresetAssetPath);
        if (asset != null) return asset;

        asset = ScriptableObject.CreateInstance<AvaturnSlotPresets>();
        System.IO.Directory.CreateDirectory(
            System.IO.Path.GetDirectoryName(PresetAssetPath));
        AssetDatabase.CreateAsset(asset, PresetAssetPath);
        AssetDatabase.SaveAssets();
        return asset;
    }
}
