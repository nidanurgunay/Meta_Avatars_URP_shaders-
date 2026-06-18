# CLAUDE.md — ThesisMetaAvatar Workspace Instructions

These are permanent instructions for this workspace. Follow them exactly in every session.

---

## 1. Identity

| Field | Value |
|---|---|
| Student | Nidanur Günay (given: Nidanur, family: Günay) |
| Email | nidanur.guenay@uni-konstanz.de |
| University | University of Konstanz |
| Department | Department of Computer and Information Science |
| Degree | Master's Thesis |
| Title | *Abstraction Mechanisms for Virtual Avatars* |
| Supervisor (1st reviewer) | Prof. Dr. Oliver Deussen |
| Co-supervisor (2nd reviewer) | Prof. Dr. Tiare Feuchtner |
| Year | 2026 |

---

## 2. Project Overview

This workspace has two parts:

1. **Master's thesis** — written in LaTeX, located in `thesis/`
2. **Unity VR project** — NPR (non-photorealistic rendering) techniques applied to three avatars: Meta Avatar, Avaturn, and Jody (Mixamo character)

The Mixamo avatar (character name: **Jody**) and its related scenes live in a self-contained sub-project at `Assets/AvatarShaderExperimental/`. The folder is named "Jade" internally but the character name in all thesis text is **Jody**.

---

## 3. Folder Paths and Structure

### 3.1 Thesis (LaTeX)

| What | Path |
|---|---|
| LaTeX root | `thesis/` |
| main.tex | `thesis/main.tex` |
| Chapters | `thesis/chapters/` |
| Frontmatter | `thesis/frontmatter/` |
| Figures | `thesis/figures/` |
| Bibliography | `thesis/references.bib` |
| Citation source log | `thesis/citation_sources.md` |
| Konstanz logo | `thesis/UniKonstanz_Logo_Minimum_sRGB.jpg` |
| Style reference | `thesis/Daniel_Fink_Master_Thesis.pdf` |
| Content reference | `thesis/NidanurGunay_Project_Report.pdf` |

### Thesis chapter status

| File | Status |
|---|---|
| `01_introduction.tex` | WRITTEN — Motivation, Problem Statement, Contributions, Outline |
| `02_related_work.tex` | In progress |
| `03_background.tex` | Placeholder |
| `04_methodology.tex` | In progress |
| `05_implementation.tex` | Placeholder |
| `06_evaluation.tex` | Placeholder |
| `07_conclusion.tex` | Placeholder |

Frontmatter: `titlepage.tex`, `abstract.tex`, `acknowledgements.tex` are DONE. `declaration.tex` needs real name and signature.

---

### 3.2 Unity Project — Platform and Pipeline

- **Engine:** Unity 6 (6000.0.60f1), Universal Render Pipeline (URP)
- **SDK:** Meta Avatars SDK v40.0.1
- **Target device:** Meta Quest (VR)

---

### 3.3 Meta Avatar Shaders

| What | Path |
|---|---|
| Shader directory | `Assets/Shaders/MetaAvatarShaders/` |
| SDK integration hook | `Assets/Shaders/MetaAvatarShaders/app_specific/app_functions.hlsl` |
| SDK declarations | `Assets/Shaders/MetaAvatarShaders/app_specific/app_declarations.hlsl` |
| SDK variants | `Assets/Shaders/MetaAvatarShaders/app_specific/app_variants.hlsl` |
| Main shader | `Assets/Shaders/MetaAvatarShaders/Avatar-Meta-UGB.shader` |
| Core NPR dispatch | `Assets/Shaders/MetaAvatarShaders/Style2MetaAvatarCore.hlsl` |

NPR technique includes (all in `Assets/Shaders/MetaAvatarShaders/`):

| # | Technique | File | Keyword |
|---|---|---|---|
| 1 | Toon Shading | `NPREffect_Toon.cginc` | `EFFECT_TOON` |
| 2 | Normal Edge Detection | `NPREffect_NormalEdge.cginc` | `EFFECT_NORMAL_EDGE` |
| 3 | Sobel Edge Detection | `NPREffect_Sobel.cginc` | `EFFECT_SOBEL` |
| 4 | Gaussian Pre-filtered Sobel | `NPREffect_GaussianSobel.cginc` | `EFFECT_GAUSS_SOBEL` |
| 5 | Hierarchical Multi-Cue | `NPREffect_Hierarchical.cginc` | `EFFECT_HIERARCHICAL` |
| 6 | Kuwahara Painterly | `NPREffect_Kuwahara2.cginc` | `EFFECT_KUWAHARA` |
| 7 | Kuwahara + Sobel | `NPREffect_Kuwahara2Sobel.cginc` | `EFFECT_KUWAHARA_SOBEL` |
| 8 | Kuwahara + Gauss + Hierarchical | `NPREffect_Kuwahara2GaussHier.cginc` | `EFFECT_KUW_GAUSS_HIER` |

Integration point: `AppSpecificPostManipulation` function — runs per-fragment after all SDK PBR lighting. This is the only hook that does not break SDK skinning, LOD, or material management.

C# scripts for Meta Avatar:

| Script | Path | Purpose |
|---|---|---|
| AvatarShaderSwapper.cs | `Assets/Scripts/` | Replaces SDK materials with NPR shader after async load; handles LOD reversion via re-apply coroutine |
| NPREdgeDetectionUI.cs | `Assets/Scripts/` | In-VR WorldSpace UI panel; OVR controller raycasting; live technique switching |
| AvatarFreezeController.cs | `Assets/Scripts/` | Freezes avatar pose for evaluation screenshots |
| AvatarLabel.cs | `Assets/Scripts/` | Floating billboard TMP label above avatar |

---

### 3.4 Avaturn Avatar Shaders

| What | Path |
|---|---|
| Shader directory | `Assets/Shaders/AvaturnNPRShaders/` |
| SDK integration hook | `Assets/Shaders/AvaturnNPRShaders/app_specific/` |
| Materials | `Assets/Materials/NPR Avaturn Materials/` |

Avaturn shader versions in `Assets/Shaders/AvaturnNPRShaders/`:

| File | Description |
|---|---|
| `V1_ToonShading_GeometryOutline.shader` | Inverted hull outline + toon bands |
| `V2_NormalEdgeDetection.shader` | Screen-space normal derivatives |
| `V3_SobelEdgeDetection.shader` | Sobel colour edges |
| `V4_GaussianPreFilteredSobel.shader` | Gaussian pre-smoothing + Sobel |
| `V5_HierarchicalGaussian.shader` | Depth + normal + Roberts Cross |
| `V6_ChromaticEdge.shader` | Chromatic edge |
| `V8_QuantizedSobel.shader` | Quantized Sobel |
| `AnisotropicKuwahara.shader` | Kuwahara painterly filter |
| `XToon_2DRamp.shader` | XToon 2D ramp abstraction |
| `SobelEdgeDetection.shader` | Standalone Sobel |
| `HierarchicalEdgeDetection.shader` | Standalone hierarchical |
| `Cel-Avatar-NPR-Sobel.shader` | Cel + Sobel combination |

Normal-map decoding for Avaturn GLB: use `sample.rgb * 2.0 - 1.0`. Never use `UnpackNormalScale`. GLTFast bypasses the Unity importer, so DXT5nm decoding causes a grey artifact.

---

### 3.5 Jody (Mixamo) Avatar — AvatarShaderExperimental

This is a separate self-contained sub-project. All Jody-related assets live here.

| What | Path |
|---|---|
| Sub-project root | `Assets/AvatarShaderExperimental/` |
| Shader directory | `Assets/AvatarShaderExperimental/Shaders/` |
| Materials | `Assets/AvatarShaderExperimental/Materials/` |
| Scenes | `Assets/AvatarShaderExperimental/Scenes/` |
| Scripts | `Assets/AvatarShaderExperimental/Scripts/` |
| Characters | `Assets/AvatarShaderExperimental/Characters/` |
| Animations | `Assets/AvatarShaderExperimental/Animations/` |

Key scenes: `Project Scene.unity` is the main Jody scene. `Kuwahara and hieararchical.unity` contains painterly filter tests.

Jody shader files in `Assets/AvatarShaderExperimental/Shaders/`:

| File | Description |
|---|---|
| `V1_ToonShading_GeometryOutline.shader` | Inverted hull |
| `V2_NormalEdgeDetection.shader` | Normal edge |
| `V3_SobelEdgeDetection.shader` | Sobel |
| `V4_GaussianPreFilteredSobel.shader` | Gaussian Sobel |
| `V5_HierarchicalGaussian.shader` | Hierarchical |
| `XToon_2DRamp.shader` | XToon |
| `AnisotropicKuwahara.shader` | Kuwahara |
| `HierarchicalEdgeDetection.shader` | Hierarchical standalone |
| `SobelEdgeDetection.shader` | Sobel standalone |

Mixamo animation import setting: use **Feet** rig + level **-0.5** in the FBX import settings. Without this the animation sinks below the ground plane.

---

### 3.6 Common and Jade NPR Shaders

| What | Path |
|---|---|
| Shared shaders | `Assets/Shaders/CommonNPRShaders/` |
| Jade shaders | `Assets/Shaders/JadeNPRShaders/` |

`CommonNPRShaders` contains: `AvatarMaskCapture.shader`, `HalftoneHatching.shader`, `OvrVertexFetchBridge.hlsl`, `V1_InvertedHullOutline.shader`.

---

### 3.7 Face Animation — Live Link Face (ARKit)

Avatar face animation is driven by **Live Link Face**, an iPhone app by Epic Games that streams ARKit blendshape data (52 face coefficients) over the local network via UDP.

| Detail | Value |
|---|---|
| App | Live Link Face (Epic Games, free on App Store) |
| Protocol | UDP broadcast on local network |
| Source | iPhone camera (ARKit TrueDepth / face tracking) |
| Receiver | Unity plugin listening on the same subnet |

**Why it does not work on eduroam:** eduroam enforces client isolation — devices on the same eduroam Wi-Fi cannot communicate peer to peer. The iPhone and the Unity laptop cannot see each other, so the UDP stream never arrives and the avatar face stays unanimated.

**Workaround:** use a personal phone hotspot (iPhone or Android) and connect both the laptop and the iPhone running Live Link Face to that hotspot. This creates a private subnet with no client isolation. Alternatively, a dedicated router or a home network both work. The university VPN does not help because it does not bridge the eduroam subnet.

---

## 4. Thesis Writing Style and LaTeX Conventions

### 4.1 LaTeX Compile Steps

Quick compile (no bibliography changes):
```
pdflatex -interaction=nonstopmode main.tex
```

Full rebuild (after adding or changing citations):
```
pdflatex -interaction=nonstopmode main.tex
biber main
pdflatex -interaction=nonstopmode main.tex
pdflatex -interaction=nonstopmode main.tex
```

Always run from `thesis/`. Always compile after any change to `.tex` or `.bib` files. Verify by rendering page 1:
```
pdftoppm -r 150 main.pdf /tmp/page && sips -s format jpeg /tmp/page-1.ppm --out /tmp/page1.jpg
```

### 4.2 LaTeX Formatting

- Font: Palatino body (`mathpazo`) + Helvetica headings (`helvet 0.90`)
- Line spacing: `\setstretch{1.15}`
- Chapter headings: `\sffamily` (sans-serif, no bold) — matches Daniel Fink style
- Logo: `\includegraphics[width=0.35\textwidth]{UniKonstanz_Logo_Minimum_sRGB}` (root dir, no `figures/` prefix)

### 4.3 Working Style

- Nidanur writes casually and with typos. This is normal.
- Always act directly: edit files, compile, verify. Do not just report findings or ask first unless genuinely ambiguous.
- When writing thesis text, write it immediately in the file — professional, academic English — regardless of how casually the prompt was phrased.
- Before writing any thesis section, read the relevant section of `NidanurGunay_Project_Report.pdf` first. Extract content and citation numbers from it. Verify bib keys match.

### 4.4 Language and Style Rules

**No Fresnel in the thesis.** The Fresnel effect was removed from the design. Do not mention it.

**STRICT RULE — No hyphenated compound words.** Hyphenated words are a strong signal of AI-generated text. Write without them. Rewrite any phrase that would naturally use a hyphen.

| Instead of | Write |
|---|---|
| real-time rendering | real time rendering |
| high-quality output | high quality output |
| non-photorealistic | nonphotorealistic (or restructure the sentence) |
| post-processing | post processing |
| screen-space effects | screen space effects |
| edge-detection algorithm | edge detection algorithm |
| per-fragment computation | per fragment computation |

Keep the language as natural and human as possible. Write in a clear academic register without AI-signature phrasing.

**No em-dashes.** Em-dashes look AI-generated. Use commas, colons, or semicolons instead.

---

## 5. Citation Guidelines

### 5.1 Placement Rules

1. **One sentence, one citation.** Never place two citations for the same claim back to back. If two papers support the same sentence, combine them: `\cite{a,b}`.

2. **Name the author or concept before citing.** Write what the cited work contributed, then cite. "Barla et al. term this Normal Field Abstraction~\cite{barla2006}" is correct. A bare `~\cite{barla2006}` at the end of a sentence that never names Barla is not.

3. **No citations inside `lstlisting` captions.** Move any citation to the prose paragraph that explains the listing.

4. **Each citation must directly support the claim it is attached to.** Do not attach a citation just because the paper is broadly relevant.

5. **Verify placement before finalising every section.** Check every paragraph. The citation must be on the exact sentence making the claim.

### 5.2 When to Cite

| Situation | Action |
|---|---|
| Named NPR technique (Sobel, Kuwahara, XToon, …) | Cite the original paper on first use |
| Mathematical formula from a specific paper | Cite that paper next to the formula |
| Standard textbook knowledge (Lambert NdotL, basic HLSL) | No citation needed |
| Limitation of a class of techniques | Cite survey or foundational paper |
| Claim about human perception, trust, or embodiment | Cite user study or perceptual study directly |
| Implementation detail grounded in project code | No citation — ground in code file or shader |
| Observed artefact or empirical tuning result | No citation — describe as empirical observation |

### 5.3 Paper to Claim Mapping

| Claim | Key in `references.bib` |
|---|---|
| Toon / cel shading, real time bands | `lake2000` |
| Nonphotorealistic lighting replaces smooth gradients | `gooch1998` |
| Silhouette algorithms, geometry-only edge limits | `isenberg2003` |
| XToon 2D ramp, Normal Field Abstraction, abstraction axis | `barla2006` |
| Blinn-Phong specular model | `blinn1977` |
| Schlick Fresnel approximation | `schlick1994` |
| Sobel / gradient operators, BT.601 luma coefficients | `gonzalez2018` |
| Canny: smoothing before differentiation | `canny1986` |
| Marr-Hildreth: LoG / Gaussian prior to edge detection | `marr1980` |
| Anisotropic Kuwahara filter | `kyprianidis2009` |
| Hatching / tonal art maps | `praun2001` |
| Uncanny valley | `mori1970` |
| Avatar realism and trust | `canales2024`, `latoschik2017` |
| Social presence, copresence, embodiment | `nowak2003`, `yee2007` |
| Godspeed questionnaire | `macdorman2006` |
| Roberts Cross operator | `gonzalez2018` |

### 5.4 Citation Source Log — MANDATORY

Every new citation added to `references.bib` must be logged in `thesis/citation_sources.md`.

Each log entry must include:

- The section and sentence where the citation is used
- The DOI
- Full bibliographic details (author, title, journal/conference, year, volume, pages)
- A detailed summary of what the article argues or demonstrates
- Any methodology or technique in the article that is relevant to this thesis

Do not skip this log even for well-known sources. The log is used for pre-submission verification.

---

## 6. Section Ownership — Methodology vs Implementation

This separation is strict. Cross-contamination is a writing error.

| Content type | Correct section |
|---|---|
| Why this technique was chosen | Methodology |
| What problem a technique solves | Methodology |
| Conceptual algorithm description | Methodology |
| Design rationale | Methodology |
| Mathematical principles and formulas | Methodology |
| "This motivates V_N" transition sentences | Methodology |
| Shader file names | Implementation |
| Unity hook names and API calls | Implementation |
| HLSL function signatures | Implementation |
| Unity material and platform integration | Implementation |
| Parameter tuning values | Implementation |
| Empirical observations from development | Implementation |

**Never** put shader hook names, API call signatures, or material slot names in the Methodology chapter.

**Never** put conceptual motivation sentences ("this approach solves X") in the Implementation chapter. They belong in Methodology.

---

## 7. Documentation and Learning Rules

### 7.1 NPR Shader Documentation

After every shader change, update `NPR_Technical_Documentation.md` in the project root. This is mandatory, not optional.

The update must reflect: what changed, which shader file, what problem it solved or what effect it produces, and any parameter values that were tuned.

### 7.2 Study Notes

Update `UNITY_STUDY_NOTES.md` in the project root whenever a session hits an important learning point or code milestone. Examples: a new Unity lifecycle method is used, a rendering concept is applied for the first time, a shader bug is diagnosed and fixed, a new API or SDK pattern is introduced.

Each entry should include: the date, a short title, and a plain-English explanation of what was learned and why it matters.

---

## 8. Key Technical Facts for Thesis Writing

### The core problem

Photorealistic Meta Avatars can trigger the uncanny valley. NPR abstraction can avoid this, but no prior work has applied fine-grained NPR stylisation to a closed production SDK (Meta Avatars SDK) and measured how it affects trust perception.

### Research questions

- RQ1: Can NPR be integrated into the Meta Avatars SDK without breaking the pipeline?
- RQ2: Which NPR technique gives the best visual quality and performance trade-off for a user study?
- RQ3: How does abstraction level affect perceived trust in VR avatars?

### Iterative development narrative (for Implementation chapter)

The techniques were developed in `Assets/AvatarShaderExperimental/` first, then ported to the Meta Avatar pipeline. Each technique was motivated by a specific limitation of the previous one:

- V1 (geometry outline): stable silhouette, but no interior detail
- V2 (normal edge / derivative): zero extra samples, catches creases, misses colour boundaries
- V3 (Sobel): catches colour edges, but UV seam spikes and skin over-edging — fixed with dual HSV saturation threshold and seam rejection
- V4 (Gaussian Sobel): pre-smoothing removes aliasing, 72 sample cost, still misses depth breaks
- V5 (Hierarchical): depth proxy + normal + Roberts Cross colour, AHEAD-inspired, best silhouette
- V6 (Kuwahara): painterly abstraction of texture, not edge-based, isotropic (single pass constraint)
- V7 (Kuwahara + Sobel): painterly fill and ink lines, comic-book aesthetic
- V8 (Kuwahara + Gauss + Hier): three-phase composite, most comprehensive, highest cost

### Key technical constraints

- No extra render passes allowed (Quest performance budget)
- SDK LOD switching reverts materials — solved by periodic re-apply coroutine in AvatarShaderSwapper
- UV seam artifacts in screen-space Sobel — solved by luminance range check (`_SeamRangeLimit`)
- Skin vs clothing thresholding — solved by HSV saturation cutoff (`_SkinSaturationCutoff`)
- Isotropic Kuwahara only — anisotropic requires structure tensor and a separate render texture pass, which is not possible in the fragment hook

### Citation keys confirmed in references.bib

`mori1970`, `nowak2003`, `gooch1998`, `weidner2023`, `schlick1994`

Still to add: AHEAD, XToon (barla2006), Kuwahara (kyprianidis2009), Isenberg (isenberg2003), MacDorman (macdorman2006), Gonzalez-Woods (gonzalez2018), Lake et al. (lake2000), Nowak and Biocca

---

## 10. User Study Design

### 10.1 Study Parameters

| Parameter | Value |
|---|---|
| Modality | Video only — no VR headset, no real time interaction |
| Design | Within subjects (all participants see all three conditions) |
| Conditions | 3 (see below) |

### 10.2 Study Conditions

| # | Label | Description |
|---|---|---|
| C1 | Real | Video recording of a real person (ground truth baseline) |
| C2 | Avaturn Realistic | Video of an Avaturn avatar rendered photorealistically, no NPR |
| C3 | Avaturn NPR | Video of the same Avaturn avatar rendered with the selected NPR shader pipeline |

The avatar platform is held constant between C2 and C3. This isolates the perceptual effect of NPR stylisation from any platform variation. The Meta Avatars SDK work is the technical contribution; the user study evaluates the stylisation effect using the Avaturn avatar.

### 10.3 STRICT RULE — No Real Time VR Performance Literature

**The study is video based. It does not involve a VR headset, real time rendering, or Quest hardware.**

Do not cite, reference, or use as motivation any literature about:

- Real time VR rendering performance or throughput
- Quest hardware budgets, frame rate constraints, or latency targets
- VR presence requirements tied to rendering speed or frame pacing

This rule applies to the Related Work chapter, Methodology chapter, and Evaluation chapter. The single pass fragment hook constraint in the NPR shader pipeline is a Unity and SDK engineering fact; it must not be framed as a user study requirement or cited alongside perceptual or trust literature.

---

## 9. Reference Articles

Physical PDFs in `/Users/nidanurgunay/Desktop/Uni/VR Avatar Project/Articles/`:

| File | Content |
|---|---|
| `uncanny1970.pdf` | Mori, Uncanny Valley (1970) |
| `Gooch1998.pdf` | Gooch et al., NPR lighting model |
| `x-toon.pdf` | X-Toon extended toon shading |
| `anisotropic_kuwahara.pdf` | Anisotropic Kuwahara filter |
| `Adaptive Hierarchical Edge Detection.pdf` | AHEAD paper (basis for V5) |
| `hatching.pdf` | Hatching NPR |
| `Introduction to 3D Non-Photorealistic Rendering- Silhouettes and Outlines.pdf` | Silhouette and outline survey |
| `Gonzales,Woods-Digital.Image.Processing.4th.Edition.pdf` | Sobel, Gaussian, Roberts Cross math |
| `Nowak2003.pdf` | Avatar trust and social presence |
| `Weidner2023.pdf` | VR avatar perception |
| `MacDorman2006AndroidScience.pdf` | Uncanny valley in androids |
| `Isenberg_2003_ADG.pdf` | NPR for characters |
| `Effects of Realism and Representation on Self-Embodied Avatars in Immersive Virtual Environments.pdf` | Avatar self-embodiment study |
