# Thesis Writing Instructions — Nidanur Günay

## Identity
- Student: Nidanur Günay (given: Nidanur, family: Günay)
- Email: nidanur.guenay@uni-konstanz.de
- University: University of Konstanz
- Department: Department of Computer and Information Science
- Degree: Master's Thesis
- Title: *Abstraction Mechanisms for Virtual Avatars*
- Supervisor (1st reviewer): Prof. Dr. Oliver Deussen
- Co-supervisor (2nd reviewer): Prof. Dr. Tiare Feuchtner
- Year: 2026

---

## File Locations
| What | Path |
|---|---|
| Thesis LaTeX root | `/Users/nidanurgunay/Desktop/Uni/Thesis/` |
| main.tex | `/Users/nidanurgunay/Desktop/Uni/Thesis/main.tex` |
| Chapters | `/Users/nidanurgunay/Desktop/Uni/Thesis/chapters/` |
| Frontmatter | `/Users/nidanurgunay/Desktop/Uni/Thesis/frontmatter/` |
| Figures | `/Users/nidanurgunay/Desktop/Uni/Thesis/figures/` |
| References | `/Users/nidanurgunay/Desktop/Uni/Thesis/references.bib` |
| Unity project (main) | `/Users/nidanurgunay/ThesisMetaAvatar/` |
| Unity project (experimental) | `/Users/nidanurgunay/Avatar_Shader_Experiemntal/` |
| Konstanz logo | `/Users/nidanurgunay/Desktop/Uni/Thesis/UniKonstanz_Logo_Minimum_sRGB.jpg` |
| Daniel Fink thesis (style ref) | `/Users/nidanurgunay/Desktop/Uni/Thesis/Daniel_Fink_Master_Thesis.pdf` |
| Project report (content ref) | `/Users/nidanurgunay/Desktop/Uni/Thesis/NidanurGunay_Project_Report.pdf` |

---

## Thesis Structure (chapters)
1. `01_introduction.tex` — **WRITTEN** (Motivation, Problem Statement, Contributions, Outline)
2. `02_related_work.tex` — placeholder
3. `03_background.tex` — placeholder
4. `04_methodology.tex` — placeholder
5. `05_implementation.tex` — placeholder
6. `06_evaluation.tex` — placeholder
7. `07_conclusion.tex` — placeholder

Frontmatter status:
- `titlepage.tex` — **DONE** (title, name, reviewers, logo, 2026)
- `abstract.tex` — **DONE** (English + German Zusammenfassung)
- `acknowledgements.tex` — **DONE** (Deussen + Feuchtner)
- `declaration.tex` — placeholder (needs real name + signature)

---

## Unity Project — ThesisMetaAvatar

### Platform
- Unity 6 (6000.0.60f1), Universal Render Pipeline (URP)
- Meta Avatars SDK v40.0.1
- Target device: Meta Quest (VR)

### How NPR is integrated
The Meta Avatars SDK uses a proprietary shader framework (ESF — Extensible Shader Framework). Custom NPR effects are injected via the `AppSpecificPostManipulation` function in:
- `Assets/Shaders/CustomShaders/app_specific/app_functions.hlsl`
- `Assets/Shaders/CustomShaders/app_specific/app_declarations.hlsl`
- `Assets/Shaders/CustomShaders/app_specific/app_variants.hlsl`

This post-lighting hook runs per-fragment after all SDK PBR lighting (SSS, eye glints, hair) is complete. It is the only integration point that does not break SDK skinning, LOD, or material management.

The main custom shader is:
- `Assets/Shaders/CustomShaders/Avatar-Meta-UGB.shader` — multi-pass shader with NPROutline pass + ForwardLit pass

The core NPR logic lives in:
- `Assets/Shaders/CustomShaders/Style2MetaAvatarCore.hlsl` — main dispatch, reads `_NPREffect` keyword to branch between techniques

### The 8 NPR Techniques (shader files)
| # | Name | File | Keyword |
|---|---|---|---|
| 1 | Geometry Outline (Inverted Hull) | `V1_ToonShading_GeometryOutline.shader` | (NPROutline pass) |
| 2 | Normal Edge Detection | `NPREffect_NormalEdge.cginc` | `EFFECT_NORMAL_EDGE` — no, wait: this is Derivative in UI |
| 3 | Sobel Edge Detection | `NPREffect_Sobel.cginc` | `EFFECT_SOBEL` |
| 4 | Gaussian Pre-filtered Sobel | `NPREffect_GaussianSobel.cginc` | `EFFECT_GAUSS_SOBEL` |
| 5 | Hierarchical Multi-Cue | `NPREffect_Hierarchical.cginc` | `EFFECT_HIERARCHICAL` |
| 6 | Kuwahara Painterly | `NPREffect_Kuwahara.cginc` | `EFFECT_KUWAHARA` |
| 7 | Kuwahara + Sobel | `NPREffect_KuwaharaSobel.cginc` | `EFFECT_KUWAHARA_SOBEL` |
| 8 | Kuwahara + Gauss + Hierarchical | `NPREffect_KuwaharaGaussHier.cginc` | `EFFECT_KUW_GAUSS_HIER` |

UI technique names (as shown in NPREdgeDetectionUI): Derivative, Sobel, Normal+Fresnel, Gauss Sobel, Hierarchical, Kuwahara, Kuwahara+Sobel, Kuw+Gauss+Hier

Also in `Assets/Shaders/NPR/`:
- `AnisotropicKuwahara.shader`, `AvatarMaskCapture.shader`, `HalftoneHatching.shader`
- `HierarchicalEdgeDetection.shader`, `SobelEdgeDetection.shader`, `XToon_2DRamp.shader`
- `Cel-Avatar-NPR-Sobel.shader`, `V2–V7` version shaders (iteration history)

### The 4 Custom C# Scripts
| Script | Purpose |
|---|---|
| `AvatarShaderSwapper.cs` | Waits for async avatar load, replaces all SDK materials with custom NPR shader. Handles LOD reversion via periodic re-apply coroutine. Copies base + normal textures from SDK materials. |
| `NPREdgeDetectionUI.cs` | Fully procedural in-VR WorldSpace panel. OVR controller raycasting via BoxCollider per row. Trigger-drag sliders, technique dropdown, live EnableKeyword/DisableKeyword switching. 8 technique sections, ~60+ tunable parameters. |
| `AvatarFreezeController.cs` | Freezes avatar body-tracking pose via reflection on `_inputTrackingProvider` field in OvrAvatarInputManager. Snapshot provider stores current state. A/X/Space to toggle. Used for evaluation screenshots. |
| `AvatarLabel.cs` | Floating billboard TMP label above avatar. Auto-faces camera in LateUpdate. |

---

## Thesis Content — Key Facts to Use When Writing

### The core problem
Photorealistic Meta avatars can trigger the uncanny valley. NPR abstraction can avoid this, but no prior work has applied fine-grained NPR stylization to a closed production SDK (Meta Avatars) AND measured how it affects trust perception.

### Research questions
- RQ1: Can NPR be integrated into the Meta Avatars SDK without breaking the pipeline?
- RQ2: Which NPR technique gives the best visual quality / performance trade-off for a user study?
- RQ3: How does abstraction level affect perceived trust in VR avatars?

### Iterative development narrative (for Implementation chapter)
The techniques were developed in `Avatar_Shader_Experiemntal` first, then ported to `ThesisMetaAvatar`. Each technique was motivated by a specific problem with the previous one:
- V1 (geometry outline): stable silhouette, but no interior detail
- V2 (normal edge / derivative): zero extra samples, catches creases, misses colour boundaries
- V3 (Sobel): catches colour edges, but UV seam spikes and skin over-edging — fixed with dual HSV saturation threshold + seam rejection
- V4 (Gaussian Sobel): pre-smoothing removes aliasing, 72 sample cost, still misses depth breaks
- V5 (Hierarchical): depth proxy + normal + Roberts Cross colour, AHEAD-inspired, best silhouette
- V6 (Kuwahara): painterly abstraction of texture, not edge-based, isotropic (single pass constraint)
- V7 (Kuwahara+Sobel): painterly fill + ink lines, comic-book aesthetic
- V8 (Kuwahara+Gauss+Hier): three-phase composite, most comprehensive, highest cost

### Key technical constraints
- No extra render passes allowed (Quest performance)
- SDK LOD switching reverts materials — solved by periodic re-apply coroutine in AvatarShaderSwapper
- UV seam artifacts in screen-space Sobel — solved by luminance range check (`_SeamRangeLimit`)
- Skin vs. clothing thresholding — solved by HSV saturation cutoff (`_SkinSaturationCutoff`)
- Isotropic Kuwahara only (anisotropic needs structure tensor = separate render texture pass, not possible in fragment hook)

### Reference articles (in `/Users/nidanurgunay/Desktop/Uni/VR Avatar Project/Articles/`)
- `uncanny1970.pdf` — Mori, Uncanny Valley (1970)
- `Gooch1998.pdf` — Gooch et al., NPR lighting model for technical illustration
- `x-toon.pdf` — X-Toon extended toon shading
- `anisotropic_kuwahara.pdf` — Anisotropic Kuwahara filter
- `Adaptive Hierarchical Edge Detection.pdf` — AHEAD paper (basis for V5)
- `hatching.pdf` — Hatching NPR
- `Introduction to 3D Non-Photorealistic Rendering- Silhouettes and Outlines.pdf`
- `Gonzales,Woods-Digital.Image.Processing.4th.Edition.pdf` — Sobel, Gaussian math
- `Nowak2003.pdf` — Avatar trust / social presence
- `Weidner2023.pdf` — VR avatar perception
- `MacDorman2006AndroidScience.pdf` — Uncanny valley in androids
- `Isenberg_2003_ADG.pdf` — NPR for characters
- `Effects of Realism and Representation on Self-Embodied Avatars in Immersive Virtual Environments.pdf`

### Citation keys in references.bib (so far)
`mori1970`, `nowak2003`, `gooch1998`, `weidner2023`
Still to add: AHEAD, X-Toon, Kuwahara, Isenberg, MacDorman, Gonzalez-Woods, Lake et al. (inverted hull), Nowak+Biocca

---

## LaTeX Conventions
- Compile: `pdflatex -interaction=nonstopmode main.tex` (run from thesis root)
- Full bibliography rebuild: `pdflatex` → `biber main` → `pdflatex` → `pdflatex`
- Logo: `\includegraphics[width=0.35\textwidth]{UniKonstanz_Logo_Minimum_sRGB}` (root dir, no figures/ prefix)
- Font: Palatino body (`mathpazo`) + Helvetica headings (`helvet 0.90`)
- Line spacing: `\setstretch{1.15}`
- Chapter headings: `\sffamily` (sans-serif, no bold) — matches Daniel Fink style
- Render pages to verify: `pdftoppm -r 150 main.pdf /tmp/page && sips -s format jpeg ...`

---

## Working Style
- Nidanur writes casually and with typos — this is normal, not confusion
- Always act directly: edit files, compile, verify. Do not just report findings
- When writing thesis text, write it — don't ask first unless genuinely ambiguous
- Use project report (`NidanurGunay_Project_Report.pdf`) sentences as base for similar sections, then expand for thesis depth
