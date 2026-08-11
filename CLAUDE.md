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
| Submission deadline | 2026-08-20 |

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
| `V5_HierarchicalGaussian.shader` | Forward material shader, currently assigned to the live V5 materials. **Not what the thesis describes** — see §3.5a. |
| `V6_ChromaticEdge.shader` | Chromatic edge |
| `V8_QuantizedSobel.shader` | Quantized Sobel |
| `AnisotropicKuwahara.shader` | Kuwahara painterly filter |
| `XToon_2DRamp.shader` | XToon 2D ramp abstraction |
| `SobelEdgeDetection.shader` | Standalone Sobel |
| `HierarchicalEdgeDetection.shader` | **The real V5 implementation** — URP Renderer Feature post-process. See §3.5a. |
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
| `V5_HierarchicalGaussian.shader` | Forward material shader, currently assigned to the live V5 materials. **Not what the thesis describes** — see §3.5a. |
| `XToon_2DRamp.shader` | XToon |
| `AnisotropicKuwahara.shader` | Kuwahara |
| `HierarchicalEdgeDetection.shader` | **The real V5 implementation** — URP Renderer Feature post-process. See §3.5a. |
| `SobelEdgeDetection.shader` | Sobel standalone |

Mixamo animation import setting: use **Feet** rig + level **-0.5** in the FBX import settings. Without this the animation sinks below the ground plane.

---

### 3.5a V5 (Hierarchical Edge Detection) — Two Shader Files, Only One Is Correct

**This is a trap. Two files both relate to "V5 Hierarchical" on Mixamo/Jade and Avaturn, and they are architecturally unrelated. Always verify against `HierarchicalEdgeDetection.shader`, never against `V5_HierarchicalGaussian.shader`, when writing about V5 in the thesis.**

| Aspect | `HierarchicalEdgeDetection.shader` (correct) | `V5_HierarchicalGaussian.shader` (wrong for thesis purposes) |
| --- | --- | --- |
| Architecture | URP Renderer Feature, full-screen post-process Blit shader (`Shader "Hidden/PostProcess/..."`, uses `_BlitTexture`, `SAMPLE_TEXTURE2D_X_LOD`, `SampleSceneDepth`, `SampleSceneNormals`) | Ordinary forward material shader assigned directly to mesh materials, same category as V1–V4.2 |
| Depth layer | Roberts Cross on the real URP scene depth texture (`GetLinearEyeDepth` via `SampleSceneDepth`) | `ddx`/`ddy` of world-space camera-distance proxy (same technique as Meta SDK) |
| Normal layer | Roberts Cross on the real scene normals texture (`SampleSceneNormals`) | `ddx`/`ddy` of world-space normal (same technique as Meta SDK / V3) |
| Colour layer | Roberts Cross on luminance **plus** a chromatic term (`chromaEdge`, raw RGB diagonal difference) that catches colour-only boundaries with no luminance difference | XDoG (difference of Gaussians), no Roberts Cross at all — same technique as Meta SDK |
| Adaptive gain | `adaptiveFactor` (inverse-brightness lerp) applied fully to depth and colour layers, half-strength to normal | AHEAD-style gain applied only to the normal layer (same as Meta SDK) |
| Avatar isolation | Dedicated `_AvatarMask` texture gates the composite (needed because it's full-screen) | Not applicable — a per-fragment mesh shader only ever runs on the avatar's own geometry |
| Live status | Renderer Feature (`HierarchicalEdgeDetectionRendererFeature`) is registered in `Assets/URP_QUEST_Renderer.asset` but **`m_Active: 0` (disabled)** and its C# script **no longer exists in the project** (orphaned GUID `b9fbcf26af19645eb90f8e2e64f086e2`). Not configured at all in the Mixamo-specific `Mobile_Renderer.asset`/`PC_Renderer.asset`. | Currently the shader actually referenced by the live V5 materials (`V5_body.mat`, etc., confirmed via `m_Shader` GUID match) |

**Why describe a disabled/orphaned feature in the thesis:** this post-process version is what was actually used to produce the V5 results and figures referenced in Methodology (confirmed 2026-07-28). The current project state reflects a later, unrelated replacement attempt, not a correction of the thesis-relevant implementation. When writing Implementation text for V5, ground every claim in `HierarchicalEdgeDetection.shader`, not in whatever shader the live material happens to point to.

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
- **Prompt interpretation step — MANDATORY.** Nidanur does not consider herself skilled at writing prompts, so before executing any request: (1) silently restate the request in precise terms — the concrete task, the target file(s) or chapter(s), and the scope of the change; (2) if that restatement leaves a genuine gap needed to do the task correctly (which chapter, which technique, which version, whether to also compile, etc.), ask a short clarifying question before touching any file; (3) if the restatement is unambiguous, do not ask, just state the interpreted task in one line and proceed immediately per the "act directly" rule above. This step must never become an excuse to ask permission for routine, obvious tasks — it exists only to catch missing information, not to add a confirmation gate.

### 4.4 Language and Style Rules

**No Fresnel in the thesis.** The Fresnel effect was removed from the design. Do not mention it.

**Abbreviation consistency — MANDATORY (confirmed 2026-08-02).** The first time a term is used anywhere in the thesis, spell it out in full with the abbreviation in parentheses (e.g. "Computer-generated (CG)," "Non-Photorealistic Rendering (NPR)," "virtual reality (VR)"). After that first introduction, always use the abbreviation, never the full term again, anywhere later in the thesis (not just within the same chapter). Before finalising a section, check whether a term already has an established abbreviation earlier in the document and swap any full-term recurrence for the abbreviation.

**STRICT RULE — Hyphenated compound words.** Hyphenated words are a common signal of AI-generated text and must be minimised. However, two categories of hyphens are permitted and must be retained:

1. **Established computer graphics, signal processing, and rendering terminology.** When a hyphenated form is the conventional usage in academic publications (ACM SIGGRAPH, IEEE VR, IEEE TVCG, Eurographics), retain the hyphen. Removing it would deviate from standard field usage and create inconsistency with cited work.
2. **Grammatically required hyphens.** Standard prefix compounds where omitting the hyphen would produce an ambiguous or unreadable word, and cases where English grammar requires the hyphen (e.g. compound modifiers with a number: `9-tap`, `3×3`).

For all other compound adjectives, find an alternative phrasing without a hyphen. Never introduce a hyphen to join an ad hoc compound modifier that is not an established technical term. Never violate standard English grammar rules by removing a hyphen that is required for correctness.

| Term | Rule | Correct form |
| --- | --- | --- |
| real-time rendering | keep — standard CG term | real-time |
| screen-space effects | keep — standard CG term | screen-space |
| non-photorealistic | keep — standard CG term | non-photorealistic |
| low-pass / high-pass filter | keep — standard signal processing | low-pass / high-pass |
| gradient-based method | keep — standard CG/CV usage | gradient-based |
| axis-aligned bounding box | keep — standard CG term | axis-aligned |
| post-processing | keep — standard CG term | post-processing |
| per-fragment computation | keep — standard shader term | per-fragment |
| high-quality output | avoid — ad hoc modifier | high quality output |
| camera-captured texture | avoid — ad hoc modifier | rephrase: "photographically captured texture" |
| selfie-derived albedo | avoid — ad hoc modifier | rephrase: "photographic albedo" |
| cross-avatar tuning | avoid — ad hoc modifier | rephrase: "tuning across avatar platforms" |
| edge-sharpening pipeline | avoid — ad hoc modifier | edge sharpening pipeline |

**General principle.** Whenever a hyphenated compound can be replaced with a short phrase without loss of precision, use the phrase. Reserve hyphens for established academic or scientific terms where the hyphenated form is the standard usage in the relevant literature. When in doubt, rephrase rather than hyphenate.

**GENERAL RULE — Avoid noun-stacking in headings and titles.** Do not chain three or more nouns together as modifiers before a final head noun (e.g., "Parameter calibration guided by a pilot ranking study"). This reads as compressed and unnatural. Rephrase so the heading leads with the actual type of thing being described (study, design, pipeline, technique) and attaches its purpose with a simple "for" or "of," rather than stacking modifiers in front of it. Example: prefer "Pilot study for parameter calibration" over "Parameter calibration guided by a pilot ranking study." Apply this to contribution list headings, section titles, and any other short label, not just hyphenated compounds — the underlying problem (a noun phrase overloaded with modifiers) is the same whether or not hyphens are involved.

**Academic register — human-written tone.** Keep the language natural and human: formal vocabulary and precise causal connectors, no AI-signature phrasing. Specific rules:

- Prefer `since` over `because` when opening a causal clause mid-sentence; avoid `given that` as a mid-sentence connector
- For within-sentence cause-effect chains, causal verbs following "and this" are preferred: "X leads to Z," "X results in Z," "X gives rise to Z," "X produces Z." Example: "H2 predicts equivalence, and this leads to a non-significant result providing insufficient evidence." This is more direct than "because" or "given that."
- Prefer `meaning that` or `consequently` over `so` for causal conclusions
- Prefer `progressing to` or `undertaking` over weak passive constructions such as `are addressed`
- Active voice for decisions and findings; passive only for established technical processes (`was implemented`, `were computed`)
- Avoid over-formal constructions: never use `owing to the fact that`, `it is evident that`, `it should be noted that`, or `it can be seen that`
- **Default to normal subject-verb sentence order — GENERAL RULE.** State the actor and the action first; add qualification, method, manner, setting, or platform afterward, either mid-sentence, at the end, or folded into a coordinate clause. Never open a sentence with a fronted phrase that delays the main subject and verb, regardless of its surface form: this covers gerund/infinitive method phrases ("Rather than X, Y," "By doing X, Y," "Using X, Y," "In order to X, Y"), prepositional setting phrases ("In a VR study, they found…"), and prepositional scope phrases ("On Avaturn, the operator responds…"). Treat these as one underlying problem, not a checklist of individually banned phrases, and apply the same fix to any new fronted-phrase pattern that has the same shape even if it is not listed here. Fronted platform names are acceptable only inside an explicit parallel per-platform comparison already established in the surrounding prose (e.g. a Mixamo/Meta/Avaturn list), not as an ordinary sentence opener. Example: avoid "Rather than using the normal field, V4 applies the operator to the albedo"; write "V4 applies the operator to the albedo rather than the surface normal field." Example: avoid "In a VR study, they found that X"; write "They conducted a VR study and found that X." These phrases remain acceptable mid-sentence or at the end of a sentence, just not as the opening words. The one exception is a true subordinating conjunction ("Although," "Since," "While," "Even though") — opening a sentence with one of these is valid academic style and should not be split apart or otherwise avoided.
- Every sentence should read as if a careful human writer produced it without assistance

**Sentence linking and cohesion — MANDATORY.** Academic paragraphs must form a logical chain, not a list of isolated sentences. Every sentence must connect explicitly to the one before it through at least one of the following devices:

- **Thematic pickup:** open the new sentence by repeating or echoing a key noun or concept from the end of the previous sentence. Example: "…rendering internally." → "This internal rendering architecture prevents…"
- **Pronoun reference:** use "It," "This," "These," or "They" to carry the subject forward when the referent is unambiguous. Example: "…cannot be added." → "It must instead be injected…"
- **Pivot connectors:** use "however," "consequently," "furthermore," or "nonetheless" when the sentence contrasts with or builds on the previous one.
- **Pivot connector placement — MANDATORY.** A pivot or contrast connector ("however," "by contrast," "on the contrary," "nevertheless," "nonetheless," "conversely," "in contrast") belongs at the **start** of the sentence, not inserted medially after the subject. Write "By contrast, trustworthiness scaled monotonically with realism." Do not write "Trustworthiness, by contrast, scaled monotonically with realism." The medial, comma-wrapped placement is a common AI-signature pattern and must be avoided; front-load the connector instead.
- **Never open a sentence with a subject that has not been mentioned or clearly implied in the preceding sentence.** This is the most common violation: jumping to a new topic without a bridge word or lexical echo.
- **Default to an explicit transition — MANDATORY (confirmed 2026-08-07).** When drafting or revising a sentence, actively check whether a transition word, conjunctive adverb, or discourse marker (however, furthermore, since, moreover, yet, consequently, etc.) would make the connection to the previous sentence explicit, and add one by default rather than leaving two sentences merely adjacent with no visible link. This is additive to thematic pickup and pronoun reference above, not a replacement for them — a sentence can use both. Still respect the same-connector-reuse rule (§ conjunction variety below): rotate through the approved alternates per role rather than reaching for the same word repeatedly within one subsection.

Before finalising any paragraph, read it aloud and check that each sentence picks up a thread from the one before it.

**Tense consistency — MANDATORY.** Use tense deliberately and consistently across all chapters:

- **Present tense** for platform and tool descriptions (what they are, what they do), established facts, general truths, and what the thesis contains ("Chapter 4 describes…").
- **Past tense** for completed project actions, development decisions, and the user study ("Nine techniques were developed…", "The study was conducted…").
- **Citation tense rule:** past tense for the act of research ("Lake et al. showed…"), present tense for the finding or ongoing truth ("…that this approach scales well").
- **Never mix tenses within a single sentence** unless the two clauses genuinely refer to different time periods.
- Before finalising any section, scan every sentence for present/past mixing. A sentence that contains both a present and a past verb requires explicit justification.

**No same-root repetition across adjacent sentences.** If a word or its root appears in one sentence, do not use the same root in the immediately following sentence. This is a common pattern in AI-generated text. Rewrite one occurrence with a synonym or restructure the sentence. Example: "techniques presented in this thesis. Each platform presents…" violates this rule; fix by changing one to "described" or "offers."

**Exception — precise technical terms.** A term is exempt from this rule when it is a standard technical term with no suitable synonym, and substituting it would reduce precision or produce unnatural phrasing in the field. The repeated term must be genuinely irreplaceable, not just convenient. Examples of exempt terms: `pixel` ("pixel neighbourhood… more pixels"), `normal` when referring specifically to the surface normal vector in a shader context, `derivative` in a mathematical or calculus context. Non-examples: words like "technique," "approach," "method," or "render" are not exempt because synonyms exist.

**No repeated phrases across adjacent sentences.** Beyond word roots, avoid repeating the same multi-word phrase in consecutive sentences. Rephrase one occurrence using a synonym construction. Example: "without requiring" appearing in two consecutive sentences must be varied — rewrite one as "eliminating the need for" or "independent of."

**Conjunction variety — MANDATORY.** The same conjunction or transitional phrase must not appear in consecutive paragraphs, and must not be overused within a section. The authoritative reference is `Academic_Conjunctions.pdf` in the project root. Before finalising any section, check that "however," "consequently," and "furthermore" do not each appear more than once across two consecutive paragraphs. If they do, swap one occurrence for an alternate below.

| Role | Preferred | Alternates |
|---|---|---|
| Contrast / limitation | however | nevertheless, nonetheless, yet, conversely |
| Addition | furthermore | moreover, equally, in addition |
| Consequence | consequently; meaning that (for results) | therefore, thus, accordingly, hence; **causal verbs** after "and this": leads to, results in, gives rise to, produces |
| Cause | since (over *because* and *given that*) | as, in view of, stems from |
| Summary | taken together | in summary, overall (neutral) |
| Sequence | subsequently | thereafter, ultimately |

**Same-conjunction-per-subsection — MANDATORY (confirmed 2026-08-01).** No conjunction or connective word may be reused anywhere within the same subsection (e.g., not twice within §1.1 Motivation), even across non-consecutive paragraphs — this is stricter than the consecutive-paragraph check above. Before finalising a subsection, scan every paragraph in it and list which connector each one uses. If a connector would repeat, swap it for a different alternate from the table above rather than reusing the word.

Never use: *owing to the fact that*, *it is evident that*, *it should be noted that*. *Due to* is semi-formal — prefer *given* or *since*.

**No em-dashes.** Em-dashes look AI-generated. Use commas, colons, or semicolons instead.

**No semicolons — MANDATORY, no exceptions.** Semicolons read as unacademic in this thesis's target style; avoid them everywhere, not only between independent clauses. Split every semicolon-joined pair of independent clauses into two sentences, linked by thematic pickup, a pronoun reference ("It," "This," "These"), or a connector from the table above. Never write "X; Y" when X and Y could each stand alone. For a list whose items themselves contain internal commas, do not fall back on semicolon separators either: restructure as commas if the items are short (e.g. "(H1), (H2), and (H3)"), or break the list into an enumerated/itemised list environment, or split into separate sentences, whichever preserves clarity. The one narrow exception is a semicolon immediately before "therefore" or "however" (e.g., "…; therefore, …"), and even there, prefer splitting into two sentences unless the two clauses are unusually short and tightly linked. When in doubt, split rather than use a semicolon.

**Sentence length cap — MANDATORY.** A single sentence must not chain more than two clauses or ideas together, whether joined by commas, a colon, or "and." A common violation is a colon-introduced explanation that then continues with an "and"-joined second clause ("This does X: A happens, and B also happens"). Split these into two or three shorter sentences instead, connected via a conjunction, pronoun reference, or thematic pickup from the table above. Before finalising any sentence longer than roughly 25-30 words, check whether it is really two ideas stitched together and split it if so.

**Prefer two short sentences over one joined by "and" for reason-result pairs.** When a sentence states a cause and then its effect, default to splitting them into two sentences rather than joining them mid-sentence with "and." The second sentence should open with a connector that makes the reason-result relationship explicit: "This results in...", "This leads to...", "Thus,", "Consequently,", "Due to that,", or similar from the connector table above. A two-sentence result construction like this is fine and preferred over a single long sentence — it is not the same violation as the sentence-length cap above, which targets sentences that stitch multiple ideas into one clause rather than two short linked sentences.

**Conjunction-linked sentences over participial phrases — MANDATORY.** When two ideas are connected by cause, consequence, or addition, express the link with an explicit coordinating conjunction ("and," "but," "yet") rather than a participial phrase ("-ing" construction appended to the preceding clause). Participial phrases compress two ideas into one clause and make the logical link implicit; a conjunction makes the connection visible and keeps each sentence to one main idea.

| Wrong | Correct |
| --- | --- |
| "…produces weaker gradients, resulting in cleaner edges." | "…produces weaker gradients, and edge structures are consequently cleaner." |
| "…incorporates spatial averaging to suppress noise" | "…incorporates spatial averaging, and this reduces noise sensitivity." |
| "…incorporates the ramp, allowing finer control" | "…incorporates the ramp, and this allows finer control over the tonal distribution." |

When a sentence contains more than one participial phrase, split it and join the parts with a conjunction. This also applies to relative clauses introduced by "which": split the sentence rather than leaving the clause attached — end the first sentence before the clause, then start a new sentence with "This," "It," or a repeated noun, or join the two ideas with an explicit conjunction ("and"). Do not treat swapping "which" for "that" as a fix on its own: it removes the missing-comma problem but still compresses two ideas into one clause. Only use "that" when the clause is genuinely restrictive (it narrows down which specific noun is meant), not as a shortcut around splitting.

Occasionally leaving a "which" clause or a participial phrase unsplit is fine and deliberate for sentence-structure variety, the same way the "Vary the fix pattern" rule below asks for rotation across fix constructions rather than one template applied everywhere. Default to splitting, but do not mechanically flag and split every single instance in a section — some should be left as-is so the passage does not read as a repeated template.

**Vary the fix pattern — MANDATORY.** When multiple participial phrases or "which" clauses are corrected within the same section, do not apply the identical replacement template to every instance. Rotate across different constructions: a new sentence starting with "This" followed by a verb, a new sentence starting with "It" followed by a verb, a coordinating conjunction plus a finite verb ("...and it reveals..."), or a colon introducing a coordinated pair of finite clauses. Applying the same fix (e.g. "This X" every time) across several consecutive fixes is itself a detectable, repetitive AI-signature pattern and should be treated as a violation in its own right.

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

**No cross-section repetition.** If a concept, decision, or rationale has been fully explained in a preceding section or chapter, do not re-state it in prose in a later section. Use a `\Cref{}` cross-reference to point back to the original explanation. A later section may add new information or a brief contextual pointer, but must not re-explain what was already covered. This applies to platform capabilities and selection rationale, technique descriptions, avatar properties, and any design decision already documented earlier in the thesis.

**No within-section knowledge duplication — MANDATORY.** Within a single subsection, each paragraph must introduce only information not already stated in a preceding paragraph of the same subsection. Before writing or editing a paragraph, identify what the previous paragraph already established. The new paragraph must add only genuinely new content: a different level of detail, a new mechanism, a platform-specific observation, or a consequence. It must not re-list items, re-enumerate layers or cues, or restate conclusions already drawn. Common violations to check:

- A paragraph re-enumerates the same components (e.g. depth/normal/colour layers) already listed in the paragraph above.
- A second paragraph opens with "X combines…" when the first already said "X applies…to combine…"
- A summary sentence restates the topic sentence of the same paragraph.

Every sentence in a paragraph must pass the test: does this add something the reader did not already know from any earlier paragraph in this subsection?

**No duplication between main text and figure captions.** Figure label legends (e.g., what a parameter abbreviation such as $t$, $C_Z$, $D_t$, $N_t$, or $C_t$ means) belong in the figure caption only. Never explain the same label in the main body text. Conversely, do not repeat in a caption what the surrounding text has already stated at length.

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

### 5.0a Citation Format — IEEE Numeric

The thesis uses **IEEE numeric citations** (`style=ieee, sorting=none` in biblatex). Citations compile as bracketed numbers, e.g. `[1]`, `[6]`, `[9]`. Numbers are assigned in the order citations first appear in the text and will shift if text is added before them. Always refer to citations by their **bib key** (e.g. `barla2006`, `lake2000`) in source and discussion, not by number, since numbers are unstable. The compiled number for a given key can be confirmed by building the PDF.

**Never present a citation as raw key text — MANDATORY (confirmed 2026-08-02).** A citation must always render as a bracketed number in the compiled PDF, never as the literal bib key (e.g. `natarajan2020`) appearing as visible text next to or instead of the number. If a compiled page shows a raw key instead of `[N]`, this means the bibliography build failed or is stale (e.g. a broken biber run, a race condition from a concurrent edit) — the fix is to rebuild cleanly (biber + pdflatex ×2) and re-verify, not to edit the `\cite{}` source, which is very likely already correct. Before reporting a citation-related task as done, confirm from the rendered PDF that every citation in the affected section shows as `[N]`, not as key text.

### 5.1 Placement Rules

1. **One sentence, one citation.** Never place two citations for the same claim back to back. If two papers support the same sentence, combine them: `\cite{a,b}`.

2. **Citations always appear at the end of the sentence.** Place the citation immediately before the full stop, not mid-sentence after the named concept. "Lake et al. establish that this approach is well-suited for real-time animation~\cite{lake2000}." is correct. "Lake et al.~\cite{lake2000} establish that..." is not. **Author attribution rule applies in Related Work only.** In Related Work, the author or concept must be named in the sentence body — a bare `~\cite{barla2006}` with no mention of Barla is not acceptable there. In all other chapters (Methodology, Implementation, Evaluation), a citation may appear at the end of a sentence without the author being named in the body, provided the cited claim is clearly identified.

3. **No citations inside `lstlisting` captions.** Move any citation to the prose paragraph that explains the listing.

4. **Each citation must directly support the claim it is attached to.** Do not attach a citation just because the paper is broadly relevant.

5. **Never attach a citation to a sentence describing our own empirical work.** If the sentence says what *we* evaluated, implemented, or observed, it does not get a citation — even if the method used comes from a cited paper. Split the sentence: one sentence credits the external method with a citation, the next sentence states our evaluation without one. Example — Wrong: "Three modes were evaluated using the attribute mapping mechanism~\cite{barla2006}." Correct: "The attribute mapping mechanism of Barla et al.\ supports three modes~\cite{barla2006}. All three were evaluated in this work."

6. **Verify placement before finalising every section.** Check every paragraph. The citation must be on the exact sentence making the claim.

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

### 5.4a Citation Verification PDF — the only citation checklist, MANDATORY

There is exactly one citation verification document: `citation_check.tex` / `citation_check.pdf` (project root). Do not create a second citation-checklist PDF derived from `thesis/citation_sources.md` — one was tried (2026-08-01) and removed because it duplicated `citation_check.tex` with less rigour (many entries had no actual quoted source excerpt, only bibliographic metadata). Nidanur reviews `citation_check.pdf`, not the raw markdown.

`citation_check.tex` uses a numbered blue header badge per entry, a green-highlighted box for the exact thesis sentence, a red-highlighted box for the original source excerpt, and a real interactive AcroForm checkbox footer (`\CheckBox`, not a static `$\square$` glyph — confirmed 2026-08-01 to produce genuine `/FT/Btn` widgets). Whenever a new citation is added anywhere in the thesis, add a matching `\citentry{...}` block immediately (see the MANDATORY workflow rule at the top of that file) and recompile:
```
pdflatex -interaction=nonstopmode citation_check.tex
```
**Recompiling regenerates the whole PDF from scratch and wipes every checkbox Nidanur has ticked in Preview** — pdflatex has no memory of a previously-saved PDF's form data. Nidanur initially (2026-08-01) said she'd accept re-ticking after each recompile, but after losing ticks on entries she'd already confirmed, asked for those specific ones to persist. Fix implemented the same day: `\citentry{...}` (no star) renders its checkbox unchecked as before; `\citentry*{...}` (starred) renders it pre-checked (`/V/Yes /AS/Yes` in the AcroForm, confirmed via direct PDF-object inspection). **Whenever Nidanur tells you an entry is confirmed/validated, add the star to that specific `\citentry` call site** so the tick survives every future recompile automatically — do not just leave it to her to re-tick in Preview. Only recompile this file when a citation is actually added or corrected, and if new entries were added, tell her which ones are new so she can review and tell you to star them once confirmed.
`thesis/citation_sources.md` remains the mandatory raw bibliographic log per §5.4 above, but it is a working data file, not something Nidanur reviews directly — do not build a second PDF from it.

**MANDATORY — independent re-check before starring, every time (confirmed 2026-08-06).** When Nidanur says an entry is "validated," do not just add the star. First do one more independent check yourself: re-read the relevant thesis sentence fresh (it drifts often), and re-examine the citation against the primary source with a critical eye for anything not yet caught, not just re-confirming what a previous note already said. Then tell her explicitly what you checked and whether you found any abnormality, before or alongside starring the entry. If you find something (e.g. a sentence over-generalising from a single-paper citation, a stale quote, a duplicate entry), report it plainly rather than silently starring anyway. This surfaced a real, still-open issue the same day it was introduced: `citation_check.tex` §1.2's `canales2024` entry ("Existing work on avatar stylisation has primarily focused on...") turned out to over-generalise from one paper, the same pattern already fixed for the neighbouring `isenberg2003` entry, and a second duplicate entry for the same usage was also caught and deleted this way.

---

## 6. Section Ownership — Chapter Purposes

Each chapter has one job. Content belongs in the chapter whose job it matches, not the chapter where it is convenient to write it.

### 6.1 Chapter Purpose Table

| Chapter | Purpose | Contains | Does NOT contain |
|---|---|---|---|
| 01 Introduction | Motivate the problem, state the contribution | Problem statement, research questions, contributions, thesis outline | Technique detail, literature detail, results |
| 02 Related Work | Situate the thesis against prior work | Prior NPR techniques, prior uncanny valley/trust studies, the gap each leaves open | Our design decisions, our implementation, our results |
| 03 Background | Give the conceptual and technical grounding the later chapters assume | Rendering pipeline basics, shader/HLSL concepts, the math behind Sobel/Gaussian/Kuwahara etc., trust and uncanny valley theory | Project-specific design decisions, our shader files, our results |
| 04 Methodology | Explain why the work was designed this way | Why a technique was chosen, what problem it solves, conceptual algorithm description, design rationale, formulas, "this motivates V_N" transitions, user study design rationale | Shader file names, hook/API names, HLSL signatures, tuned parameter values, results |
| 05 Implementation | Document what was built and how | Shader file names, Unity hook names and API calls, HLSL function signatures, material and platform integration, tuned parameter values, empirical development observations | Motivation sentences ("this approach solves X"), citations justifying a design choice, interpretation of results |
| 06 Evaluation | Present and interpret the user study outcome | Study execution, participant data, statistical results, H1–H5 outcomes, result figures/tables, discussion of what the results mean | Study design rationale (→ Methodology), technique or shader description, new literature used to justify design choices (only cite to interpret a result) |
| 07 Conclusion | Summarize and reflect | Summary of findings, answers to RQ1–RQ4, limitations, future work | New results, new citations, new technique description |

### 6.2 Methodology vs Implementation (strict)

This is the split most often violated. Cross-contamination is a writing error.

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

The techniques were developed in `Assets/AvatarShaderExperimental/` first, then ported to the Meta Avatar pipeline. Each technique was motivated by a specific limitation of the previous one. There are eight techniques in total: six main versions (V1–V6) plus two decimal variants (V2.2, V4.2). **V7 and V8 do not exist in the thesis** — an earlier plan included a Kuwahara+Sobel combination and a three-way Kuwahara+Gauss+Hierarchical composite, but these were dropped before the Methodology chapter was finalised and must not appear anywhere in the thesis text.

- V1 (inverted hull outline): stable silhouette via geometry expansion, but no interior detail
- V2 (toon shading): quantised diffuse ramp, no interior edge information
- V2.2 (X-Toon): 2D ramp lookup driven by lighting and a separate abstraction axis (depth/curvature/manual), still shading-only
- V3 (screen-space normal edge detection): zero extra samples, catches creases, misses colour boundaries, edge thickness scales with viewing distance
- V4 (Sobel): catches colour edges, but noisy on photographic textures (baked illumination, UV seams) — fixed with threshold calibration and seam rejection on the Meta SDK, and Avaturn head texture preprocessing
- V4.2 (Gaussian prefiltered Sobel): pre-smoothing reduces noise, up to 72 sample cost, insufficient gain once texture preprocessing was applied — not carried into the final composite
- V5 (Hierarchical multi-cue): depth proxy + normal + Roberts Cross colour, AHEAD-inspired adaptive gain on Meta SDK, best boundary coverage but facial segment boundaries remain unclear — excluded from the final composite after the parameter adjustment study
- V6 (Kuwahara): painterly abstraction of texture, not edge-based, anisotropic on Mixamo/Avaturn, forced isotropic-like on Meta SDK (no blur pass for the structure tensor) — excluded from the final composite after the parameter adjustment study

### Key technical constraints

- No extra render passes allowed (Quest performance budget)
- SDK LOD switching reverts materials — solved by periodic re-apply coroutine in AvatarShaderSwapper
- UV seam artifacts in screen-space Sobel — solved by luminance range check (`_SeamRangeLimit`)
- Skin vs clothing thresholding — solved by HSV saturation cutoff (`_SkinSaturationCutoff`)
- Isotropic Kuwahara only — anisotropic requires structure tensor and a separate render texture pass, which is not possible in the fragment hook

### Citation Keys

Do not assume a key is missing from a memorized list — that list goes stale as the thesis progresses. Verify directly:
```
grep -oE '@\w+\{[a-zA-Z0-9_]+,' thesis/references.bib
```
(Confirmed present as of 2026-07-25: all keys in the §5.3 mapping table, including `barla2006`, `kyprianidis2009`, `isenberg2003`, `macdorman2006`, `gonzalez2018`, `lake2000`, `mori1970`, `nowak2003`, `gooch1998`, `weidner2023`, `schlick1994`, and `roshaan2026` for AHEAD.)

---

## 9. Reference Articles

**MANDATORY — Check the original PDF before attributing any claim.** Article summaries can paraphrase or omit nuance. Before writing any sentence that attributes a specific finding or argument to an author, read the relevant passage in the original PDF. The summaries are a starting point; the original source is authoritative. If a claim cannot be found in the original PDF, do not attribute it to that author.

**MANDATORY — If the primary PDF is not available, stop and ask Nidanur to get it. Never settle for secondary-source verification alone.** Confirmed 2026-08-02: when a citation is added or checked and the primary source PDF is not in `/Users/nidanurgunay/Desktop/Uni/VR Avatar Project/Articles/` (or any subfolder), do not mark the citation "CONFIRMED" based only on a secondary source's description of it (e.g. how another paper's review/introduction cites and summarises it), and do not silently proceed with just a DOI/CrossRef cross-check as if that were sufficient. Instead, stop and tell Nidanur exactly which article is missing — full title, authors, venue, year, and DOI — and ask her to download it and either drop the PDF into the Articles folder or paste the full article text into the chat. Only mark the citation entry CONFIRMED once the primary PDF has actually been read. A secondary-source paraphrase or a bibliographic cross-check (CrossRef, Semantic Scholar, etc.) can support a `references.bib` entry's bibliographic accuracy (author/title/venue/year/DOI), but it does not substitute for reading the primary source to verify the actual claim.

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
| Bartneck et al. (2009) — Godspeed Questionnaire | Likeability subscale (Part B) + Anthropomorphism subscale (Part C), 5-point semantic differential |
| Ho & MacDorman (2010) — Eeriness Instrument | Eeriness subscale (Part D): 8 semantic differential items, 5-point scale |
| Alipour, Hartmann & Alimardani (2025) — Systematic Review | Design rationale: dynamic video stimuli + multi-component trust measurement + behavioral indicator |

**Key finding from Canales et al. (2024):** Self-reported trust was broadly equivalent across stylisation levels, but the semi-realistic (stylised) condition attracted the highest rate of behavioral selection. This dissociation motivates H2 (NPR does not reduce trust) and justifies including a forced-choice measure alongside self-report scales.

### 11.4 Questionnaire Structure

The questionnaire runs once per video block (3 blocks total). Parts and their sources:

| Part | Name | Items | Scale | Source |
| --- | --- | --- | --- | --- |
| Pre-video | Baseline preference | 1 | Multiple choice | Exploratory secondary measure |
| A | Comprehension check | 1 | Multiple choice | Exclusion criterion |
| B | Likeability | 5 | Sem. diff. 1–5 | Bartneck et al. (2009) — Godspeed |
| C | Human-Likeness / Anthropomorphism | 5 | Sem. diff. 1–5 | Bartneck et al. (2009) — Godspeed |
| D | Eeriness | 8 | Sem. diff. 1–5 | Ho & MacDorman (2010) |
| E | Trust: Competence | 3 | Likert 1–7 | Mayer et al. (1995); McKnight & Chervany (2001) |
| F | Trust: Benevolence | 3 | Likert 1–7 | Mayer et al. (1995); McKnight & Chervany (2001) |
| G | Trust: Integrity | 3 | Likert 1–7 | Mayer et al. (1995); McKnight & Chervany (2001) |
| H | Recommendation agreement + appearance influence + warmth | 3 | Likert 1–7 | Custom; H3 grounded in Gao et al. (2025) |
| I | Visual style check (manipulation check, 2 items) | 2 | Likert 1–7 | Custom |
| J | Open question (Block 2 only) | 1 | Free text | Custom |
| P1 | Advisor selection (primary behavioural measure) | 1 | Forced choice | Canales et al. (2024) paradigm |

**Scale note:** Parts B–D use 5-point semantic differential. Parts E–I use 7-point Likert (1 = Strongly Disagree, 7 = Strongly Agree). The scale change is marked with a separator in Qualtrics.

**Presentation order within 5-point block:** B → C → D (likeability and anthropomorphism before eeriness, to avoid priming toward uncanniness before trust ratings).

**Demographics Q9 (propensity to trust):** Added as a 7-point Likert covariate — "In general, I tend to trust people I meet for the first time." Per Mayer et al. (1995).

**Power analysis (documented in report §Sample Size):** At η²p = 0.06, α = 0.05, power 0.90 requires ~38 participants. Target n = 48 (16 per study version, 3 versions) exceeds this threshold and accounts for attrition.

### 11.5 Three Scenario Vignettes (full text)

These are the exact texts shown to participants on screen before each video.

**Scenario 1 — Career Choice** (Recommends: Job A | Primary trust dimension: Competence)

> You recently completed your master's degree and have received two job offers in your field. Both positions start in one month. You have no strong financial pressure and both cities are equally acceptable to you. You have five days to decide.
>
> **Job A** is a broad generalist role at a smaller company. The work area is yours to define, the team is small, and your contributions are directly visible. Skills transfer across industries. The starting salary is approximately 8,000 euros per year less than Job B.
>
> **Job B** is a specialist role at a large, well-known company in a high-demand field. The salary is substantially higher and the employer name carries weight on a CV. The role involves deep specialisation within a large team, with less individual visibility.

Advisor spoken recommendation (~22 s): *"I'd go with Job A. Yes, the salary is lower right now, but the generalist role gives you a range of experience that is genuinely hard to get later. Salary gaps can be closed in the future. But once you specialise, switching back is costly. Take the pivot while you can."*

---

**Scenario 2 — Travel Route** (Recommends: Route B | Primary trust dimensions: Benevolence, Competence)

> You have just arrived by train in a city you have never visited before. You need to reach your hotel, where you are meeting a group of colleagues in about one hour. You have checked a map app and found two routes, both using public transport.
>
> **Route A** takes around 50 minutes on a single direct line with no transfers. It loops through the city centre. You arrive approximately 10 minutes before your meeting.
>
> **Route B** takes around 20 minutes and involves one transfer between lines at a mid-size station you have never used. If the connection runs on time, you arrive approximately 40 minutes before your meeting.

Advisor spoken recommendation (~22 s): *"I'd take Route B. Yes, it has a transfer at a station you have never used. But it gets you there forty minutes early. If something goes wrong, you still have enough time to recover. Route A is direct but leaves only ten minutes. That may not be enough. Take the buffer."*

---

**Scenario 3 — Learning Resource** (Recommends: Option A | Primary trust dimension: Integrity)

> You want to learn data analysis to strengthen your CV. You have set aside a few weeks and found two options. You need to decide which one to commit to.
>
> **Option A** is a structured online course from a well-known learning platform. It costs 350 euros, runs about eight hours over a few weeks, and awards a certificate you can add to your CV. The curriculum is set out from start to finish.
>
> **Option B** is a free video tutorial series by a practitioner with a strong reputation and a large following. The content covers the same material at no cost. There is no certificate, and you set your own pace.

Advisor spoken recommendation (~22 s): *"I would take Option A. Yes, 350 euros is a real cost. But the certificate is what matters here. It is not just about what you learn, it is about what you can show. A recruiter cannot verify a free tutorial series. That is worth it."*

---

**Design principles across all three scenarios:**

- Recommendations alternate A, B, A to avoid systematic option-label bias
- Each scenario targets a different trust dimension (Competence / Benevolence+Competence / Integrity)
- Both options are presented with equal detail and genuine trade-offs — no obviously correct answer
- The advisor speaks only their recommendation and reasoning, not a re-narration of the options
- The pre-video baseline question records the participant's preference before the advisor speaks

### 11.6 Counterbalancing

3×3 Latin square with 3 study versions (labeled A/B/C — verify against `tab:latin_square` in `04_methodology.tex`, not a fixed list, since this has changed before). Scenario order is held constant (Career=Video 1, Travel=Video 2, Learning=Video 3); the three conditions rotate across those fixed video slots by study version. Recruitment target n = 48 (16 per study version) for power ≥ 0.90 at medium effect size. Data mapping: each participant's "Video 1/2/3" response must be remapped to condition (C1/C2/C3) using their study-version assignment before aggregating.

### 11.7 Primary Hypothesis Summary

**Updated 2026-08-04: exactly four confirmatory hypotheses (H1–H4), confirmed by Nidanur directly and cross-checked against `04_methodology.tex` §Objective and Hypotheses and `06_evaluation.tex` §Hypothesis Tests, where H4 is as fully developed as H2 (own subsection, own TOST equivalence test).** This supersedes the previous "exactly three hypotheses, C1 always exploratory" rule (confirmed 2026-07-31) — that rule is no longer correct. The thesis also now has four research questions (RQ1–RQ4, not RQ1–RQ3): a new RQ2 was inserted ("Which NPR technique or combination of techniques best balances visual abstraction against facial and expressive legibility under production rendering constraints?"), pushing the former RQ2/RQ3 to RQ3/RQ4. RQ4 ("Can an NPR avatar match the perceived trustworthiness of a real human speaker?") is what H4 formally answers.

| Hypothesis | Prediction | Test |
| --- | --- | --- |
| H1 | NPR (C3) produces lower eeriness than photorealistic avatar (C2) | Repeated-measures MANOVA across subscale composites, univariate ANOVA + Bonferroni pairwise on the eeriness composite, C2 vs C3 |
| H2 | NPR (C3) does NOT produce significantly lower trust than C2 (equivalence/null expected) | Same MANOVA framework, univariate ANOVA + Bonferroni pairwise on Competence/Benevolence/Integrity composites, C2 vs C3, PLUS a TOST equivalence test on the C2-vs-C3 trust composite (Cohen's d = 0.3 bound) — a non-significant pairwise result alone is not sufficient to confirm H2 |
| H3 | Eeriness negatively predicts trust across all conditions | Person-centred (within-participant) multilevel regression, eeriness composite predicting each trust subscale, random intercept per participant — NOT a simple pooled/raw correlation across conditions, which conflates within- and between-condition variance |
| H4 | NPR (C3) does NOT produce significantly lower trust than the real human speaker (C1) (equivalence/null expected) | Same structure as H2 but against C1 instead of C2: ANOVA + Bonferroni pairwise on Competence/Benevolence/Integrity composites restricted to C1 vs C3, PLUS a TOST equivalence test with the same d = 0.3 bound |

C1 (real person) still plays a more exploratory role for the three post-study ranking measures (P1 advisor selection, trustworthiness ranking, unsettlingness ranking — Friedman + Wilcoxon, Bonferroni-corrected, reported for all three pairwise comparisons), which remain reported but not treated as hypothesis-confirming or disconfirming the way H1–H4 are.

**Critical comparison for the thesis:** C2 vs C3. This is the only pair where animation is held constant and only the NPR shader changes. H4's C1 vs C3 comparison additionally confounds rendering style with residual differences in human likeness, animation naturalness, and speaker identity — this is noted explicitly in Evaluation's own H4 discussion.

**Known inconsistency (2026-07-31, still unresolved as of 2026-08-04):** `UserStudy_Complete_Report.tex` still contains an older draft with five hypotheses (H1–H5, including a different H3 and an anthropomorphism-mediation H5) and tells the reader to pre-register "the five hypotheses (H1–H5)" on OSF. That report has not been reconciled with either the previous 3-hypothesis version or the current 4-hypothesis version in the actual chapters. Do not pre-register or cite the 5-hypothesis version without first updating that report to match §11.7 above (H1–H4, not H1–H5).
