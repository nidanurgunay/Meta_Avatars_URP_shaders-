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

> **Instructions:** Before submission, open each DOI link, confirm title and authors match what is in `references.bib`, and tick it off. For entries without a DOI, check the ResearchGate or ACM DL link listed above.
