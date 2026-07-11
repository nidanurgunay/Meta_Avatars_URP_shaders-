# Citation Sources — Verification Log

This document tracks every citation added to `references.bib` that was not sourced from a physical paper in the thesis folder. Check each entry before submission.

---

## Added in Session: V1 Toon Shading Citations (2026-05-26)

### `schlick1994`
- **Full title:** An Inexpensive BRDF Model for Physically-Based Rendering
- **Author:** Christophe Schlick
- **Journal:** Computer Graphics Forum, Vol. 13, No. 3, pp. 233–246
- **Year:** 1994
- **DOI:** 10.1111/1467-8659.1330233
- **Verify at:** https://doi.org/10.1111/1467-8659.1330233
- **Source:** Referenced as [14] in `NidanurGunay_Project_Report.pdf` (V1 Fresnel section)
- **Used in:** `04_methodology.tex` §V1 Toon Shading
- **Sentence:** "A Fresnel rim lighting term, approximated using Schlick's formulation~\cite{schlick1994}, brightens surface regions facing perpendicular to the viewer..."

```bibtex
@article{schlick1994,
  author    = {Schlick, Christophe},
  title     = {An Inexpensive {BRDF} Model for Physically-Based Rendering},
  journal   = {Computer Graphics Forum},
  year      = {1994},
  volume    = {13},
  number    = {3},
  pages     = {233--246},
  doi       = {10.1111/1467-8659.1330233},
  publisher = {Blackwell Publishing},
}
```

> Note: `gooch1998`, `lake2000`, and `isenberg2003` are also cited in V1 — these were already in `references.bib` from physical PDFs in the Articles folder (see table below).

---

## Added in Session: Background Chapter Rewrite (2026-05-25)

### `latoschik2017`
- **Full title:** The Effect of Avatar Realism in Immersive Social Virtual Realities
- **Authors:** Marc Erich Latoschik, Daniel Roth, Daniel Gall, Jascha Achenbach, Thomas Waltemate, Mario Botsch
- **Venue:** Proceedings of the 23rd ACM Symposium on Virtual Reality Software and Technology (VRST 2017)
- **DOI:** 10.1145/3139131.3139156
- **Verified at:** https://dl.acm.org/doi/10.1145/3139131.3139156
- **Also available at:** https://downloads.hci.informatik.uni-wuerzburg.de/2017-vrst-effect-of-avatar-realism.pdf (full PDF)
- **Used in:** `03_background.tex` §Virtual Avatars and Visual Representation
- **Sentence:** "Where an avatar sits along this continuum has measurable consequences for how users are perceived, how much social presence is felt in the interaction, and how the avatar is trusted~\cite{latoschik2017, nowak2003}."

```bibtex
@inproceedings{latoschik2017,
  author    = {Latoschik, Marc Erich and Roth, Daniel and Gall, Daniel and Achenbach, Jascha and Waltemate, Thomas and Botsch, Mario},
  title     = {The Effect of Avatar Realism in Immersive Social Virtual Realities},
  booktitle = {Proceedings of the 23rd {ACM} Symposium on Virtual Reality Software and Technology ({VRST})},
  year      = {2017},
  doi       = {10.1145/3139131.3139156},
  publisher = {ACM},
}
```

---

### `yee2007`
- **Full title:** The Proteus Effect: The Effect of Transformed Self-Representation on Behavior
- **Authors:** Nick Yee, Jeremy N. Bailenson
- **Journal:** Human Communication Research, Vol. 33, No. 3, pp. 271–290
- **Year:** 2007
- **DOI:** 10.1111/j.1468-2958.2007.00299.x
- **Verified at:** https://onlinelibrary.wiley.com/doi/abs/10.1111/j.1468-2958.2007.00299.x
- **Also available at:** https://vhil.stanford.edu/sites/g/files/sbiybj29011/files/media/file/yee-proteus-implications.pdf (Stanford VHIL)
- **Used in:** `03_background.tex` §Virtual Avatars and Visual Representation
- **Sentence:** "Yee and Bailenson~\cite{yee2007} demonstrated through a series of experiments that users assigned more attractive or physically taller avatars adopted behaviours consistent with those characteristics..."

```bibtex
@article{yee2007,
  author    = {Yee, Nick and Bailenson, Jeremy N.},
  title     = {The {Proteus} Effect: The Effect of Transformed Self-Representation on Behavior},
  journal   = {Human Communication Research},
  volume    = {33},
  number    = {3},
  pages     = {271--290},
  year      = {2007},
  doi       = {10.1111/j.1468-2958.2007.00299.x},
}
```

---

## Previously in references.bib (from physical papers in Articles folder)

### `mori1970`
- **Physical file:** `uncanny1970.pdf`

```bibtex
@article{mori1970,
  author    = {Mori, Masahiro},
  title     = {The Uncanny Valley},
  journal   = {Energy},
  year      = {1970},
  volume    = {7},
  number    = {4},
  pages     = {33--35},
  note      = {Translated by Karl F. MacDorman and Norri Kageki},
}
```

### `nowak2003`
- **Physical file:** `Nowak2003.pdf`
- **DOI:** 10.1162/105474603322761289

```bibtex
@article{nowak2003,
  author    = {Nowak, Kristine L. and Biocca, Frank},
  title     = {The Effect of the Agency and Anthropomorphism on Users' Sense of Telepresence, Copresence, and Social Presence in Virtual Environments},
  journal   = {Presence: Teleoperators and Virtual Environments},
  year      = {2003},
  volume    = {12},
  number    = {5},
  pages     = {481--494},
  doi       = {10.1162/105474603322761289},
}
```

### `gooch1998`
- **Physical file:** `Gooch1998.pdf`
- **DOI:** 10.1145/280814.280950

```bibtex
@inproceedings{gooch1998,
  author    = {Gooch, Amy and Gooch, Bruce and Shirley, Peter and Cohen, Elaine},
  title     = {A Non-Photorealistic Lighting Model for Automatic Technical Illustration},
  booktitle = {Proceedings of SIGGRAPH},
  year      = {1998},
  pages     = {447--452},
  doi       = {10.1145/280814.280950},
}
```

### `weidner2023`
- **Physical file:** `Weidner2023.pdf`
- **DOI:** 10.1145/3544548.3581551

```bibtex
@inproceedings{weidner2023,
  author    = {Weidner, Florian and Broll, Wolfgang},
  title     = {Watching Yourself in a Video Conference: The Role of Perspective and Avatar Embodiment},
  booktitle = {Proceedings of the ACM CHI Conference on Human Factors in Computing Systems},
  year      = {2023},
  doi       = {10.1145/3544548.3581551},
}
```

### `macdorman2006`
- **Physical file:** `MacDorman2006AndroidScience.pdf`

```bibtex
@inproceedings{macdorman2006,
  author    = {MacDorman, Karl F. and Ishiguro, Hiroshi},
  title     = {The Uncanny Advantage of Using Androids in Cognitive and Social Science Research},
  booktitle = {Proceedings of the {ICDL-2006} Workshop on Android Science},
  year      = {2006},
  pages     = {1--9},
}
```

### `isenberg2003`
- **Physical file:** `Isenberg_2003_ADG.pdf`
- **DOI:** 10.1109/MCG.2003.1210862

```bibtex
@article{isenberg2003,
  author    = {Isenberg, Tobias and Freudenberg, Bert and Halper, Nick and Schlechtweg, Stephan and Strothotte, Thomas},
  title     = {A Developer's Guide to Silhouette Algorithms for Polygonal Models},
  journal   = {{IEEE} Computer Graphics and Applications},
  year      = {2003},
  volume    = {23},
  number    = {4},
  pages     = {28--37},
  doi       = {10.1109/MCG.2003.1210862},
}
```

### `barla2006`
- **Physical file:** `x-toon.pdf`
- **DOI:** 10.1145/1124728.1124749
- **Used in:** `04_methodology.tex` §V2 X-Toon Extended Toon Shading
- **Sentence:** "The second technique extends the toon shading model of V1 using the X-Toon approach proposed by Barla et al.~\cite{barla2006}."

```bibtex
@inproceedings{barla2006,
  author    = {Barla, Pascal and Thollot, Jo\"{e}lle and Markosian, Lee},
  title     = {{X-Toon}: An Extended Toon Shader},
  booktitle = {Proceedings of the 4th International Symposium on Non-Photorealistic Animation and Rendering (NPAR)},
  year      = {2006},
  pages     = {127--132},
  doi       = {10.1145/1124728.1124749},
}
```

### `kyprianidis2009`
- **Physical file:** `anisotropic_kuwahara.pdf`
- **DOI:** 10.1111/j.1467-8659.2009.01574.x

```bibtex
@article{kyprianidis2009,
  author    = {Kyprianidis, Jan Eric and Kang, Henry and D\"{o}llner, J\"{u}rgen},
  title     = {Image and Video Abstraction by Anisotropic {Kuwahara} Filtering},
  journal   = {Computer Graphics Forum},
  year      = {2009},
  volume    = {28},
  number    = {7},
  pages     = {1955--1963},
  doi       = {10.1111/j.1467-8659.2009.01574.x},
}
```

### `praun2001`
- **Physical file:** `hatching.pdf`
- **DOI:** 10.1145/383259.383328

```bibtex
@inproceedings{praun2001,
  author    = {Praun, Emil and Hoppe, Hugues and Webb, Matthew and Finkelstein, Adam},
  title     = {Real-Time Hatching},
  booktitle = {Proceedings of the 28th Annual Conference on Computer Graphics and Interactive Techniques (SIGGRAPH)},
  year      = {2001},
  pages     = {581--586},
  doi       = {10.1145/383259.383328},
}
```

### `gonzalez2018`
- **Physical file:** `Gonzales,Woods-Digital.Image.Processing.4th.Edition.pdf`
- **ISBN:** 9780133356724

```bibtex
@book{gonzalez2018,
  author    = {Gonzalez, Rafael C. and Woods, Richard E.},
  title     = {Digital Image Processing},
  edition   = {4th},
  publisher = {Pearson},
  year      = {2018},
  isbn      = {9780133356724},
}
```

### `canny1986`
- **DOI:** 10.1109/TPAMI.1986.4767851

```bibtex
@article{canny1986,
  author    = {Canny, John},
  title     = {A Computational Approach to Edge Detection},
  journal   = {{IEEE} Transactions on Pattern Analysis and Machine Intelligence},
  year      = {1986},
  volume    = {PAMI-8},
  number    = {6},
  pages     = {679--698},
  doi       = {10.1109/TPAMI.1986.4767851},
}
```

### `marr1980`
- **DOI:** 10.1098/rspb.1980.0020

```bibtex
@article{marr1980,
  author    = {Marr, David and Hildreth, Ellen},
  title     = {Theory of Edge Detection},
  journal   = {Proceedings of the Royal Society of London. Series~B, Biological Sciences},
  year      = {1980},
  volume    = {207},
  number    = {1167},
  pages     = {187--217},
  doi       = {10.1098/rspb.1980.0020},
}
```

### `lake2000`
- **DOI:** 10.1145/340916.340918

```bibtex
@inproceedings{lake2000,
  author    = {Lake, Adam and Marshall, Carl and Harris, Mark and Blackstein, Marc},
  title     = {Stylized Rendering Techniques for Scalable Real-Time {3D} Animation},
  booktitle = {Proceedings of the 1st International Symposium on Non-Photorealistic Animation and Rendering (NPAR)},
  year      = {2000},
  pages     = {13--20},
  doi       = {10.1145/340916.340918},
}
```

### `canales2024`
- **DOI:** 10.1109/VR58804.2024.00063

```bibtex
@inproceedings{canales2024,
  author    = {Canales, Ryan and Roble, Doug and Neff, Michael},
  title     = {The Impact of Avatar Stylization on Trust},
  booktitle = {2024 {IEEE} Conference on Virtual Reality and {3D} User Interfaces ({VR})},
  year      = {2024},
  pages     = {418--428},
  doi       = {10.1109/VR58804.2024.00063},
}
```

### `metasdk`
- **Source:** Meta developer documentation, accessed 2025-01-10

```bibtex
@misc{metasdk,
  author       = {{Meta Platforms, Inc.}},
  title        = {Meta Avatars {SDK} Documentation},
  year         = {2024},
  howpublished = {\url{https://developer.oculus.com/documentation/unity/meta-avatars-overview/}},
  note         = {Accessed: 2025-01-10},
}
```

---

## Added in Session: V2 X-Toon Blinn-Phong Citation (2026-05-27)

### `blinn1977`
- **Full title:** Models of Light Reflection for Computer Synthesized Pictures
- **Author:** James F. Blinn
- **Venue:** Proceedings of the 4th Annual Conference on Computer Graphics and Interactive Techniques (SIGGRAPH 1977)
- **Pages:** 192–198
- **DOI:** 10.1145/965141.563893
- **Verify at:** https://doi.org/10.1145/965141.563893
- **Source:** Standard foundational reference — no physical PDF in thesis folder; DOI confirmed on ACM DL
- **Used in:**
  1. `04_methodology.tex` §V2 X-Toon — paragraph on specular: "...computed using the Blinn-Phong model~\cite{blinn1977}."
  2. `05_implementation.tex` §V2 X-Toon — Listing caption: "Stylised specular (Blinn-Phong~\cite{blinn1977}) — Mixamo and Avaturn."

```bibtex
@inproceedings{blinn1977,
  author    = {Blinn, James F.},
  title     = {Models of Light Reflection for Computer Synthesized Pictures},
  booktitle = {Proceedings of the 4th Annual Conference on Computer Graphics and Interactive Techniques (SIGGRAPH)},
  year      = {1977},
  pages     = {192--198},
  doi       = {10.1145/965141.563893},
}
```

---

---

## Added in Session: Trust Foundation Citations (2026-06-21)

### `mayer1995`
- **Full title:** An Integrative Model of Organizational Trust
- **Authors:** Roger C. Mayer, James H. Davis, F. David Schoorman
- **Journal:** Academy of Management Review, Vol. 20, No. 3, pp. 709–734
- **Year:** 1995
- **DOI:** 10.5465/amr.1995.9508080335
- **Verify at:** https://doi.org/10.5465/amr.1995.9508080335
- **Source:** Foundational organizational trust theory — no physical PDF in thesis folder; DOI confirmed on Academy of Management website
- **What the paper argues:** Proposes the ABI integrative model: trustworthiness comprises three independently evaluable components — Ability (domain-specific competence), Benevolence (orientation toward the trustor's interests), and Integrity (adherence to moral principles). Defines trust as the willingness to be vulnerable to another party's actions irrespective of the ability to monitor. Introduces propensity to trust as an individual-level moderator of how the trustee's characteristics translate into trust.
- **Used in:**
  1. `thesis/chapters/02_related_work.tex` §Trust and Credibility in Virtual Agents — opening paragraph establishing the theoretical foundation
  2. `thesis/chapters/02_related_work.tex` §Research Gap — trust battery attribution sentence
  3. `UserStudy_Complete_Report.tex` — theoretical framework section

```bibtex
@article{mayer1995,
  author    = {Mayer, Roger C. and Davis, James H. and Schoorman, F. David},
  title     = {An Integrative Model of Organizational Trust},
  journal   = {Academy of Management Review},
  year      = {1995},
  volume    = {20},
  number    = {3},
  pages     = {709--734},
  doi       = {10.5465/amr.1995.9508080335},
}
```

### `mcknight2001`
- **Full title:** What Trust Means in E-Commerce Customer Relationships: An Interdisciplinary Conceptual Typology
- **Authors:** D. Harrison McKnight, Norman L. Chervany
- **Journal:** International Journal of Electronic Commerce, Vol. 6, No. 2, pp. 35–59
- **Year:** 2001
- **DOI:** 10.1080/10864415.2001.11044235
- **Verify at:** https://doi.org/10.1080/10864415.2001.11044235
- **Source:** Trust typology literature — no physical PDF in thesis folder
- **What the paper argues:** Extends the Mayer et al. ABI model into a comprehensive typology distinguishing trusting beliefs (assessments of trustworthiness) from trusting intentions (willingness to depend). Identifies competence, benevolence, integrity, and predictability as separable trusting belief dimensions. Provides a framework for measuring trust across both attitudinal and behavioural dimensions simultaneously.
- **Used in:**
  1. `thesis/chapters/02_related_work.tex` §Trust and Credibility in Virtual Agents — introduced alongside Mayer et al.
  2. `thesis/chapters/02_related_work.tex` §Research Gap — operationalisation sentence for trust battery
  3. `UserStudy_Complete_Report.tex` — trust framework section

```bibtex
@article{mcknight2001,
  author    = {McKnight, D. Harrison and Chervany, Norman L.},
  title     = {What Trust Means in {E-Commerce} Customer Relationships: An Interdisciplinary Conceptual Typology},
  journal   = {International Journal of Electronic Commerce},
  year      = {2001},
  volume    = {6},
  number    = {2},
  pages     = {35--59},
  doi       = {10.1080/10864415.2001.11044235},
}
```

### `ho2010` (bibliographic correction)
- **Full title:** Revisiting the Uncanny Valley Theory: Developing and Validating an Alternative to the Godspeed Indices
- **Authors:** Chin-Chang Ho, Karl F. MacDorman
- **Journal:** Computers in Human Behavior, Vol. 26, No. 6, pp. 1508–1518
- **Year:** 2010
- **DOI:** 10.1016/j.chb.2010.05.015 *(corrected from wrong DOI in prior session)*
- **Pages:** 1508–1518 *(corrected from wrong pages 2712–2728 in prior session)*
- **Verify at:** https://doi.org/10.1016/j.chb.2010.05.015
- **What the paper argues:** Develops and validates a two-subscale instrument for uncanny valley measurement, distinguishing perceived eeriness from perceived human-likeness placement. Demonstrates that eeriness and humanness are statistically orthogonal (r = .02), meaning a stimulus can be rated both highly human-like and highly eerie simultaneously. Validates the eeriness subscale (6 semantic differential items, Cronbach's α = .74) across multiple stimulus types. The correct scale has 8 items total; this thesis uses 6 of them.

```bibtex
@article{ho2010,
  author    = {Ho, Chin-Chang and MacDorman, Karl F.},
  title     = {Revisiting the Uncanny Valley Theory: Developing and Validating an Alternative to the {Godspeed} Indices},
  journal   = {Computers in Human Behavior},
  year      = {2010},
  volume    = {26},
  number    = {6},
  pages     = {1508--1518},
  doi       = {10.1016/j.chb.2010.05.015},
}
```

### `alipour2025`
- **Full title:** Would You Rely on an Eerie Agent? A Systematic Review of the Impact of the Uncanny Valley Effect on Trust in Human-Agent Interaction
- **Authors:** Ahdiyeh Alipour, Tilo Hartmann, Maryam Alimardani
- **Venue:** arXiv preprint arXiv:2505.05543 [cs.HC]
- **Year:** 2025
- **arXiv:** https://arxiv.org/abs/2505.05543
- **Source:** Full 75-page paper read from images provided in session (2026-06-21)
- **What the paper argues:** PRISMA-compliant systematic review of 53 empirical studies on UVE–trust interactions across 7 databases (641→311→53 after screening, inter-rater Kappa = 0.61). Novel taxonomy of trust operationalisation: (1) direct trust measures (n=24), (2) trust-related constructs — competence, credibility, acceptability (n=11), (3) trust-related intentions — behavioral indicators, advice following (n=18). Among 41 empirically tested studies: 17 direct negative effect, 24 conditional/moderated effect, 10 no effect. 42/53 used indirect encounters (video/images). Identifies moderators: task type (n=6), familiarity (n=3), age (n=3), personality (n=3). Key recommendations: dynamic video stimuli, combine self-report + behavioral, 3–5+ human-likeness levels, power analysis, mediation model. Documents competence as a buffer: MacDorman (2019), Dai & MacDorman (2021), Patel & MacDorman (2015) all show competence can override eeriness on trust.
- **Used in:**
  1. `thesis/chapters/02_related_work.tex` §Trust and Credibility in Virtual Agents — full Alipour paragraph
  2. `thesis/chapters/02_related_work.tex` §Research Gap — forced-choice behavioral task motivation
  3. `UserStudy_Complete_Report.tex` — comprehensive dedicated section with taxonomy table, findings summary, moderators, limitations, and recommendations

```bibtex
@misc{alipour2025,
  author        = {Alipour, Ahdiyeh and Hartmann, Tilo and Alimardani, Maryam},
  title         = {Would You Rely on an Eerie Agent? {A} Systematic Review of the Impact of the Uncanny Valley Effect on Trust in Human--Agent Interaction},
  year          = {2025},
  eprint        = {2505.05543},
  archivePrefix = {arXiv},
  primaryClass  = {cs.HC},
  url           = {https://arxiv.org/abs/2505.05543},
}
```

---

## Added in Session: Section 4.2 Avatar Platforms (2026-07-02)

### `avaturn`
- **Full title:** Avaturn: AI-Powered Avatar Creation from a Single Photograph
- **Author/Organisation:** Avaturn Inc.
- **Year:** 2024
- **DOI:** None (online service)
- **Verify at:** https://avaturn.me
- **Used in:** `04_methodology.tex` §4.2 Avatar Platforms and Rendering Constraints
- **Sentence:** "Avaturn is an avatar creation service that uses AI to reconstruct a rigged, blendshape-animated avatar from a single uploaded photograph, shown in Figure~\ref{fig:avaturn_default}~\cite{avaturn}."
- **Summary:** Avaturn is a commercial service that produces a fully rigged, blendshape-animated humanoid avatar from a single uploaded photograph using learned 3D reconstruction. The output is a glTF 2.0 (.glb) file containing geometry, PBR textures, skeleton rig, and ARKit-compatible blendshape targets. The photorealistic facial reconstruction quality makes it suitable as a high-fidelity avatar baseline for perceptual studies.

```bibtex
@misc{avaturn,
  author       = {{Avaturn Inc.}},
  title        = {Avaturn: {AI}-Powered Avatar Creation from a Single Photograph},
  year         = {2024},
  note         = {Online service producing rigged, blendshape-animated glTF avatars from a photograph},
}
```

---

### `gltf2`
- **Full title:** glTF 2.0 Specification
- **Author/Organisation:** Khronos Group
- **Year:** 2017
- **DOI:** None (technical specification)
- **Verify at:** https://www.khronos.org/gltf/
- **Used in:** `04_methodology.tex` §4.2 Avatar Platforms and Rendering Constraints
- **Sentence:** "Avaturn exports avatars in the \texttt{.glb} format, the binary container of the glTF~2.0 standard, which packages geometry, PBR materials, skeleton rig, and blendshape targets into a single file~\cite{gltf2}."
- **Summary:** The glTF 2.0 specification defines an open standard for the efficient transmission and loading of 3D scenes and models. The binary variant (.glb) packs all resources (meshes, textures, skeletons, animations, morph targets) into a single file. It has become the standard interchange format for real-time 3D assets. The specification defines PBR material semantics (metallic-roughness workflow), morph targets (used for blendshape animation), and skeletal animation. Unity does not load glTF natively at runtime; GLTFast is required.

```bibtex
@techreport{gltf2,
  author       = {{Khronos Group}},
  title        = {{glTF} 2.0 Specification},
  institution  = {The Khronos Group},
  year         = {2017},
  note         = {Open standard for 3D asset transmission; binary container format is \texttt{.glb}},
}
```

---

---

## Added in Session: Abstraction-Level Citation Pair (2026-07-09)

### `wallraven2008`
- **Full title:** Evaluating the Perceptual Realism of Animated Facial Expressions
- **Authors:** Christian Wallraven, Martin Breidt, Douglas W. Cunningham, Heinrich H. Bülthoff
- **Journal:** ACM Transactions on Applied Perception, Vol. 4, No. 4, Article 23, 20 pages
- **Year:** 2008
- **DOI:** 10.1145/1278760.1278764
- **Physical file:** `/Users/nidanurgunay/Desktop/Uni/VR Avatar Project/Articles/NPR/Evaluating the perceptual realism of animated facial expressions. .pdf`
- **What the paper argues:** Three psychophysical experiments measuring recognition, intensity, sincerity, and typicality of CG animated facial expressions benchmarked against real video. Key findings: motion is the dominant channel (removing head motion dropped recognition from 65.5% to 44.2%); shape blurring does not impair recognition when motion is intact but does reduce perceived intensity and sincerity; adding eyes raised recognition by ~5% and significantly increased intensity and sincerity ratings.
- **Used in:** Thesis sentence about excessive stylisation undermining expressive readability
- **Exact cited sentence:** §4 Summary, p. 23:19 — "In addition, in Experiment 2, we found clear effects of shape blurring on both intensity and sincerity judgments. This demonstrates that, even though reduced shape information does not affect recognition, it does influence the perceived quality of the expression."

```bibtex
@article{wallraven2008,
  author    = {Wallraven, Christian and Breidt, Martin and Cunningham, Douglas W. and B{\"u}lthoff, Heinrich H.},
  title     = {Evaluating the Perceptual Realism of Animated Facial Expressions},
  journal   = {ACM Transactions on Applied Perception},
  year      = {2008},
  volume    = {4},
  number    = {4},
  pages     = {23:1--23:20},
  doi       = {10.1145/1278760.1278764},
  publisher = {ACM},
}
```

---

### `zell2015`
- **Full title:** To Stylize or Not to Stylize? The Effect of Shape and Material Stylization on the Perception of Computer-Generated Faces
- **Authors:** Eduard Zell, Carlos Aliaga, Adrian Jarabo, Katja Zibrek, Diego Gutierrez, Rachel McDonnell, Mario Botsch
- **Journal:** ACM Transactions on Graphics, Vol. 34, No. 6, Article 184, 12 pages (SIGGRAPH Asia 2015)
- **Year:** 2015
- **DOI:** 10.1145/2816795.2818126
- **Physical file:** `/Users/nidanurgunay/Desktop/Uni/VR Avatar Project/Articles/NPR/To Stylize or not to Stylize?_Zell.pdf`
- **What the paper argues:** Factorial perceptual study crossing 3-5 levels of shape stylisation with 3-5 levels of material stylisation on CG faces (male and female actors). Core finding: shape governs perceived realism and expression intensity; material governs appeal, eeriness, and attractiveness. Realism is a bad predictor for appeal. Mismatched shape/material raises eeriness. Moderate texture blurring increases appeal without degrading realism. Expression intensity decreases as shape becomes more stylised (less realistic).
- **Used in:** Thesis sentence about excessive stylisation undermining expressive readability
- **Exact cited sentence:** Main Findings list, p. 184:2 — "The perceived intensity of expressions decreases with realism of shape, but is nearly independent of material stylization." (Interpretation: as shape stylisation increases and realism decreases, perceived intensity also decreases.)

```bibtex
@article{zell2015,
  author    = {Zell, Eduard and Aliaga, Carlos and Jarabo, Adrian and Zibrek, Katja and Gutierrez, Diego and McDonnell, Rachel and Botsch, Mario},
  title     = {To Stylize or Not to Stylize? {The} Effect of Shape and Material Stylization on the Perception of Computer-Generated Faces},
  journal   = {ACM Transactions on Graphics},
  year      = {2015},
  volume    = {34},
  number    = {6},
  pages     = {184:1--184:12},
  doi       = {10.1145/2816795.2818126},
  publisher = {ACM},
}
```

---

> **Instructions:** Before submission, open each DOI link, confirm title and authors match what is in `references.bib`, and tick it off. For entries without a DOI, check the ResearchGate or ACM DL link listed above.
