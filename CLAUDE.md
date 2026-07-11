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

**STRICT RULE — No hyphenated compound words.** Hyphenated words are a strong signal of AI-generated text. Write without them. Rewrite any phrase that would naturally use a hyphen. Use a hyphen only when it is grammatically required, for example in standard prefix compounds where omitting it would create an ambiguous or unreadable word. Never use one simply to join a compound adjective.

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

**Academic register — human-written tone.** Use formal vocabulary and precise causal connectors, but keep the prose natural. Specific rules:

- Prefer `given that` or `since` over `because` when opening a causal clause mid-sentence
- Prefer `meaning that` or `consequently` over `so` for causal conclusions
- Prefer `progressing to` or `undertaking` over weak passive constructions such as `are addressed`
- Active voice for decisions and findings; passive only for established technical processes (`was implemented`, `were computed`)
- Avoid over-formal constructions: never use `owing to the fact that`, `it is evident that`, `it should be noted that`, or `it can be seen that`
- Every sentence should read as if a careful human writer produced it without assistance

**Sentence linking and cohesion — MANDATORY.** Academic paragraphs must form a logical chain, not a list of isolated sentences. Every sentence must connect explicitly to the one before it through at least one of the following devices:

- **Thematic pickup:** open the new sentence by repeating or echoing a key noun or concept from the end of the previous sentence. Example: "…rendering internally." → "This internal rendering architecture, however, prevents…"
- **Pronoun reference:** use "It," "This," "These," or "They" to carry the subject forward when the referent is unambiguous. Example: "…cannot be added." → "It must instead be injected…"
- **Pivot connectors:** use "however," "consequently," "furthermore," or "nonetheless" when the sentence contrasts with or builds on the previous one.
- **Never open a sentence with a subject that has not been mentioned or clearly implied in the preceding sentence.** This is the most common violation: jumping to a new topic without a bridge word or lexical echo.

Before finalising any paragraph, read it aloud and check that each sentence picks up a thread from the one before it.

**Tense consistency — MANDATORY.** Use tense deliberately and consistently across all chapters:

- **Present tense** for platform and tool descriptions (what they are, what they do), established facts, general truths, and what the thesis contains ("Chapter 4 describes…").
- **Past tense** for completed project actions, development decisions, and the user study ("Nine techniques were developed…", "The study was conducted…").
- **Citation tense rule:** past tense for the act of research ("Lake et al. showed…"), present tense for the finding or ongoing truth ("…that this approach scales well").
- **Never mix tenses within a single sentence** unless the two clauses genuinely refer to different time periods.
- Before finalising any section, scan every sentence for present/past mixing. A sentence that contains both a present and a past verb requires explicit justification.

**No same-root repetition across adjacent sentences.** If a word or its root appears in one sentence, do not use the same root in the immediately following sentence. This is a common pattern in AI-generated text. Rewrite one occurrence with a synonym or restructure the sentence. Example: "techniques presented in this thesis. Each platform presents…" violates this rule; fix by changing one to "described" or "offers."

**No repeated phrases across adjacent sentences.** Beyond word roots, avoid repeating the same multi-word phrase in consecutive sentences. Rephrase one occurrence using a synonym construction. Example: "without requiring" appearing in two consecutive sentences must be varied — rewrite one as "eliminating the need for" or "independent of."

**No em-dashes.** Em-dashes look AI-generated. Use commas, colons, or semicolons instead.

**Minimise semicolons.** Eliminate semicolons wherever possible without introducing a grammatical error. Prefer splitting into two sentences, or using a comma with a conjunction. Semicolons are only acceptable to separate items in a complex list or when the conjunction "therefore" or "however" follows immediately (e.g., "...; therefore, ..."). Never use a semicolon simply to join two independent clauses that could stand as separate sentences.

---

### 4.5 Project Report Prose Style — Reference Patterns

`NidanurGunay_Project_Report.pdf` is the canonical writing style reference for related work and methodology prose. Before writing any section, identify the matching paragraph type below and apply the same construction.

**Attribution pattern.** Name the authors first, then the verb, then the finding, then the citation. Never open with the paper title.
- Correct: "Lake et al. showed that this strategy is well suited for real-time animation~\cite{lake2000}."
- Avoid: "In [10], it was shown that..."

**Connector words per paragraph role:**
- `Furthermore,` — adds a new positive point that builds on the previous one
- `However,` — pivots to a limitation or counterpoint
- `This` / `This observation` / `This led to` — connects a finding to its implication or the next technique
- `A later broader survey by` — introduces follow-on or survey work

**Logical chain structure — driven by limitations, not chronology.**
Each paragraph follows: established fact → limitation of that approach → next technique that addresses it. The narrative arc is always "this works, but fails here, which motivates the next step."

**Implication sentence.** After stating a finding, one sentence draws the implication for the current work. Examples from the report: "This observation motivated the exploration of additional edge detection techniques in subsequent versions." / "Thus, these geometric methods are not capable of identifying structural boundaries and cannot convey internal surface details."

**Technical term introduction pattern.** On first use: "[term], [brief role definition], [what it does in this context]." Example: "The Sobel operator, a discrete differentiation tool widely utilized in computer vision and NPR to approximate image intensity gradients."

**Sentence-level rules:**
- Active voice for findings: "Lake et al. showed...", "Marr and Hildreth observed..."
- Passive voice for technical processes: "was implemented", "were computed", "is applied"
- One finding per sentence; no restating what was just said
- No structural announcements ("In this section, we discuss..."); just present the content directly

---

### 4.6 Academic Writing Style Guide

**Primary objective:** maximise clarity, precision, logical flow, technical accuracy, readability, and consistency. Every edit must improve at least one of these. Do not rewrite for the sake of rewriting.

**Clarity over complexity.** Prefer the clearest possible sentence. Never replace simple words with more sophisticated ones unless they improve precision. Write for readers familiar with the field but not with the specific implementation.

**Preserve meaning.** Never change technical meaning, introduce new assumptions, exaggerate claims, omit implementation details, or oversimplify technical explanations.

**Precision.** Use precise technical terminology. Replace vague expressions with specific ones:

- shader logic → shader implementation
- works well → performs effectively
- good quality → high fidelity
- thing → component

**Paragraph structure.** Each paragraph should: (1) open with a topic sentence, (2) provide supporting technical details, (3) give evidence or explanation, (4) close with a sentence explaining significance. One central idea per paragraph.

**Sentence construction.** Prefer active voice unless passive improves clarity. Avoid unnecessarily long sentences. Split when readability improves. Vary length naturally. Maintain parallel structure when comparing multiple systems, algorithms, or platforms.

**Academic tone — words to avoid:**

- obviously, clearly, simply, basically, really, very, huge, amazing, perfect, excellent, incredible, easy, nice
- It is worth noting that… / It should be emphasized that… / In today's rapidly evolving…
- robust, comprehensive, novel, leverages, utilizes, seamlessly, state-of-the-art (unless factually justified)

**Preferred objective verbs:** enables, provides, supports, facilitates, demonstrates, indicates, suggests, results in, improves, reduces, increases, requires, constrains.

**Evidence-based writing.** Do not make unsupported claims. Qualify statements appropriately ("This method can improve…" not "This method improves…"). Distinguish clearly between facts, observations, interpretations, and assumptions.

**Conciseness.** Every sentence must contribute new information. Remove redundant phrases, unnecessary adjectives, filler words, and repeated ideas.

**Revision checklist before finalising any paragraph:**

- Topic sentence is clear
- Every sentence adds new information
- No redundant words remain
- Technical terminology is consistent
- Comparisons are parallel
- Claims are appropriately qualified
- The final sentence explains why the discussion is relevant
- Reads as though written by an experienced researcher, not an AI

Target style: papers published in ACM TOG, IEEE VR, IEEE TVCG, CHI, and Eurographics.

---

## 5. Citation Guidelines

### 5.0 No-Hallucination Rule — MANDATORY

**Never fabricate or guess any bibliographic field.** Before adding or editing a `references.bib` entry, every field must be verified against the actual source.

- For academic papers: verify author names, title, venue/journal, year, and page numbers from the source PDF. Do not invent DOIs or page numbers.
- For web services and software (e.g. `@misc` entries): add a `howpublished` URL only if you can confirm it. Do not guess URLs.
- If a field cannot be confirmed, leave it out and flag it with a `TODO` comment in the note field rather than filling it in with a guess.
- Do not expand abbreviations or acronyms (e.g. SDK internal system names) from sources that are not publicly accessible. If the only source is an internal corporate document or inaccessible wiki, describe the system by its observable behaviour instead.

### 5.1 Placement Rules

1. **One sentence, one citation.** Never place two citations for the same claim back to back. If two papers support the same sentence, combine them: `\cite{a,b}`.

2. **Citations always appear at the end of the sentence.** Place the citation immediately before the full stop, not mid-sentence after the named concept. "Lake et al. establish that this approach is well-suited for real-time animation~\cite{lake2000}." is correct. "Lake et al.~\cite{lake2000} establish that..." is not. The author or concept must still be named somewhere in the sentence body; a bare `~\cite{barla2006}` with no mention of Barla anywhere in the sentence is equally incorrect.

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

**MANDATORY — Check the original PDF before attributing any claim.** Article summaries can paraphrase or omit nuance. Before writing any sentence that attributes a specific finding or argument to an author, read the relevant passage in the original PDF. The summaries are a starting point; the original source is authoritative. If a claim cannot be found in the original PDF, do not attribute it to that author.

**Physical article PDFs are stored at:** `/Users/nidanurgunay/Desktop/Uni/VR Avatar Project/Articles/`

This folder contains subfolders by topic (e.g. `trust/`, `NPR/`). Always look here first for the original source before relying solely on `article_summaries.tex`.

**Article Summaries PDF:** `article_summaries.pdf` in the project root contains detailed summaries of all articles used in the thesis. It is compiled from `article_summaries.tex` in the same location. Before writing any section that cites these articles, read the relevant entry in that PDF — it contains full bibliographic details, DOI, methodology notes, and relevance statements. The PDF is organised into three sections:

- **Section 1 — Uncanny Valley:** MacDorman & Ishiguro (2006), Ho & MacDorman (2010), Mori (1970), McDonnell et al. (2012), Seymour et al. (2021)
- **Section 2 — User Study / Trust and Avatar Perception:** McKnight & Chervany (2001), Mayer et al. (1995), Bartneck et al. (2009), Canales et al. (2024), Alipour et al. (2025), Nowak & Biocca (2003), Nowak & Rauh (2005), Weidner et al. (2023), Kuffner dos Anjos & Pereira (2024), Alimardani et al. (2024), Dubosc et al. (2025), Tao et al. (2025), Cihodaru-Ştefanache & Podina (2025)
- **Section 3 — NPR / Nonphotorealistic Rendering:** Gooch et al. (1998), Lake et al. (2000), Isenberg et al. (2003), Gonzalez & Woods (2018), Marr & Hildreth (1980), Canny (1986), Barla et al. (2006), Kyprianidis et al. (2009), Praun et al. (2001), Roberts (1963), Kumar & Poornima (2019), Wisessing et al. (2016), Wisessing et al. (2020), Petikam et al. (2021), Riefard et al. (2024), Roshaan (2026/AHEAD)

### 9.1 Article Summary Slide Decks — MANDATORY UPDATE RULE

Three Beamer slide-deck files exist in the project root, one per section of `article_summaries.pdf`. Every article that has an entry in `article_summaries.pdf` must also have a corresponding slide in the appropriate deck. **When a new article summary is added to `article_summaries.pdf` or `article_summaries.tex`, a matching slide must be added to the correct deck file and the PDF recompiled.**

| Category | LaTeX source | Compiled PDF | Pages | Compile command |
| --- | --- | --- | --- | --- |
| Uncanny Valley | `Slides_UncannyValley.tex` | `Slides_UncannyValley.pdf` | 6 | `pdflatex -interaction=nonstopmode Slides_UncannyValley.tex` |
| User Study / Trust | `Slides_UserStudy.tex` | `Slides_UserStudy.pdf` | 16 | `pdflatex -interaction=nonstopmode Slides_UserStudy.tex` |
| NPR | `Slides_NPR.tex` | `Slides_NPR.pdf` | 17 | `pdflatex -interaction=nonstopmode Slides_NPR.tex` |

**Slide layout template** (same across all three decks): left coloured panel (3.5cm wide, author/year + description + method badge), right panel (10.15cm wide) with three finding boxes (y: 5.20–6.00, 4.35–5.15, 3.50–4.30) and a green "What this thesis cites / adopts / implements" box (y: 0.10–3.40). Text in finding boxes uses `\tiny\sffamily` for NPR slides (longer technical content) and `\scriptsize\sffamily` for UV and User Study slides.

Run all compile commands from the project root, not from `thesis/`.

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
| `trust/Avatar_Stylization_and_Trust_IEEE_VR_2024.pdf` | Canales et al. (2024) — avatar stylisation and trust, IEEE VR |

---

## 11. User Study Presentation

### 11.1 Presentation File

| What | Path |
|---|---|
| LaTeX source | `UserStudy_Slides.tex` (project root) |
| Compiled PDF | `UserStudy_Slides.pdf` |
| Complete study report | `UserStudy_Complete_Report.tex` / `.pdf` |
| Compile command | `pdflatex -interaction=nonstopmode UserStudy_Slides.tex` (run from project root, not `thesis/`) |

The slides use the Beamer `default` theme, Helvetica (`\sfdefault`), Konstanz blue (`#00539F`), and TikZ for all diagrams. No bibliography needed — compile with a single `pdflatex` run.

### 11.2 Slide Structure (12 slides)

| Slide | Title | Content |
|---|---|---|
| 1 | Title | "User Study — Perception of Virtual Avatar Advisors" |
| 2 | Literature Foundation | 6 papers × what we adopt, professor figure (TikZ) |
| 3 | Three Study Conditions | C1 / C2 / C3 cards, critical comparison bracket C2–C3 |
| 4 | Three Advisor Scenarios | Horizontal table: S1 Career / S2 Travel / S3 Learning |
| 5 | What Participants See | Scrolled browser mockup of Career Choice vignette page |
| 6 | Study Flow Overview | Left-to-right flow: Consent → Demo → × 3 blocks → Debrief |
| 7 | Scene 1 — Welcome & Consent | Browser mockup, checkbox, Start button |
| 8 | Scene 2 — Vignette + Baseline | Browser mockup, scenario context box, radio buttons |
| 9 | Scene 3 — Video Stimulus | Video placeholder, play button, condition badge |
| 10 | Scene 4 — Questionnaire | Parts A–I compact view: eeriness, likeability, trust |
| 11 | Scene 5 — Advisor Selection | Three video thumbnails, primary behavioural measure badge |
| 12 | Scene 6 — Debrief | Checkmark, condition reveal, contact email |

### 11.3 Literature — What Each Paper Contributes

These six papers form the measurement foundation of the user study. Know this table for thesis writing.

| Paper | What we adopt |
|---|---|
| Mori (1970) — Uncanny Valley | Core motivation: NPR moves avatars out of the uncanny zone |
| Canales, Roble & Neff (2024) — Trust + Avatar Stylisation | Study paradigm (video, scripted advisor), trust battery, forced-choice behavioral task |
| McKnight & Chervany (2001) — Trust Typology | Theoretical framework: Competence / Benevolence / Integrity as independent dimensions |
| Bartneck et al. (2009) — Godspeed Questionnaire | Anthropomorphism subscale (Part D) + Likeability subscale (Part C), 5-point semantic differential |
| Ho & MacDorman (2010) — Eeriness Instrument | Eeriness subscale (Part B): 6 semantic differential items, 5-point scale |
| Alipour, Hartmann & Alimardani (2025) — Systematic Review | Design rationale: dynamic video stimuli + multi-component trust measurement + behavioral indicator |

**Key finding from Canales et al. (2024):** Self-reported trust was broadly equivalent across stylisation levels, but the semi-realistic (stylised) condition attracted the highest rate of behavioral selection. This dissociation motivates H2 (NPR does not reduce trust) and justifies including a forced-choice measure alongside self-report scales.

### 11.4 Questionnaire Structure

The questionnaire runs once per video block (3 blocks total). Parts and their sources:

| Part | Name | Items | Scale | Source |
| --- | --- | --- | --- | --- |
| Pre-video | Baseline preference | 1 | Multiple choice | Exploratory secondary measure |
| A | Comprehension check | 1 | Multiple choice | Exclusion criterion |
| C | Likeability | 5 | Sem. diff. 1–5 | Bartneck et al. (2009) — Godspeed |
| D | Human-Likeness / Anthropomorphism | 5 | Sem. diff. 1–5 | Bartneck et al. (2009) — Godspeed |
| B | Eeriness | 6 | Sem. diff. 1–5 | Ho & MacDorman (2010) |
| E | Trust: Competence | 4 | Likert 1–7 | Canales et al. (2024); McKnight & Chervany (2001) |
| F | Trust: Benevolence | 4 | Likert 1–7 | Canales et al. (2024); McKnight & Chervany (2001) |
| G | Trust: Integrity | 3 | Likert 1–7 | Canales et al. (2024); McKnight & Chervany (2001) |
| H | Recommendation agreement + appearance influence + warmth | 3 | Likert 1–7 | Custom; H3 grounded in Gao et al. (2025) |
| I | Visual style check (manipulation check, 2 items) | 2 | Likert 1–7 | Custom |
| J | Open question (Block 2 only) | 1 | Free text | Custom |
| P1 | Advisor selection (primary behavioural measure) | 1 | Forced choice | Canales et al. (2024) paradigm |

**Scale note:** Parts B–D use 5-point semantic differential. Parts E–I use 7-point Likert (1 = Strongly Disagree, 7 = Strongly Agree). The scale change is marked with a separator in Qualtrics.

**Presentation order within 5-point block:** C → D → B (likeability and anthropomorphism before eeriness, to avoid priming toward uncanniness before trust ratings).

**Demographics Q9 (propensity to trust):** Added as a 7-point Likert covariate — "In general, I tend to trust people I meet for the first time." Per Mayer et al. (1995).

**Power analysis (documented in report §Sample Size):** At η²p = 0.06, α = 0.05, power 0.90 requires ~38 participants. Target n = 48 (8 per Latin Square group) exceeds this threshold and accounts for attrition.

### 11.5 Three Scenario Vignettes (full text)

These are the exact texts shown to participants on screen before each video.

**Scenario 1 — Career Choice** (Recommends: Job A | Primary trust dimension: Competence)

> You recently completed your master's degree and have received two job offers in your field. Both positions start in one month. You have no strong financial pressure and both cities are equally acceptable to you. You have five days to decide.
>
> **Job A** is a broad generalist role at a smaller company. The work area is yours to define, the team is small, and your contributions are directly visible. Skills transfer across industries. The starting salary is approximately 8,000 euros per year less than Job B.
>
> **Job B** is a specialist role at a large, well-known company in a high-demand field. The salary is substantially higher and the employer name carries weight on a CV. The role involves deep specialisation within a large team, with less individual visibility.

Advisor spoken recommendation (~45 s): *"My recommendation is Job A. The flexibility to change direction does not come back once you have committed to a specialist track. At the start of a career, the option to pivot is more valuable than it will ever be later. Job A keeps that option open. Job B narrows it."*

---

**Scenario 2 — Travel Route** (Recommends: Route B | Primary trust dimensions: Benevolence, Competence)

> You have just arrived by train in a city you have never visited before. You need to reach your hotel, where you are meeting a group of colleagues in about one hour. You have checked a map app and found two routes, both using public transport.
>
> **Route A** takes around 20 minutes and involves one transfer between lines at a mid-size station you have never used. If the connection runs on time, you arrive approximately 40 minutes before your meeting.
>
> **Route B** takes around 50 minutes on a single direct line with no transfers. It loops through the city centre. You arrive approximately 10 minutes before your meeting.

Advisor spoken recommendation (~43 s): *"My recommendation is Route B. Route A's buffer depends entirely on a connection going well at a station you have never used. If that transfer fails, you are not just arriving a little later. For a meeting you cannot miss, I would rather have certainty than a larger buffer that depends on luck."*

---

**Scenario 3 — Learning Resource** (Recommends: Option A | Primary trust dimension: Integrity)

> You want to learn data analysis to strengthen your CV. You have set aside a few weeks and found two options. You need to decide which one to commit to.
>
> **Option A** is a structured online course from a well-known learning platform. It costs 35 euros, runs about eight hours over a few weeks, and awards a certificate you can add to your CV. The curriculum is set out from start to finish.
>
> **Option B** is a free video tutorial series by a practitioner with a strong reputation and a large following. The content covers the same material at no cost. There is no certificate, and you set your own pace.

Advisor spoken recommendation (~41 s): *"My recommendation is Option A. The content quality between the two is genuinely comparable — I want to be honest about that. What you are paying 35 euros for is the certificate. When you add data analysis to your CV, a credential from a named platform communicates it clearly and quickly to someone reading your application."*

---

**Design principles across all three scenarios:**

- Recommendations alternate A, B, A to avoid systematic option-label bias
- Each scenario targets a different trust dimension (Competence / Benevolence+Competence / Integrity)
- Both options are presented with equal detail and genuine trade-offs — no obviously correct answer
- The advisor speaks only their recommendation and reasoning, not a re-narration of the options
- The pre-video baseline question records the participant's preference before the advisor speaks

### 11.6 Counterbalancing

Balanced Latin Square with 6 groups (G1–G6). Each participant sees all three conditions paired with different scenarios. Minimum recommended n = 48 (8 per group) for power ≥ 0.90 at medium effect size. Data mapping: each participant's "Video 1/2/3" response must be remapped to condition (C1/C2/C3) using their group assignment before aggregating.

### 11.7 Primary Hypothesis Summary

| Hypothesis | Prediction |
| --- | --- |
| H1 | NPR (C3) produces lower eeriness than photorealistic avatar (C2) |
| H2 | NPR (C3) does NOT produce significantly lower trust than C2 (null expected) |
| H3 | Both avatar conditions (C2, C3) produce lower trust than real person (C1) |
| H4 | Eeriness negatively predicts trust across all conditions |
| H5 | Anthropomorphism mediates the condition → eeriness path (exploratory) |

**Critical comparison for the thesis:** C2 vs C3. This is the only pair where animation is held constant and only the NPR shader changes. All other pairs confound rendering with animation naturalness.
