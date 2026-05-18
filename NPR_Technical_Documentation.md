# Meta Avatar NPR Study — Project Documentation
**Thesis project · Quest 3 · Unity 2022 LTS / URP**

---

## What This Project Is

A VR study application running on Meta Quest 3. Participants stand in front of a Meta Avatar and assess eight different **Non-Photorealistic Rendering (NPR)** styles — cartoon outlines, painterly effects, and edge-detection techniques — directly inside the headset without removing it.

The app lets a researcher cycle through six different avatar presets (different faces/body types) while a participant adjusts every shader parameter live through a floating UI panel, then compares the NPR look against the base Meta cel-shading with a single button press.

---

## How the App Works

### Scene structure

The scene contains one `SampleAvatarEntity` (Meta SDK component) which loads and renders the participant's Meta Avatar. An `OvrAvatarManager` handles the SDK lifecycle. The camera is attached to the Quest headset via the standard OVR rig.

On top of this there are two custom scripts:

| Script | Responsibility |
|--------|---------------|
| `AvatarSwitcher.cs` | Cycles avatar presets with the left thumbstick (Y button enters/exits selection mode). Shows a floating HUD. |
| `NPREdgeDetectionUI.cs` | World-space panel opened with B button. All NPR parameters are tunable here with the right controller. |
"""
### Controller layout

| Button | Action |
|--------|--------|
| **Y** (left top) | Toggle avatar selection mode on/off |
| **Left thumbstick** ← / → | Previous / next avatar preset (while selection mode is on) |
| **B** (right top) | Open / close the NPR parameter panel |
| **Right trigger** (drag) | Drag a slider in the NPR panel |
| **Right grip** | Decrement the selected float row |
| **Left grip** | Increment the selected float row |
| **A** (right bottom) | Freeze / unfreeze avatar pose |
| **X** (left bottom) | Freeze / unfreeze avatar pose |

### Avatar preset switching

Pressing Y enters avatar-selection mode and shows a floating HUD. Moving the left thumbstick steps through presets 0–5. Because the avatar loads asynchronously from a bundled zip file (~2–5 seconds on Quest 3), the HUD shows **"Loading preset X… Please wait"** in amber while the switch is in progress and returns to normal blue text when the new avatar is ready. Stick input is blocked during loading to prevent stacking requests.

### NPR parameter panel

Opening the panel (B button) spawns a world-space canvas 2 m in front of the player. The right controller ray-casts against the panel:
- **Trigger** — selects a row and drags its value
- **Right grip** — decrements the selected float row
- **Left grip** — increments the selected float row
- Rows are organised by technique; irrelevant rows are hidden (e.g. Blur Radius is only visible when Gauss Blur is ON)

At the very top of the panel is an **A/B Compare** button. Pressing it instantly disables all NPR keywords and the outline pass, showing the plain Meta cel-shading. Pressing it again restores the full NPR look. This lets a participant see the exact difference without removing the headset.

---

## NPR Shader Architecture

### Integration point

Meta's avatar shader exposes `AppSpecificPostManipulation` — a hook called at the end of the fragment shader after all PBR lighting and cel-shading are composited. All NPR effects write into `o.color` here. They never touch the lighting pipeline.

### Technique selection

Two `multi_compile` shader keyword sets control what runs:

```
ENABLE_NPR_EDGES              — master on/off (all effects gated here)

EFFECT_SOBEL | EFFECT_NORMAL_EDGE | EFFECT_GAUSS_SOBEL |
EFFECT_HIERARCHICAL | EFFECT_KUWAHARA | EFFECT_KUWAHARA_SOBEL |
EFFECT_KUW_GAUSS_HIER         — mutually exclusive technique
```

Each combination is a separate compiled shader variant — zero runtime branching cost. The UI toggles these via `Material.EnableKeyword` / `DisableKeyword`.

When `ENABLE_NPR_EDGES` is on but no technique keyword is set, the default **Derivative** technique runs.

### Inverted-hull outline (always available, separate toggle)

A second render pass (`OUTLINE_PASS`) draws the avatar again with reversed face culling. Each vertex is displaced outward along its world-space normal by `_OutlineWidth × 0.001` units. The pass outputs a flat `_OutlineColor` with no lighting — clean silhouette, no interaction with the edge techniques.

---

## Shader Techniques

### Technique 1 — Derivative (default)
**File:** `AvatarNPREdgeEffect.cginc`

Uses the GPU's hardware `ddx` / `ddy` instructions on base colour and normal map XY channels. These are computed for free by the quad rasteriser — no extra texture samples. The two channels are **fully independent**: each has its own threshold, max, and strength. Either channel can be disabled by setting its strength to 0.

**Toon posterization:** Before edge detection runs, the fully-composited lit colour is optionally quantized into discrete luminance bands, giving a cel-shaded stepped-lighting appearance. Because `AppSpecificPostManipulation` receives the final PBR+cel colour (raw NdotL is no longer accessible), posterization works by scaling the RGB vector so its luminance lands on the nearest band boundary — the hue and saturation are preserved, only brightness is stepped. `_ToonBands` (2–8) sets how many steps; `_ToonStrength` blends between original PBR and fully posterized. Default strength is 0 (off).

```
colorEdge  = |∇baseColor|       → draw if ColorThreshold ≤ colorEdge ≤ ColorEdgeMax
normalEdge = |∇normalXY|        → draw if NormalThreshold ≤ normalEdge ≤ NormalEdgeMax

edge = saturate(colorHit × ColorStrength + normalHit × NormalStrength)
```

| UI Slider | What it does |
|-----------|-------------|
| Color Thresh | Minimum colour gradient to count as an edge |
| Color Max | Suppresses UV-seam spikes above this value |
| Color Str | Opacity of the colour-derived edge |
| Normal Thresh | Minimum normal gradient to count as an edge |
| Normal Max | Suppresses seam spikes on the normal channel |
| Normal Str | Opacity of the normal-derived edge |

**Characteristics:** Zero extra samples. Setting Color Str = 0 gives a pure geometry/crease line from the normal map; setting Normal Str = 0 gives a pure texture/colour edge. Both channels can be active simultaneously and are max-blended via `saturate`.

---

### Technique 2 — Sobel
**File:** `NPREffect_Sobel.cginc`

3×3 Sobel operator on base colour luminance. Samples 8 neighbours in UV space and computes:

```
Gx = (tr + 2r + br) − (tl + 2l + bl)
Gy = (tl + 2t + tr) − (bl + 2b + br)
edgeMag = √(Gx² + Gy²)
```

**Single threshold:** A single `_SobelThreshold` controls the minimum edge magnitude. Edges below the threshold are ignored; edges above (up to `_SobelMax`) are drawn. Raising the threshold suppresses weak/noisy edges; lowering it reveals fine detail.

**Seam suppression:** If luminance range across all 8 neighbours exceeds `SeamLimit`, the pixel is on a UV seam and the edge is suppressed.

**Characteristics:** Directionally accurate. Skin-adaptive threshold reduces false edges. Still operates on unsmoothed samples, so high-frequency textures can produce noisy edges.

---

### Technique 3 — Normal + Fresnel
**File:** `NPREffect_NormalEdge.cginc`

Two signals, both from the interpolated world-space normal — zero extra texture samples:

**Normal discontinuity:** `ddx/ddy` on the world normal detects geometric creases and silhouettes.

```
normEdge = smoothstep(Threshold ± Smoothness, |∇worldNormal|) × NormStrength
```

**Fresnel silhouette:** `N·V` approaches zero at grazing angles. A double-smoothstep band isolates that zone:

```
fresnel = 1 − saturate(N·V)
fresnelEdge = smoothstep(band around FresnelThreshold) × FresnelStrength
```

**Characteristics:** Geometry-driven — completely insensitive to texture content. Clean contour lines on smooth surfaces. Cannot detect texture or colour-based detail edges.

---

### Technique 4 — Gaussian Sobel
**File:** `NPREffect_GaussianSobel.cginc`

Same 3×3 Sobel as Technique 2, but each of the 8 sample positions is replaced by a **9-tap Gaussian-weighted neighbourhood** before the gradient is computed. This pre-blurs the luminance signal, suppressing high-frequency texture noise before edge detection.

Gaussian weights (configurable, normalised):
```
  diagW  cardW  diagW
  cardW  ctrW   cardW
  diagW  cardW  diagW
  (ctrW + 4×cardW + 4×diagW = 1.0)
```

A threshold band, four progressive smoothstep passes (controlled by a single Tightness parameter), and a power curve give precise control over edge crispness. Tightness = 0 produces soft halo lines; Tightness = 1 produces sharp binary edges.

**Characteristics:** Best-quality colour edge detector. Up to 72 texture samples (8 Sobel positions × 9 Gaussian taps).

---

### Technique 5 — Hierarchical
**File:** `NPREffect_Hierarchical.cginc`

Inspired by the AHEAD (Adaptive Hierarchical Edge Detection) framework. Fuses three independent edge signals — one per physical property of the avatar surface.

**Layer 1 — Depth proxy:**
`length(worldViewDir)` equals camera-to-surface distance. `ddx/ddy` on this scalar detects depth discontinuities at silhouette edges.

**Layer 2 — Normal discontinuity:**
`ddx/ddy` on world normal — same as Technique 3's normal component. Catches geometric creases.

**Layer 3 — Colour (Roberts Cross, optionally Gaussian pre-blurred):**
```
colGrad = |lum(TL) − lum(BR)| + |lum(TR) − lum(BL)|
```
An optional `_HEnableGaussBlur` toggle replaces each of the four sample points with a 9-tap Gaussian neighbourhood before the cross operator runs, smoothing texture noise while preserving structural edges. Weights are user-configurable: `_HCenterWeight`, `_HCardinalWeight`, `_HDiagonalWeight` (normalised at runtime so the kernel always sums to 1). Exposed in the UI as Center W / Cardinal W / Diagonal W, visible only when Gauss Blur is ON.

**Fusion:**
```
edge = max(depthLayer × DepthWeight,
       max(normalLayer × NormalWeight,
           colorLayer  × ColorWeight))
edge = smoothstep(0.20, 0.55, edge)
```

An adaptive sensitivity term scales all layers down in dark areas, avoiding over-edging in shadows.

**Characteristics:** Only technique that simultaneously detects silhouettes (depth), creases (normal), and texture detail (colour) with independent per-layer weights. The Gaussian pre-blur on the colour layer is the most effective addition for noisy avatar textures.

---

### Technique 6 — Kuwahara
**File:** `NPREffect_Kuwahara.cginc`

The classic isotropic Kuwahara filter. Not an edge detector — a **painterly stylisation** that replaces each pixel's colour with the mean of its most homogeneous neighbourhood.

The 3×3 neighbourhood is divided into four overlapping 2×2 quadrants. For each quadrant the mean and variance of the 4 pixels are computed. The quadrant with the **lowest variance** wins; its mean replaces the output colour. The result is blended with the original lit colour by `KuwaharaStrength`.

> **Note:** Full anisotropic Kuwahara (Kyprianidis 2009) aligns the filter with surface geometry via a structure tensor, producing flow-aware brushstrokes. That requires multiple render passes and cannot be done in a single fragment hook. The isotropic version used here is computationally practical for Quest hardware.

**Characteristics:** Smooths flat colour regions, sharpens colour boundaries — oil-painting / cel-shading look. Useful as a pre-processing step before edge detection (see Techniques 7 and 8).

---

### Technique 7 — Kuwahara + Sobel
**File:** `NPREffect_KuwaharaSobel.cginc`

Two stages in one pass:

1. **Kuwahara** (same as Technique 6) — stylises the colour, producing flatter regions with cleaner boundaries.
2. **Gaussian Sobel (full pipeline)** — applied to the **original** base colour texture, not the Kuwahara output. Edge lines are composited over the Kuwahara-stylised colour.

The Gaussian pre-blur is togglable (`Gauss Blur` toggle). When enabled, each of the 8 Sobel sample positions is pre-blurred with a 9-tap Gaussian kernel whose weights are user-configurable: `Center W / Cardinal W / Diagonal W` (normalised at runtime). This matches the full configurable pipeline used in Technique 4 (Gaussian Sobel).

**Line width control:** A threshold band (`Thresh Min` / `Thresh Max` multipliers), four progressive smoothstep passes (`Tightness` — 0 = soft halos, 1 = crisp binary lines), and a power curve give precise control over edge crispness.

**Characteristics:** Painterly flat regions with sharp edge lines. The Kuwahara step reduces noisy interior texture detail that would otherwise produce unwanted inner edges, leaving the Gaussian Sobel to detect only meaningful structural boundaries.

---

### Technique 8 — Kuwahara + Hierarchical
**File:** `NPREffect_KuwaharaGaussHier.cginc`

Two phases in one pass:

1. **Kuwahara** — stylises base colour (same filter as Technique 6).
2. **Hierarchical** — depth + normal + Roberts Cross colour layers with adaptive sensitivity, identical logic to Technique 5 standalone.

The colour layer of the Hierarchical pass supports an optional Gaussian pre-blur (`Color Blur` toggle). When enabled, each of the four Roberts Cross sample points is replaced by a 9-tap Gaussian neighbourhood before the cross operator runs. Weights are user-configurable: `Center W / Cardinal W / Diagonal W` (normalised at runtime). This smooths texture noise in the colour layer while preserving structural edges detected by the depth and normal layers.

**Line width control:** `Hier Tight` — at 0 the final smoothstep is `smoothstep(0.20, 0.55, edge)` (wide soft halos); at 1 it tightens to `smoothstep(0.35, 0.40, edge)` (crisp thin lines).

**Characteristics:** Painterly Kuwahara base combined with geometry-aware edge detection (silhouettes via depth, creases via normals, texture detail via Roberts Cross colour). Gaussian pre-blur on the colour layer is optional and reduces false edges from high-frequency avatar textures.

---

## Technique Summary

| # | Technique | Signal source | Stylises colour | Extra samples |
|---|-----------|--------------|-----------------|---------------|
| 1 | Derivative | ddx/ddy colour + normal | No | 0 |
| 2 | Sobel | 3×3 luminance kernel | No | 8 |
| 3 | Normal + Fresnel | World normal + N·V | No | 0 |
| 4 | Gaussian Sobel | 9-tap Gaussian × 8 Sobel positions | No | up to 72 |
| 5 | Hierarchical | Depth + normal + Roberts Cross (+ optional Gaussian) | No | 4–36 |
| 6 | Kuwahara | Lowest-variance 2×2 quadrant | **Yes** | 9 |
| 7 | Kuwahara + Sobel | Kuwahara + full Gaussian Sobel pipeline | **Yes** | 9 + up to 72 |
| 8 | Kuwahara + Hierarchical | Kuwahara + depth/normal/colour layers (+ optional Gaussian colour blur) | **Yes** | 9 + 4–36 |

---

## In-VR Assessment UI — Design Notes

- **No `Canvas.ForceUpdateCanvases()`** — calling it rebuilds all canvases including internal Meta SDK UI, which triggers an IMGUI `EndLayoutGroup` error. Only the panel's own `RectTransform` is rebuilt with `LayoutRebuilder.ForceRebuildLayoutImmediate`.
- **Outline pass guard** — technique `.cginc` files are excluded from the `NPROutline` pass via `!defined(OUTLINE_PASS)` in `app_functions.hlsl`. Without this guard, the technique code was compiled into the outline pass even though it was never called, which caused Unity to silently skip the pass when certain technique keywords (e.g. `EFFECT_SOBEL`) were active.
- **Dependent rows** — rows are shown/hidden dynamically via a `dependsOnProp` field checked in `ResolveAllDependencies()`. Example: Blur Radius is only shown when Gauss Blur is ON.
- **A/B Compare button** — toggles `ENABLE_NPR_EDGES` keyword off/on across all materials and disables the outline pass, switching between full NPR and base Meta cel-shading.
- **Technique visibility** — only the parameter rows for the currently selected technique are shown; all others are hidden.

---

## File Map

```
Assets/
├── Scripts/
│   ├── AvatarSwitcher.cs          — avatar preset cycling + floating HUD
│   └── NPREdgeDetectionUI.cs      — in-VR parameter panel
├── Shaders/CustomShaders/
│   ├── AvatarNPREdgeEffect.cginc          — Technique 1: Derivative
│   ├── NPREffect_Sobel.cginc              — Technique 2: Sobel
│   ├── NPREffect_NormalEdge.cginc         — Technique 3: Normal + Fresnel
│   ├── NPREffect_GaussianSobel.cginc      — Technique 4: Gaussian Sobel
│   ├── NPREffect_Hierarchical.cginc       — Technique 5: Hierarchical
│   ├── NPREffect_Kuwahara.cginc           — Technique 6: Kuwahara
│   ├── NPREffect_KuwaharaSobel.cginc      — Technique 7: Kuwahara + Sobel
│   └── NPREffect_KuwaharaGaussHier.cginc  — Technique 8: Kuwahara + Hierarchical
└── Samples/Meta Avatars SDK/40.0.1/
    └── Sample Scenes/Scripts/
        └── SampleAvatarEntity.cs  — SDK sample script (modified: SwitchPreset added)
```
