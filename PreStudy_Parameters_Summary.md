# Pre-Study Parameter Configuration — V4 Gaussian Pre-Filtered Sobel
**For: Prof. Dr. Oliver Deussen, Prof. Dr. Tiare Feuchtner**
Nidanur Günay — Master's Thesis, University of Konstanz, 2026

A seven-round visual ranking study was conducted with pilot participants to select optimal rendering parameters for the V4 Gaussian Pre-Filtered Sobel shader before the main user study. Each round isolated one parameter group while holding all others constant. Participants ranked images by stylization quality and trust as advisor.

---

## Round 1 — Inner Line Threshold (L1–L5)

**Varied:** `_InnerLineThreshold`

| Label | Threshold |
|-------|-----------|
| L1 | 0.01 |
| L2 | 0.02 |
| L3 | 0.03 |
| L4 | 0.04 |
| L5 | 0.05 |

**Fixed for all L variants:** Gaussian blur off, normal edges off, inner line sample distance 0.2, light sensitivity 0.5, shadow strength 0.5, outline width 0.005, depth offset on, rim light on.

---

## Round 2 — Outer Outline Width and Depth Offset (O1–O6)

**Varied:** `_OuterOutlineWidth` (three values) × `_UseOutlineDepthOffset` (on/off)

| Label | Outline Width | Depth Offset | Depth Bias |
|-------|--------------|--------------|-----------|
| O1 | 0.005 | Off | 15 |
| O2 | 0.005 | On | 15 |
| O3 | 0.007 | Off | 15 |
| O4 | 0.007 | On | 15 |
| O5 | 0.003 | Off | 15 |
| O6 | 0.003 | On | 15 |

**Fixed:** Inner line threshold 0.05, depth bias 15 throughout. Depth bias is set to 15 because the depth offset effect is not clearly visible below a value of approximately 5; the purpose of this round is to evaluate the perceptual difference between offset on and off, not to select a depth bias value.

---

## Round 3 — XToon Toon Shading (T1–T5)

**Varied:** Shadow Strength (`_ShadowStrength`, SS) and Detail Bias (`_DetailBias`, DB). Detail mode fixed to Depth.

| Label | Shadow Strength | Detail Bias |
|-------|----------------|------------|
| T1 | 1.0 | 0.5 |
| T2 | 0.0 | 0.5 |
| T3 | 0.5 | 0.5 |
| T4 | 0.5 | 1.0 |
| T5 | 0.5 | 0.0 |

**Fixed:** Outline width 0.005, depth offset on (bias 15), inner line threshold 0.03. Curvature and Manual detail modes were excluded: preliminary testing showed they produced near-identical output to Depth mode, and including all three would have tripled the round without providing actionable differentiation.

---

## Round 4 — Rim Light On/Off (R1–R2)

**Varied:** `_EnableRim` (on/off). Rim power fixed at 4.0.

| Label | Rim Light | Rim Power |
|-------|-----------|-----------|
| R1 | Off | 4.0 |
| R2 | On | 4.0 |

Rim power 4.0 was selected through preliminary testing as the value that produces a visible but balanced silhouette rim without over-brightening the avatar contour.

---

## Round 5 — Kuwahara Kernel Size (K1–K4)

The Kuwahara filter is applied as a post-process layer on top of the V4 base configuration (L5 parameters). K1 is the unfiltered V4 baseline shown as a reference.

**Varied:** `_KernelSize`

| Label | Kernel Size | Notes |
|-------|------------|-------|
| K1 | — | V4 baseline (L5), no Kuwahara |
| K2 | 2 | Minimal smoothing |
| K3 | 17 | Mid-range |
| K4 | 32 | Maximum smoothing |

Steps are spaced across the supported kernel range (2–32). Sector count was excluded after preliminary testing showed no perceptually meaningful difference across its range.

---

## Round 6 — Kuwahara Hardness and Sharpness (A1–A4)

Applied on top of the V4 base configuration (L5). A1 is the V4 baseline reference without Kuwahara. Hardness and sharpness are varied inversely: high hardness preserves hard edges at the cost of sharpness, high sharpness produces smoother transitions at the cost of edge definition.

**Varied:** `_Hardness` and `_Sharpness`

| Label | Hardness | Sharpness |
|-------|----------|-----------|
| A1 | — | — | *(V4 baseline, no Kuwahara)* |
| A2 | 1 | 18 |
| A3 | 9 | 9 |
| A4 | 18 | 1 |

---

## Round 7 — Hierarchical Depth Edge Detection (H1–H6)

Only depth edges are evaluated in this round. Colour edge detection is already handled by the V4 Sobel component. Normal edge testing was conducted separately via direct material inspection (normal edges are camera-angle-dependent and not suitable for a fixed-view ranking comparison). Testing all three cue types in a ranking study would extend the study without providing additional actionable data. Depth scale is fixed at 2.

**Varied:** `_DepthThreshold` (six values)

| Label | Depth Threshold |
|-------|----------------|
| H1 | *(confirm from presets)* |
| H2 | *(confirm from presets)* |
| H3 | *(confirm from presets)* |
| H4 | *(confirm from presets)* |
| H5 | *(confirm from presets)* |
| H6 | *(confirm from presets)* |

---

## Baseline V4 Configuration (from L5, used as reference in Rounds 5–7)

| Parameter | Value |
|-----------|-------|
| Inner line threshold | 0.05 |
| Inner line sample distance | 0.2 |
| Gaussian blur | Off |
| Normal edges | Off |
| Fresnel edges | Off |
| Light sensitivity | 0.5 |
| Shadow strength | 0.5 |
| Detail mode | Depth |
| Outer outline width | 0.005 |
| Depth offset | On |
| Rim light | On |
| Rim power | 4.0 |
