# Meta Avatar NPR Study — Project Documentation
**Thesis project · Quest 3 · Unity 2022 LTS / URP**

---

## What This Project Is

A VR study application running on Meta Quest 3. Participants stand in front of a Meta Avatar and assess thirteen different **Non-Photorealistic Rendering (NPR)** styles — cartoon outlines, painterly effects, halftone, hatching, and edge-detection techniques — directly inside the headset without removing it.

The app lets a researcher cycle through six different avatar presets (different faces/body types) while a participant adjusts every shader parameter live through a floating UI panel, then cycles through three display modes (NPR ON / DEFAULT / REALISTIC) with a single button press.

---

## How the App Works

### Scene structure

The scene contains one `SampleAvatarEntity` (Meta SDK component) which loads and renders the participant's Meta Avatar. An `OvrAvatarManager` handles the SDK lifecycle. The camera is attached to the Quest headset via the standard OVR rig.

On top of this there are two custom scripts:

| Script | Responsibility |
|--------|---------------|
| `AvatarSwitcher.cs` | Cycles avatar presets with the left thumbstick (Y button enters/exits selection mode). Shows a floating HUD. |
| `NPREdgeDetectionUI.cs` | World-space panel opened with B button. All NPR parameters are tunable here with the right controller. |

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

At the very top of the panel is a **Mode [cycle]** button. Each press toggles between two display states:
1. **NPR ON** — `ENABLE_NPR_EDGES` enabled, outline pass enabled, current technique active
2. **DEFAULT** — `ENABLE_NPR_EDGES` disabled, outline disabled; Meta's full `STYLE_2_STANDARD` PBR (rim light, SSS, hair)

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
EFFECT_KUW_GAUSS_HIER | EFFECT_TOON | EFFECT_TOON_SOBEL |
EFFECT_TOON_HIER              — mutually exclusive technique
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
**File:** `NPREffect_Kuwahara2.cginc` (anisotropic — replaces former isotropic version)

Single-scale anisotropic Kuwahara filter based on Kyprianidis (NPAR 2011 §3.3). The former isotropic 4-quadrant design was removed in favour of this structure-tensor-guided 8-sector elliptical filter which produces visually superior direction-aware brushstrokes with no perceptible difference in Quest 3 performance.

**Step 1 — Structure tensor:** Hardware `ddx`/`ddy` of the shaded luminance gives `gx`, `gy`. The 2×2 structure tensor `J = [[E,F],[F,G]]` = `[[gx²,gx·gy],[gx·gy,gy²]]` encodes local gradient structure. Eigenanalysis yields:
- `φ` — dominant orientation angle (direction of minimum change, i.e. along the feature): `φ = ½ arctan(2F / (E−G)) + π/2`
- `A` — anisotropy `(λ₁−λ₂)/(λ₁+λ₂)`, range 0–1

**Step 2 — Ellipse axes (paper §3.3.1):**
```
a = (α + A)/α · r    (major axis, along feature direction)
b =  α/(α + A) · r   (minor axis, across feature)
```
`α` is a user-tunable eccentricity parameter (default 1). A=0 gives a circle; A=1 gives 2:1 elongation.

**Step 3 — 8 sectors over the rotated ellipse:** The transform `R_{−φ} · diag(a,b)` maps unit-disc points to UV offsets. For each of 8 sector centre directions (at 0°, 45°, 90°, …, 315° in the unit disc), 3 samples are taken at radii 0.45, 0.75, 1.0, plus the shared centre. Gaussian-inspired weights (0.40, 0.28, 0.20, 0.12) compute the weighted mean `m_i` and std deviation `σ_i` per sector.

**Step 4 — Soft weighted blend (paper §3.3.1 eq.):**
```
ω_i = max(τ, σ_i)^{-q}
result = Σ(ω_i · m_i) / Σ(ω_i)
```
`τ` (default 0.02) prevents divide-by-zero in flat regions. `q` (default 8) controls sharpness — high q means only the most homogeneous sector(s) contribute.

> **Note:** The multi-scale pyramid from the 2011 paper (coarse-to-fine across Lanczos3 levels) requires multiple render passes and cannot be implemented in `AppSpecificPostManipulation`.

| UI Slider | What it does |
|-----------|-------------|
| Radius | Filter ellipse radius (major axis) |
| Strength | Blend with original lit colour |
| Alpha | Eccentricity α — 1 = standard, >1 = more elongated brushstrokes |
| Q Sharp | Sector weight sharpness — higher = harder region boundaries |
| Tau Floor | Variance floor τ — prevents instability in uniform flat areas |

**Characteristics:** Brushstrokes follow surface feature directions. Smooth areas with A≈0 behave like an enhanced isotropic Kuwahara. Strong gradients (A≈1) produce elongated strokes aligned with edges. 25 texture samples (1 centre + 8 sectors × 3).

---

### Technique 7 — Kuwahara + Sobel
**File:** `NPREffect_Kuwahara2Sobel.cginc`

Two stages in one pass:

1. **Kuwahara** (anisotropic, same as Technique 6) — structure-tensor-guided 8-sector painterly stylisation.
2. **Gaussian Sobel (full pipeline)** — applied to the **original** base colour texture. Edge lines composited over the Kuwahara-stylised colour.

Optional 9-tap Gaussian pre-blur per Sobel position, threshold band, 4× progressive smoothstep, power curve.

**Characteristics:** Direction-aware painterly base with sharp Sobel edge lines. The anisotropic Kuwahara step produces more coherent flat regions, reducing false interior edges in the Sobel detector.

---

### Technique 8 — Kuwahara + Hierarchical
**File:** `NPREffect_Kuwahara2GaussHier.cginc`

Two stages in one pass:

1. **Kuwahara** (anisotropic, same as Technique 6) — structure-tensor-guided 8-sector stylisation.
2. **Hierarchical** — depth + normal + Roberts Cross colour layers with adaptive sensitivity. Optional Gaussian pre-blur on the colour layer (`Color Blur` toggle).

**Line width control:** `Hier Tight` — at 0 the final smoothstep is `smoothstep(0.20, 0.55, edge)` (wide soft halos); at 1 it tightens to `smoothstep(0.35, 0.40, edge)` (crisp thin lines).

**Characteristics:** Direction-aware painterly base combined with geometry-aware edge detection (silhouettes via depth, creases via normals, texture detail via Roberts Cross colour). The anisotropic Kuwahara step produces more coherent flat regions, reducing false interior edges in the colour layer.

---

### Technique 9 — Toon / Cel Shader
**File:** `NPREffect_Toon.cginc`
**Keyword:** `EFFECT_TOON`

Pure posterisation-based cel shading — **no edge detection**. Use the inverted-hull outline pass for silhouette lines, and Technique 10 or 11 for image-space edge lines on top.

**Colour posterisation:**
```
posterized = floor(color × bands + 0.5) / bands   // round-to-nearest quantization
color.rgb  = lerp(original, posterized, PosterizeStrength)
```
This gives the stepped flat-colour look of hand-drawn cel animation. Posterization runs **first**, then saturation is scaled independently:
```
lum       = dot(color.rgb, float3(0.2126, 0.7152, 0.0722))
color.rgb = lerp(float3(lum,lum,lum), color.rgb, Saturation)
```
Ordering matters: saturating after posterization avoids driving low channels negative (which would cause darkening when clamped to 0). Default saturation is 1.0 (unchanged); values above 1.0 boost cartoon vibrancy.

| UI Slider | What it does |
|-----------|-------------|
| Color Bands | Discrete posterization steps (2 = two-tone, 4 = four-tone, 8 = subtle) |
| Posterize Str | Blend between original PBR and fully posterized colour |
| Saturation | Colour saturation scale (1 = unchanged, 1.5 = boosted cartoon look) |

**Characteristics:** Zero texture samples. Fast. Combine with the inverted-hull outline for maximum cartoon effect with no extra pass cost. The `AppSpecificPostManipulation` hook receives the final composited PBR colour (raw NdotL is inaccessible), so band quantization works on perceived brightness rather than raw light contribution.

---

### Technique 10 — Toon + Sobel
**File:** `NPREffect_ToonSobel.cginc`
**Keyword:** `EFFECT_TOON_SOBEL`

Two phases in one pass:

**Phase 1 — Toon posterisation:** Identical to Technique 9 using `_TS*`-prefixed uniforms (`_TSColorBands`, `_TSPosterizeStrength`, `_TSSaturation`). Posterize first, then saturate.

**Phase 2 — Gaussian Sobel edge detection:** Identical pipeline to the Sobel stage in Technique 7 (Kuwahara + Sobel), applied to the **original** base colour texture:
- Optional 9-tap Gaussian pre-blur per Sobel sample position (toggle `_TSEnableGaussBlur`)
- Configurable Gaussian weights: `_TSCenterWeight`, `_TSCardinalWeight`, `_TSDiagonalWeight`
- 3×3 Sobel gradient computation
- Threshold band (`_TSThreshold × _TSThreshMin` → `_TSThreshold × _TSThreshMax`)
- 4× progressive smoothstep passes controlled by a single `_TSTightness` parameter
- Power curve (`_TSPowerCurve`) for edge opacity falloff
- Edge colour taken from the shared `_InnerLineColor` uniform

| UI Row | What it does |
|--------|-------------|
| Color Bands | Toon posterization steps |
| Posterize Str | Toon posterization blend |
| Saturation | Toon saturation scale |
| Gauss Blur | Toggle 9-tap Gaussian pre-blur on Sobel samples |
| Sobel Dist | Sobel kernel UV offset |
| Blur Radius | Per-sample Gaussian radius (visible when Gauss Blur ON) |
| Center W / Cardinal W / Diagonal W | Gaussian kernel weights (visible when Gauss Blur ON) |
| Threshold | Sobel edge magnitude threshold |
| Thresh Min / Max | Threshold band multipliers |
| Tightness | Edge crispness (0 = wide soft halos, 1 = crisp thin lines) |
| Power Curve | Post-pass power curve on edge opacity |
| Sobel Strength | Overall edge opacity |

**Characteristics:** Cel-shaded posterized colour with Sobel edge lines. Up to 72 texture samples for the Sobel stage (8 positions × 9 Gaussian taps). Toon posterization produces large flat regions that the Sobel detector reads cleanly, reducing noisy interior edges compared to running Sobel on the original PBR colour.

---

### Technique 11 — Toon + Hierarchical
**File:** `NPREffect_ToonGaussHier.cginc`
**Keyword:** `EFFECT_TOON_HIER`

Two phases in one pass:

**Phase 1 — Toon posterisation:** Identical to Technique 9 using `_TH*`-prefixed uniforms (`_THColorBands`, `_THPosterizeStrength`, `_THSaturation`). Posterize first, then saturate.

**Phase 2 — Hierarchical edge detection:** Identical pipeline to Technique 5 (Hierarchical) and the hierarchical stage in Technique 8 (Kuwahara + Hierarchical):

- **Depth layer:** `ddx/ddy` on `length(worldViewDir)` → silhouette edges
- **Normal layer:** `ddx/ddy` on world normal → geometric crease edges
- **Colour layer (Roberts Cross):** diagonal luminance differences `|lum(TL)−lum(BR)| + |lum(TR)−lum(BL)|` using `_TH*`-prefixed Gaussian weights; optional 9-tap Gaussian pre-blur per sample point (`_THEnableGaussBlur`)
- **Adaptive suppression:** scales all layers down in dark areas by `_THAdaptiveStrength`
- **Fusion:** `max(depthLayer × DepthWeight, max(normalLayer × NormalWeight, colorLayer × ColorWeight))`
- **Line width:** `_THHierTightness` controls the final smoothstep band (0 = wide halos, 1 = crisp thin lines)
- **Edge colour:** `_THEdgeColor` (technique-specific, unlike Toon+Sobel which reuses `_InnerLineColor`)

| UI Row | What it does |
|--------|-------------|
| Color Bands | Toon posterization steps |
| Posterize Str | Toon posterization blend |
| Saturation | Toon saturation scale |
| Depth Thresh / Normal Thresh / Color Thresh | Per-layer detection thresholds |
| Depth W / Normal W / Color W | Per-layer blend weights |
| Edge Width | Roberts Cross UV offset |
| Adaptive Str | Dark-area edge suppression strength |
| Hier Tight | Edge crispness (0 = soft, 1 = crisp) |
| Hier Strength | Overall hierarchical edge opacity |
| Color Blur | Toggle 9-tap Gaussian pre-blur on colour samples |
| Blur Radius / Center W / Cardinal W / Diagonal W | Gaussian kernel params (visible when Color Blur ON) |
| Edge Color | Ink colour for hierarchical edges |

**Characteristics:** Cel-shaded posterized colour with geometry-aware edge detection (silhouettes, creases, colour detail) and per-layer weight control. Most flexible of the three Toon variants. 4–36 texture samples for the colour layer depending on Gaussian blur state.

---

### Technique 12 — Halftone
**File:** `NPREffect_Halftone.cginc`
**Keyword:** `EFFECT_HALFTONE`
**Source:** Adapted from `Assets/Shaders/NPR/HalftoneHatching.shader` (`HalftonePattern` function).

Circular dot grid in UV space. Tone is derived from the luminance of the incoming PBR colour — darker areas produce larger dots, lighter areas produce smaller dots or none.

```
rotated  = Rotate2D(uv, HTAngle)
gridPos  = frac(rotated × HTScale) − 0.5
dist     = length(gridPos)
dotRadius = sqrt(max(0, 1 − tone)) × 0.5      // darker → bigger dot
pattern  = 1 − smoothstep(dotRadius ± 0.5/HTSharpness, dist)
```

**Colour model (identical to HalftoneHatching source):**
```
paperCol     = lerp(HTPaperColor,  PBRcolor,              TextureInfluence)
inkCol       = lerp(HTInkColor,    PBRcolor × HTInkColor, TextureInfluence)
patternColor = lerp(paperCol, inkCol, pattern)
finalColor   = lerp(PBRcolor, patternColor, HTStrength)
```
`TextureInfluence = 0` gives a flat ink-on-paper look; `= 1` tints the ink and paper with the original PBR colour, preserving avatar texture detail.

| UI Row | What it does |
|--------|-------------|
| Dot Scale | Grid frequency — higher = more, smaller dots |
| Sharpness | Dot edge softness (1 = very soft, 50 = crisp) |
| Grid Angle | Rotation of the dot grid (0–90°) |
| Tone Bias | Shifts tone darker/lighter (-0.5–0.5) |
| Ink Color | Dot fill colour |
| Paper Color | Background colour |
| Tex Influence | Blend between flat and PBR-tinted ink/paper |
| Strength | Overall blend of halftone over original PBR |

**Characteristics:** Zero extra texture samples (fully procedural). UV-space grid follows the avatar's UV layout rather than screen pixels — patterns appear stable when the head turns. Combine with the inverted-hull outline for a classic comic-print look.

---

### Technique 13 — Hatching
**File:** `NPREffect_Hatching.cginc`
**Keyword:** `EFFECT_HATCHING`
**Source:** Adapted from `Assets/Shaders/NPR/HalftoneHatching.shader` (`HatchingPattern` function, Tonal Art Map approach).

Four line layers that activate progressively as tone darkens, following Praun et al. "Real-Time Hatching" (SIGGRAPH 2001):

```
t = 1 − tone   (darkness, 0=white, 1=black)

Layer 1 (t > 0.15): primary direction  × smoothstep(0.15, 0.40, t)
Layer 2 (t > 0.35): cross direction    × smoothstep(0.35, 0.60, t)
Layer 3 (t > 0.55): dense diagonal     × smoothstep(0.55, 0.80, t)  [thickness × 1.5]
Layer 4 (t > 0.80): solid fill         = smoothstep(0.80, 1.00, t)

pattern = max across all active layers
```

Each layer uses a rotated sine-style grid:
```
rotated = Rotate2D(uv, angleDeg)
linePos = frac(rotated.x × HatScale)
line    = 1 − smoothstep(thickness, thickness+0.02, |linePos − 0.5|)
```

Same ink/paper colour model as Halftone (above) using `_Hat*` uniforms.

| UI Row | What it does |
|--------|-------------|
| Hatch Scale | Line grid frequency |
| Primary Angle | Direction of Layer 1 lines (0–180°) |
| Cross Angle | Direction of Layer 2 lines (0–180°) |
| Thickness | Line width (0.01 = hairline, 0.5 = thick) |
| Tone Bias | Shifts tone darker/lighter |
| Ink Color | Line colour |
| Paper Color | Background between lines |
| Tex Influence | Blend between flat and PBR-tinted ink/paper |
| Strength | Overall blend of hatching over original PBR |

**Characteristics:** Zero extra texture samples (fully procedural). Three independent line directions emerge naturally as the avatar's shaded tone darkens. Combine with the inverted-hull outline for a pen-and-ink illustration look.

---

## Technique Summary

| # | Name | File | Signal source | Stylises colour | Extra samples |
|---|------|------|--------------|-----------------|---------------|
| 1 | Derivative | `AvatarNPREdgeEffect.cginc` | ddx/ddy colour + normal | No | 0 |
| 2 | Sobel | `NPREffect_Sobel.cginc` | 3×3 luminance kernel | No | 8 |
| 3 | Normal + Fresnel | `NPREffect_NormalEdge.cginc` | World normal + N·V | No | 0 |
| 4 | Gaussian Sobel | `NPREffect_GaussianSobel.cginc` | 9-tap Gaussian × 8 Sobel positions | No | up to 72 |
| 5 | Hierarchical | `NPREffect_Hierarchical.cginc` | Depth + normal + Roberts Cross (+ optional Gaussian) | No | 4–36 |
| 6 | Kuwahara | `NPREffect_Kuwahara2.cginc` | Anisotropic 8-sector ellipse (structure tensor φ+A) | **Yes** | 25 |
| 7 | Kuwahara + Sobel | `NPREffect_Kuwahara2Sobel.cginc` | Kuwahara + full Gaussian Sobel pipeline | **Yes** | 25 + up to 72 |
| 8 | Kuwahara + Hierarchical | `NPREffect_Kuwahara2GaussHier.cginc` | Kuwahara + depth/normal/colour layers (+ optional Gaussian) | **Yes** | 25 + 4–36 |
| 9 | Toon / Cel Shader | `NPREffect_Toon.cginc` | Posterize bands + saturation (no edges) | **Yes** | 0 |
| 10 | Toon + Sobel | `NPREffect_ToonSobel.cginc` | Toon posterize + full Gaussian Sobel pipeline | **Yes** | up to 72 |
| 11 | Toon + Hierarchical | `NPREffect_ToonGaussHier.cginc` | Toon posterize + depth/normal/colour layers (+ optional Gaussian) | **Yes** | 4–36 |
| 12 | Halftone | `NPREffect_Halftone.cginc` | Procedural UV-space dot grid, tone from luminance | **Yes** | 0 |
| 13 | Hatching | `NPREffect_Hatching.cginc` | TAM 4-layer UV-space line grid, tone from luminance | **Yes** | 0 |

---

## In-VR Assessment UI — Design Notes

- **No `Canvas.ForceUpdateCanvases()`** — calling it rebuilds all canvases including internal Meta SDK UI, which triggers an IMGUI `EndLayoutGroup` error. Only the panel's own `RectTransform` is rebuilt with `LayoutRebuilder.ForceRebuildLayoutImmediate`.
- **Outline pass guard** — technique `.cginc` files are excluded from the `NPROutline` pass via `!defined(OUTLINE_PASS)` in `app_functions.hlsl`. Without this guard, the technique code was compiled into the outline pass even though it was never called, which caused Unity to silently skip the pass when certain technique keywords (e.g. `EFFECT_SOBEL`) were active.
- **Dependent rows** — rows are shown/hidden dynamically via a `dependsOnProp` field checked in `ResolveAllDependencies()`. Example: Blur Radius is only shown when Gauss Blur is ON.
- **Mode cycle button** — toggles between two display states on each press:
  1. **NPR ON** — `ENABLE_NPR_EDGES` enabled, outline pass enabled, current technique active
  2. **DEFAULT** — `ENABLE_NPR_EDGES` disabled, outline disabled; Meta's full `STYLE_2_STANDARD` PBR (rim light, SSS, hair)
- **Technique visibility** — only the parameter rows for the currently selected technique are shown; all others are hidden.
- **Toon darkening fix** — in the Toon family (Techniques 9–11), posterization must run **before** saturation. Applying saturation >1 before posterization can drive low RGB channels negative (clamped to 0 on output), causing the avatar to appear darker. The correct order is: quantize first, then scale saturation on the already-quantized colour.
- **Halftone/Hatching tone source** — both Techniques 12 and 13 derive "tone" from `luminance(o.color)` (the already-composited PBR colour), not from a separate NdotL computation. This means the pattern responds correctly to all PBR lighting including shadows, SSS, and ambient — without any additional light passes.

---

## File Map

```
Assets/
├── Scripts/
│   ├── AvatarSwitcher.cs                  — avatar preset cycling + floating HUD
│   └── NPREdgeDetectionUI.cs              — in-VR parameter panel
├── Shaders/
│   ├── NPR/
│   │   └── HalftoneHatching.shader        — source shader (reference; not used on avatar)
│   └── CustomShaders/
│       ├── AvatarNPREdgeEffect.cginc      — Technique 1:  Derivative
│       ├── NPREffect_Sobel.cginc          — Technique 2:  Sobel
│       ├── NPREffect_NormalEdge.cginc     — Technique 3:  Normal + Fresnel
│       ├── NPREffect_GaussianSobel.cginc  — Technique 4:  Gaussian Sobel
│       ├── NPREffect_Hierarchical.cginc   — Technique 5:  Hierarchical
│       ├── NPREffect_Kuwahara2.cginc      — Technique 6:  Kuwahara (anisotropic)
│       ├── NPREffect_Kuwahara2Sobel.cginc — Technique 7:  Kuwahara + Sobel
│       ├── NPREffect_Kuwahara2GaussHier.cginc — Technique 8: Kuwahara + Hierarchical
│       ├── NPREffect_Toon.cginc           — Technique 9:  Toon / Cel Shader
│       ├── NPREffect_ToonSobel.cginc      — Technique 10: Toon + Sobel
│       ├── NPREffect_ToonGaussHier.cginc  — Technique 11: Toon + Hierarchical
│       ├── NPREffect_Halftone.cginc       — Technique 12: Halftone
│       ├── NPREffect_Hatching.cginc       — Technique 13: Hatching
│       └── app_specific/
│           └── app_functions.hlsl         — multi_compile keywords + include dispatch + OUTLINE_PASS hook
└── Samples/Meta Avatars SDK/40.0.1/
    └── Sample Scenes/Scripts/
        └── SampleAvatarEntity.cs          — SDK sample script (modified: SwitchPreset added)
```
