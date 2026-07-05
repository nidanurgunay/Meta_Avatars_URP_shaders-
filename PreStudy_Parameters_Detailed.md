# Pre-Study Parameter Log — Detailed Reference
Nidanur Günay — Master's Thesis, University of Konstanz, 2026
Shader: V4 Gaussian Pre-Filtered Sobel (`Custom/V4_GaussianPreFilteredSobel`)

This document is the internal reference for the parameter selection pre-study. It records every parameter used in each round, the rationale for each design decision, discrepancies between the CSV presets and the intended configuration, and notes for thesis writing.

---

## Study Design Overview

**Purpose:** Select the best V4 shader parameter combination before the main user study. Decisions made here determine the C3 (Avaturn NPR) condition.

**Structure:** 7 rounds. Each round tests one parameter group in isolation. Within each round, all other parameters are held constant at the baseline established by the previous round's winning selection (or the initial baseline for Round 1).

**Questions per round:**
1. Rank images from best (1) to worst stylized character
2. Rank images from most (1) to least trustworthy as advisor
3. Optional free-text: what influenced your ranking?

**Counterbalancing:** Image labels are neutral (L1-L5, O1-O6, etc.) to prevent label priming. The winning parameter value from each round carries forward into all subsequent rounds.

---

## Round 1 — Inner Line Threshold (L1–L5)

**What it controls:** `_InnerLineThreshold` sets the minimum gradient magnitude required for the Sobel edge detection to draw an inner line. Lower values draw more lines including noise; higher values suppress noise but can miss structural edges.

**Images tested:** 5

| Label | `_InnerLineThreshold` |
|-------|----------------------|
| L1 | 0.01 |
| L2 | 0.02 |
| L3 | 0.03 |
| L4 | 0.04 |
| L5 | 0.05 |

**All other parameters fixed:**

| Parameter | Value | Shader Property |
|-----------|-------|----------------|
| Gaussian blur | Off | `_EnableGaussianBlur = 0` |
| Normal edges | Off | `_EnableNormalEdges = 0` |
| Fresnel edges | Off | `_EnableFresnelEdge = 0` |
| Inner line sample distance | 0.2 | `_InnerLineBlur = 0.2` |
| Light sensitivity | 0.5 | `_LightSensitivity = 0.5` |
| Shadow strength | 0.5 | `_ShadowStrength = 0.5` |
| Detail mode | Depth | `_DetailMode = 0` |
| Detail bias | 0.5 | `_DetailBias = 0.5` |
| Outer outline width | 0.005 | `_OuterOutlineWidth = 0.005` |
| Depth offset | On | `_UseOutlineDepthOffset = 1` |
| Rim light | On | `_EnableRim = 1` |

**CSV verification notes:**
- L1-L5 threshold values confirmed in presets (L1=0.01, L2=0.02, L3=0.03, L4=0.04, L5=0.05).
- Depth bias: L1 CSV shows `_OutlineDepthBias = 15`; L2/L5 show `_OutlineDepthBias = 5`. The intended value was consistent across all L presets. The L1 discrepancy is likely from an earlier save before the value was standardized. Functionally, all presets have depth offset enabled so the bias difference does not affect the visual purpose of Round 1 (testing threshold only).

**Why these values:** The range 0.01–0.05 covers the perceptually meaningful variation. Below 0.01, too much noise is picked up from the baked texture gradients. Above 0.05, structural lines on the clothing begin to disappear. L5 (0.05) was expected to be the cleanest option on the head material because the modified (reduced baked shading) head texture has lower gradient noise.

---

## Round 2 — Outer Outline Width and Depth Offset (O1–O6)

**What it controls:**
- `_OuterOutlineWidth`: thickness of the inverted-hull geometry outline (silhouette line)
- `_UseOutlineDepthOffset`: whether to push the outline geometry slightly behind in clip space to avoid z-fighting artifacts around eye geometry and thin mesh edges
- `_OutlineDepthBias`: the magnitude of the clip-space depth push when offset is on

**Images tested:** 6 (3 widths × 2 offset states)

| Label | `_OuterOutlineWidth` | Depth Offset | `_OutlineDepthBias` |
|-------|---------------------|--------------|---------------------|
| O1 | 0.005 | Off | 15 |
| O2 | 0.005 | On | 15 |
| O3 | 0.007 | Off | 15 |
| O4 | 0.007 | On | 15 |
| O5 | 0.003 | Off | 15 |
| O6 | 0.003 | On | 15 |

**Inner line threshold fixed at 0.05 (L5)** for all O variants.

**Why depth bias 15 for this round:** The depth offset effect on eye artifact removal is not clearly visible at lower bias values (the difference between on and off is subtle below approximately 5). A value of 15 was used to make the on/off comparison perceptually unambiguous for naive participants. The goal of this round is to establish whether participants prefer the outline with or without offset, not to select the bias magnitude itself.

**Why these three widths:** 0.005 is the default baseline. 0.007 (wider) and 0.003 (narrower) bracket it with equal steps. Wider outlines risk covering facial details; narrower outlines risk disappearing on lower-resolution displays or at viewing distance.

**CSV verification notes:**
- O1/O2 width 0.005 confirmed; O3 width 0.007 confirmed (Head slot); O4 width 0.007 confirmed; O5/O6 width 0.003 confirmed.
- O6 depth bias is 15 in CSV (correct). O1-O5 depth bias shows 5 in CSV for most entries. This is a save-order artifact: the 15 value was finalized late. For the rendered images actually used in the form, verify that the bias was set correctly in the material at render time. The rendered outcome is what matters for the study, not the saved preset values.

---

## Round 3 — XToon Toon Shading (T1–T5)

**What it controls:**
- `_ShadowStrength`: controls how strongly the dark shadow tone replaces the lit colour in unlit regions. 0 = no shadow darkening, 1 = maximum darkening.
- `_DetailBias`: controls where the 2D ramp detail axis is sampled from when using Depth mode. 0 = near (more detailed, less contour variation), 1 = far (more contour variation by depth).
- `_DetailMode`: determines what drives the second ramp axis. Fixed to Depth (0) for this round.

**Images tested:** 5

| Label | Shadow Strength (`_ShadowStrength`) | Detail Bias (`_DetailBias`) |
|-------|-------------------------------------|----------------------------|
| T1 | 1.0 | 0.5 |
| T2 | 0.0 | 0.5 |
| T3 | 0.5 | 0.5 |
| T4 | 0.5 | 1.0 |
| T5 | 0.5 | 0.0 |

**Fixed parameters inherited from Rounds 1–2:**

| Parameter | Value |
|-----------|-------|
| Inner line threshold | 0.03 (midpoint; see note) |
| Outer outline width | 0.005 |
| Depth offset | On |
| Depth bias | 15 |
| Rim light | On |

**Note on inner line threshold for T round:** CSV shows InnerLineThreshold=0.03 for t1/t3/t4 (Look slot) and 0.05 for t2/t5 in some slots. The intended value was the winner from Round 1. If L3 (0.03) was selected as Round 1 winner, this is consistent. If L5 (0.05) won instead, some t presets may have been saved before that decision was finalized.

**Why Curvature and Manual were excluded:** Preliminary inspection showed that Curvature mode produces highly similar output to Depth mode for standing avatars with low surface curvature variation. Manual mode produces identical output to Depth when using the same numeric value. Including all three would have produced three nearly identical avatars per combination, making the round useless for participants and increasing fatigue without return.

**Design of the matrix:** T3 (SS=0.5, DB=0.5) is the reference midpoint. T1 and T2 test the extremes of shadow strength while holding detail bias constant. T4 and T5 test the extremes of detail bias while holding shadow strength at the midpoint. This cross-pattern isolates each parameter's effect independently.

**CSV verification:** t1 (SS=1, DB=0.5), t3 (SS=0.5, DB=0.5), t4 (SS=0.5, DB=1.0), t5 (SS=0.5, DB=0.0) all confirmed. t2 (SS=0, DB=0.5) confirmed from Hair slot only.

---

## Round 4 — Rim Light On/Off (R1–R2)

**What it controls:** `_EnableRim` toggles a Fresnel-based rim highlight at the avatar silhouette. Rim power (`_RimPower`) controls how tight the rim band is: higher values = tighter rim concentrated at the very edge.

**Images tested:** 2 (forced choice)

| Label | Rim Light | Rim Power |
|-------|-----------|-----------|
| R1 | Off | 4.0 |
| R2 | On | 4.0 |

**Why rim power 4.0:** Manual testing showed that values below 3.0 produce a broad glow over much of the avatar body, which competes visually with the toon shading. Values above 5.0 produce a very thin line that is barely visible at normal viewing distance. 4.0 gives a clearly visible, balanced rim without dominating the overall look.

**Why not test different rim power values:** The pre-study already tests 7 parameter groups. Adding a rim power variation round would make the study significantly longer. The on/off decision has the greatest impact; if rim is selected as on, the 4.0 value can be adjusted after the study if needed based on feedback.

**CSV verification:** r1 (EnableRim=0, RimPower=4.0) confirmed (Head slot). r2 (EnableRim=1, RimPower=4.0) confirmed (Look slot).

---

## Round 5 — Kuwahara Kernel Size (K1–K4)

**What it controls:** The Kuwahara filter is an isotropic painterly filter applied as a post-process over the V4 avatar. `_KernelSize` sets the radius of the filter kernel in pixels. Larger kernels produce more aggressively smoothed, more painterly output at the cost of losing fine detail. The shader is `AnisotropicKuwahara.shader` (isotropic in this implementation; anisotropic requires a structure tensor pass which is not available within the single-pass fragment hook).

**K1 is the V4 baseline (L5 configuration) with no Kuwahara applied.** Included as a reference to anchor the comparison.

**Images tested:** 4

| Label | `_KernelSize` | Notes |
|-------|--------------|-------|
| K1 | — | V4 baseline, no Kuwahara |
| K2 | 2 | Minimal effect — near-identical to baseline |
| K3 | 17 | Mid-range |
| K4 | 32 | Maximum available smoothing |

**Why these values:** The shader supports kernel sizes from 2 to 32. Three non-baseline values (2, 17, 32) provide approximately equal spacing across the range. K2=2 was included even though it produces minimal visible change, as a step between baseline (no filter) and full effect. This gives participants a gradient from no stylization to maximum painterly abstraction.

**Why sector count was excluded:** The sector count parameter controls how many directional sectors the Kuwahara filter uses per pixel. Testing showed negligible perceptual difference between sector counts for this avatar and material. Adding a sector count round would lengthen the study without useful data.

**Base configuration for K variants (from L5 / winner of Rounds 1–4):**

| Parameter | Value |
|-----------|-------|
| Inner line threshold | 0.05 (or winner from R1) |
| Outer outline width | 0.005 |
| Depth offset | On |
| Depth bias | 15 |
| Shadow strength | 0.5 |
| Detail bias | 0.5 |
| Rim light | On, power 4.0 |

*Note: K presets are not stored in ShaderPresets.csv as of the pre-study. The Kuwahara filter is a separate material/shader applied as a second pass, not a property of the V4 shader itself.*

---

## Round 6 — Kuwahara Hardness and Sharpness (A1–A4)

**What it controls:**
- `_Hardness`: controls how sharply the filter transitions between sectors at region boundaries. Higher hardness = more defined blocky paint regions.
- `_Sharpness`: controls how smoothly variance is weighted across the sector. Higher sharpness = smoother gradients within paint regions.

These two parameters are inversely related in visual effect: maximizing both simultaneously produces an over-sharpened result; minimizing both produces an overly blurry result. Testing them with an inverse relationship (high H / low S, balanced, low H / high S) covers the useful perceptual space efficiently.

**A1 is the V4 baseline (L5) with no Kuwahara.** Included to allow direct comparison with unfiltered output.

**Images tested:** 4

| Label | `_Hardness` | `_Sharpness` | Notes |
|-------|------------|-------------|-------|
| A1 | — | — | V4 baseline, no Kuwahara |
| A2 | 1 | 18 | Low hardness, high sharpness — smooth painterly regions |
| A3 | 9 | 9 | Balanced |
| A4 | 18 | 1 | High hardness, low sharpness — defined blocky regions |

**Note on relationship to Round 5:** Round 5 selects the kernel size. Round 6 tests hardness/sharpness at a fixed kernel size (to be confirmed as the Round 5 winner, or at a representative mid-range value if Round 5 winner is ambiguous).

---

## Round 7 — Hierarchical Depth Edge Detection (H1–H6)

**What it controls:** The hierarchical edge detection layer adds depth discontinuity edges on top of the V4 output. `_DepthThreshold` sets the minimum depth gradient required to draw a depth edge. `_DepthScale` amplifies the raw depth difference before thresholding. Lower threshold = more depth edges (catches more transitions but may produce noise). Higher threshold = fewer, cleaner depth edges (structural depth breaks only).

**Colour edges** are already handled by the V4 Sobel component and are not re-tested here.

**Normal edges** were excluded from this round because they are sensitive to camera angle: the same avatar looks different from different viewing angles. For a fixed-view ranking form, normal edge variation would be confounded with pose/angle, not parameter choice. Normal edges were evaluated through direct material inspection during development.

**Depth scale fixed at 2.** This value amplifies the raw device-depth differences to a useful range before thresholding. It was selected through development to produce stable depth edges on the avatar geometry at typical viewing distances.

**Images tested:** 6

| Label | `_DepthThreshold` |
|-------|------------------|
| H1 | *(fill in from rendered presets)* |
| H2 | *(fill in from rendered presets)* |
| H3 | *(fill in from rendered presets)* |
| H4 | *(fill in from rendered presets)* |
| H5 | *(fill in from rendered presets)* |
| H6 | *(fill in from rendered presets)* |

**Note:** H1–H6 threshold values are not currently stored in ShaderPresets.csv. Fill in the exact values used when generating the H images before finalizing this document.

---

## Parameter Carry-Forward Summary

This table shows which parameter value carries forward from each round into subsequent rounds.

| Round | Parameter tested | Carries forward as |
|-------|-----------------|-------------------|
| R1 | Inner line threshold | Fixed for R2 onward |
| R2 | Outline width + depth offset | Fixed for R3 onward |
| R3 | Shadow strength + detail bias | Fixed for R4 onward |
| R4 | Rim light on/off | Fixed for R5 onward |
| R5 | Kuwahara kernel size | Fixed for R6 |
| R6 | Kuwahara hardness/sharpness | Fixed for R7 (if Kuwahara is selected) |
| R7 | Depth threshold | Final parameter set for C3 condition |

The winner of Round 5 also determines whether Kuwahara is included in the final C3 configuration at all (K1 winning = no Kuwahara; K2–K4 winning = Kuwahara included with the winning kernel size).

---

## Notes for Thesis Writing

- The pre-study is mentioned in the Evaluation chapter, section on technique and parameter selection.
- Key framing: the pre-study determines which parameter values go into C3. This matters because C2 vs C3 is the critical comparison in the main study (same avatar, same animation, only NPR shader changes).
- The pre-study is separate from the main study and uses a small pilot group, not the full sample.
- Do not describe the pre-study as a "user study" in the thesis — use "parameter selection study" or "pilot rating study" to distinguish it from the main within-subjects study.
- Justifications for exclusions (no Gaussian blur round, no sector count round, no curvature mode, no normal edges in Round 7) are documented above and can be used directly in thesis text.
- The study is video-based; do not reference real-time rendering performance as a constraint in the evaluation chapter (CLAUDE.md rule: no VR performance literature).
