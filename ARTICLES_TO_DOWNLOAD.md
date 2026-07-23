# Articles to Download

Papers flagged as missing from `Articles/` or found new this session.
Each entry lists the bib key, full citation, where to find it, and what to verify inside.

---

## PRIORITY 1 — Trust / Evaluation Chapter (Ch. 6)

### mayer1995
**Mayer, R. C., Davis, J. H., & Schoorman, F. D. (1995)**
"An Integrative Model of Organizational Trust"
*Academy of Management Review*, Vol. 20, No. 3, pp. 709–734

- **Where to get it:** Google Scholar → search title → download PDF
- **What to verify inside:**
  - The definition of trust as "willingness to be vulnerable"
  - The three-component ABI model (Ability, Benevolence, Integrity)
  - Propensity to trust named as a stable individual difference that moderates the ABI model
  - Whether the model implies 4 Ability + 4 Benevolence + 3 Integrity = 11 items
- **Cited in thesis at:** Related Work (trust typology), Evaluation (questionnaire structure, propensity covariate)
- **Note:** Canales (2024) confirms this paper uses the ABI framework — so the attribution is correct, but exact wording must be verified.

---

### nowak2005
**Nowak, K. L., & Rauh, C. (2005)**
"The Influence of the Avatar on Online Perceptions of Anthropomorphism, Androgyny, Credibility, Homophily, and Attraction"
*Journal of Computer-Mediated Communication*, Vol. 11, No. 1

- **Where to get it:** Wiley Online Library or Google Scholar
- **What to verify inside:**
  - The participant count (thesis says 255 participants)
  - The finding direction: more anthropomorphic avatar → perceived as more credible
- **Cited in thesis at:** Related Work (avatar anthropomorphism and credibility)

---

### yee2007
**Yee, N., & Bailenson, J. (2007)**
"The Proteus Effect: The Effect of Transformed Self-Representation on Behavior"
*Human Communication Research*, Vol. 33, No. 3, pp. 271–290

- **Where to get it:** Wiley Online Library, or Bailenson's Stanford lab page
- **What to verify inside:**
  - That "Proteus effect" as a term is coined in this exact paper (not a later one)
  - The behavioural outcomes listed in thesis: more disclosure, more assertive negotiation, shorter physical distances
- **Cited in thesis at:** Related Work (avatar self-representation effects on behaviour)

---

### gao2025
**Gao et al. (2025)**
*(exact title unknown — needs to be confirmed from references.bib)*

- **Where to get it:** Check `thesis/references.bib` for the full title, then Google Scholar
- **What to verify inside:**
  - Trust equivalence across stylisation levels
  - Voice/speech effect on trust was negligible
  - Perceived agent age as a moderator
  - Warmth and stylisation finding (warmth ratings vary with NPR level)
- **Cited in thesis at:** Related Work and Evaluation
- **Note:** The bib entry for this paper may be incomplete. Check references.bib first.

---

## PRIORITY 2 — NPR / Image Processing (Ch. 3 & 4)

### marr1980
**Marr, D., & Hildreth, E. (1980)**
"Theory of Edge Detection"
*Proceedings of the Royal Society B: Biological Sciences*, Vol. 207, No. 1167, pp. 187–217

- **Where to get it:** Royal Society Publishing → open archive, or Google Scholar
- **What to verify inside:**
  - That Gaussian pre-filtering before differentiation is explicitly stated as a requirement
  - The isotropy argument: Gaussian is chosen because it attenuates noise equally in all spatial directions (no orientation bias)
  - Whether the LoG (Laplacian of Gaussian) and not just Gaussian is their specific contribution
- **Cited in thesis at:** Ch. 3 Background (Gaussian pre-filtering), Ch. 4 V4.2 Gaussian Sobel
- **Note:** The Sun et al. (2022) Frontiers survey incorrectly attributes the Sobel operator to Marr & Hildreth — do NOT follow that attribution. This paper is about LoG edge detection, not Sobel.

---

### canny1986
**Canny, J. (1986)**
"A Computational Approach to Edge Detection"
*IEEE Transactions on Pattern Analysis and Machine Intelligence*, Vol. 8, No. 6, pp. 679–698

- **Where to get it:** IEEE Xplore (free author version often on Google Scholar)
- **What to verify inside:**
  - The three-stage pipeline: (1) Gaussian smooth → (2) gradient computation → (3) non-maximum suppression
  - Whether Canny explicitly states that gradient-based detectors require prior smoothing to suppress noise
  - Whether Marr & Hildreth (1980) or Canny is the better citation for the "smooth before differentiating" principle
- **Cited in thesis at:** Ch. 3 Background, Ch. 4 V4 and V4.2 motivation
- **Note:** Both Marr & Hildreth and Canny make the smoothing argument. After reading both, decide which citation is more appropriate for each claim.

---

### zibrek2019tap
**Zibrek, K., Martin, S., & McDonnell, R. (2019)**
*(verify exact title — likely "Exploring the Effect of Realistic Rendering on the Perception of Stylised Characters")*
*ACM Transactions on Applied Perception*, Vol. 16, No. 3

- **Where to get it:** ACM Digital Library (or Google Scholar for author preprint)
- **What to verify inside:**
  - The finding that NPR rendering performs at least as well as photorealism for emotional recognition
  - Any claim about social presence not decreasing with stylisation
- **Cited in thesis at:** Related Work (NPR and perceptual equivalence)

---

### zibrek2019mig
**Zibrek, K., & McDonnell, R. (2019)**
*(verify exact title — likely at MIG 2019, ACM SIGGRAPH Motion in Games)*

- **Where to get it:** ACM Digital Library
- **What to verify inside:**
  - The dissociation between place illusion (presence) and social presence with stylised avatars
- **Cited in thesis at:** Related Work

---

## PRIORITY 3 — New Citation Found This Session

### kong2023 (OPEN ACCESS — download directly)
**Kong, W., Chen, J., Song, Y., Fang, Z., Yang, X., & Zhang, H. (2023)**
"Sobel Edge Detection Algorithm with Adaptive Threshold Based on Improved Genetic Algorithm for Image Processing"
*International Journal of Advanced Computer Science and Applications (IJACSA)*, Vol. 14, No. 2, pp. 557–562
DOI: 10.14569/IJACSA.2023.0140266

- **Where to get it:** Direct PDF link: https://thesai.org/Downloads/Volume14No2/Paper_66-Sobel_Edge_Detection_Algorithm_with_Adaptive_Threshold.pdf
- **Why needed:** Best internet source found for citing Sobel as a commonly used method
- **Sentence to use:** "As a common edge detection algorithm, Sobel operator combines Gaussian smoothing and differentiation to calculate the gradient value of image brightness function." (p. 557, §II)
- **Cited in thesis at:** Ch. 4 V4 Sobel — "one of the most widely used gradient-based edge detection methods"
- **Note:** IJACSA is Scopus-indexed. Citable in a thesis. Use alongside `gonzalez2018` for the "widely used" claim.

---

## PRIORITY 4 — Book Chapter (physical or library copy only)

### nienhaus2005
**Nienhaus, M., & Döllner, J. (2005)**
"Blueprint Rendering and 'Sketchy Drawings'"
in *GPU Gems 2: Programming Techniques for High-Performance Graphics*, Ch. 15, Addison-Wesley

- **Where to get it:** University library (physical book), or Google Books partial preview
- **What to verify inside:**
  - The exact page range for Chapter 15 (thesis bib entry currently says "pages to verify")
  - Whether the G-buffer normal and z-buffer edge detection method described matches the thesis claim
- **Cited in thesis at:** Ch. 4 V3 Normal Edge Detection
- **Note:** The nienhaus2003 WSCG paper (already available as `Articles/NPR/Edge Enhancement.pdf`) covers the same method and may be sufficient without needing this book chapter.

---

## Already Available — No Download Needed

| Paper | File in Articles/ |
|---|---|
| Gonzalez & Woods (2018) | `Gonzales,Woods-Digital.Image.Processing.4th.Edition.pdf` |
| Nienhaus & Döllner (2003) | `NPR/Edge Enhancement.pdf` |
| Saito & Takahashi (1990) | `NPR/Comprehensible Rendering of 3-D Shapes Saito.pdf` |
| McKnight & Chervany (2001) | `trust/What Trust Means in E-Commerce Customer Relationships.pdf` |
| Isenberg et al. (2003) | `NPR/Isenberg_2003_ADG.pdf` |
| Barla et al. (2006) | `NPR/x-toon.pdf` |
| Kyprianidis et al. (2009) | `NPR/anisotropic_kuwahara.pdf` |
| Canales et al. (2024) | `trust/Avatar_Stylization_and_Trust_IEEE_VR_2024.pdf` |
| AHEAD / Roshaan (2026) | `NPR/Adaptive Hierarchical Edge Detection.pdf` |
| Mori (1970) | `uncanny1970.pdf` |
| MacDorman (2006) | `MacDorman2006AndroidScience.pdf` |
| Nowak & Biocca (2003) | `Nowak2003.pdf` |
| Weidner et al. (2023) | `Weidner2023.pdf` |
| Ho & MacDorman (2010) | `trust/Ho2010UncannyValleyIndices.pdf` |
| Bartneck et al. (2009) | `trust/Bartneck_2009_Measurement Instruments...pdf` |
| Alipour et al. (2025) | `trust/Alipor_Would You Rely on an Eerie Agent?.pdf` |
| Gooch et al. (1998) | `NPR/Gooch1998.pdf` |
