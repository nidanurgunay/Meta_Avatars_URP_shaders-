# Thesis Citation Guidelines — Nidanur Günay

These rules govern every citation decision in the thesis.
Apply them consistently before finalising any section.

---

## Placement rules

1. **One sentence, one citation.** Never place two citations for the same claim back-to-back.
   If two papers support the same sentence, combine into one cite pair `\cite{a,b}` or restructure.

2. **Name the author or concept before the citation.** Write what the cited work *contributed*,
   then cite it. "Barla et al.\ term this Normal Field Abstraction~\cite{barla2006}" is correct.
   A bare `~\cite{barla2006}` at the end of a sentence that never mentions Barla is not.

3. **Citations belong in prose, never inside `lstlisting` captions.**
   Move the citation to the prose paragraph that explains the technique.

4. **Each citation must directly support the claim it is attached to.**
   Do not attach a citation to a sentence just because the paper is broadly relevant.

---

## When to cite

| Situation | Action |
|-----------|--------|
| Named NPR technique (Sobel, Kuwahara, XToon, …) | Cite the original paper on first use |
| Mathematical formula from a specific paper | Cite that paper next to the formula |
| Standard textbook knowledge (Lambert NdotL, basic OpenGL/HLSL) | No citation needed |
| Limitation of a class of techniques (e.g. geometry-only = no interior edges) | Cite survey or foundational paper (e.g. Isenberg 2003 for silhouette limitations) |
| Claim about human perception / trust / embodiment | Cite user study or perceptual study directly |
| Implementation detail grounded in project code | No citation; ground in code file / shader |
| Observed artefact or empirical tuning result | No citation; describe as empirical observation |

---

## Which paper for which claim

| Claim | Key in `references.bib` |
|-------|------------------------|
| Toon / cel shading, real-time bands | `lake2000` |
| Non-photorealistic lighting replaces smooth gradients | `gooch1998` |
| Silhouette algorithms, geometry-only edge limits | `isenberg2003` |
| XToon 2D ramp, Normal Field Abstraction, abstraction axis | `barla2006` |
| Blinn-Phong specular model | `blinn1977` |
| Schlick Fresnel approximation | `schlick1994` |
| Sobel / gradient operators, BT.601 luma coefficients | `gonzalez2018` |
| Canny: smoothing before differentiation | `canny1986` |
| Marr–Hildreth: LoG / Gaussian prior to edge detection | `marr1980` |
| Anisotropic Kuwahara filter | `kyprianidis2009` |
| Hatching / tonal art maps | `praun2001` |
| Uncanny valley | `mori1970` |
| Avatar realism & trust | `canales2024`, `latoschik2017` |
| Social presence, copresence, embodiment | `nowak2003`, `yee2007` |
| Godspeed questionnaire | `macdorman2006` |
| Roberts Cross operator | `gonzalez2018` |

---

## Section ownership

| Content type | Section |
|--------------|---------|
| Why this technique, what problem it solves, conceptual algorithm, design rationale, mathematical principles | **Methodology** |
| Shader file names, Unity hook names, HLSL API calls, Unity material/platform integration, parameter tuning, empirical observations from development | **Implementation** |

Never put shader hook names, API call signatures, or material slot names in the Methodology chapter.
Never put "this motivates V_N" transition sentences in the Implementation chapter — they belong in Methodology.
