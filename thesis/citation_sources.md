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
- **CORRECTED 2026-08-01:** The Introduction previously claimed this paper found an influence on "interpersonal trust." Read directly (title page, abstract, §1–3): the paper is titled "The Effect of the Agency and Anthropomorphism on Users' Sense of Telepresence, Copresence, and Social Presence in Virtual Environments," and its two formal hypotheses concern copresence and social presence only. The word "trust" does not appear in the title, abstract, or hypotheses. Fixed the thesis sentence to claim only social presence and copresence; trust is now introduced as the paragraph's own closing bridge sentence, not attributed to this citation.
- **Used in:** `01_introduction.tex` §Motivation, "This growing engagement..." paragraph
- **Cited sentence:** "Research confirmed this: avatar appearance exerts a measurable influence on social and copresence~\cite{nowak2003}."

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

### `bente2008`
- **Full title:** Avatar-Mediated Networking: Increasing Social Presence and Interpersonal Trust in Net-Based Collaborations
- **Authors:** Gary Bente, Sabine Rüggenberg, Nicole C. Krämer, Felix Eschenburg
- **Venue:** Human Communication Research, Vol. 34, No. 2, pp. 287–318
- **Year:** 2008
- **DOI:** 10.1111/j.1468-2958.2008.00322.x
- **Bibliographic verification:** Cross-checked via CrossRef API and the Oxford Academic (Human Communication Research) abstract page; both agree on authors, journal, volume/issue, pages, and DOI.
- **Physical PDF:** `Articles/Human Communication Research - 2008 - Bente - Avatar-Mediated Networking  Increasing Social Presence and Interpersonal.pdf`. Located and added by Nidanur, read in full (pp. 287–289, Abstract through Background), 2026-08-01.
- **Verification level:** CONFIRMED — full text read, superseding the earlier abstract-only pass. Bibliographic details match the CrossRef record exactly.
- **Abstract (p. 287, verbatim):** "This study analyzes the influence of avatars on social presence, interpersonal trust, perceived communication quality, nonverbal behavior, and visual attention in Net-based collaborations using a comparative approach... Significant differences were found between text chat and all other communication modalities in perceived intimateness, co-presence, and emotionally-based trust. Microanalyses of nonverbal activity and visual attention point to similarities between video and avatar modes, both showing higher levels of exposure to the virtual other and visual attention, in particular in the initial phase of interaction as compared to text and audio."
- **Introduction (p. 288, verbatim) — conceptual justification for the presence/trust pairing:** "interpersonal trust (Kanawattanachai & Yoo, 2002; McAllister, 1995), and social presence (Bente, Rüggenberg, & Krämer, 2004; Daft & Lengel, 1984; Gunawardena & Zittle, 1997). The latter two concepts are of particular interest for the current approach as they are complementary to each other: Whereas trust is generic to human communication and implies evaluative aspects, social presence is aiming at mediated communication and is more descriptive by nature. Thus, in combination, both variables can be expected to cover a wide range of relational media effects."
- **Used in:** NOT CURRENTLY CITED ANYWHERE (2026-08-04). Was used in `01_introduction.tex` §Motivation, "This growing engagement..." paragraph, but that whole paragraph was replaced with a shorter, uncited transition sentence at Nidanur's request. No other section cites bente2008. The verification below remains valid if this citation is reinstated elsewhere (e.g. Related Work's trust/social-presence discussion).
- **Former cited sentence (removed):** "This same presence has been linked to interpersonal trust and perceived communication quality in avatar-mediated collaboration~\cite{bente2008}."
- **Relevance:** Grounds a bridge from social presence/copresence (Nowak \& Biocca) to trust. Bente et al. explicitly measure social presence, interpersonal trust, and perceived communication quality together, and their own Introduction gives the theoretical rationale for treating presence and trust as complementary constructs.

```bibtex
@article{bente2008,
  author    = {Bente, Gary and R{\"u}ggenberg, Sabine and Kr{\"a}mer, Nicole C. and Eschenburg, Felix},
  title     = {Avatar-Mediated Networking: Increasing Social Presence and Interpersonal Trust in Net-Based Collaborations},
  journal   = {Human Communication Research},
  year      = {2008},
  volume    = {34},
  number    = {2},
  pages     = {287--318},
  doi       = {10.1111/j.1468-2958.2008.00322.x},
}
```

### `gooch1998`
- **Physical file:** `Gooch1998.pdf`
- **DOI:** 10.1145/280814.280950
- **REMOVED FROM THESIS 2026-08-11:** the cool-to-warm model paragraph in `02_related_work.tex` §2.3 was dropped when that section was reordered around Kumar and Poornima's four-category taxonomy plus a corrected toon-shading/silhouette-rendering narrative. Confirmed via full-text grep across `thesis/chapters/*.tex` that `gooch1998` is no longer cited anywhere in the thesis. Entry kept here for reference only; not currently used.

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
- **CORRECTED 2026-08-01.** The bib entry previously here was fabricated: title "Watching Yourself in a Video Conference: The Role of Perspective and Avatar Embodiment," DOI `10.1145/3544548.3581551`. That DOI actually belongs to an unrelated CHI 2023 paper by different authors (Chen, Liu, Ding, O'Neil, Agarwal, Kraut & Dabbish, "Facilitating Counselor Reflective Learning with a Real-time Annotation Tool"), verified via CrossRef. No paper titled "Watching Yourself in a Video Conference" by Weidner & Broll appears to exist. The physical PDF saved as `Weidner2023.pdf` (and re-added as `_2022_10_07__IEEE_VR__A_Survey_on_Avatar_and_Agents.pdf`) is a different, real paper by an overlapping author list — see below.
- **Physical file:** `_2022_10_07__IEEE_VR__A_Survey_on_Avatar_and_Agents.pdf` (also present as `Weidner2023.pdf`, same paper). Read in full (title, abstract, intro, discussion, conclusion), 2026-08-01.
- **Full title:** A Systematic Review on the Visualization of Avatars and Agents in AR & VR Displayed Using Head-Mounted Displays
- **Authors:** Florian Weidner, Gerd Boettcher, Stephanie Arevalo Arboleda, Chenyao Diao, Luljeta Sinani, Christian Kunert, Christoph Gerhardt, Wolfgang Broll, Alexander Raake
- **Venue:** IEEE Transactions on Visualization and Computer Graphics (presented at IEEE VR 2023)
- **DOI:** 10.1109/TVCG.2023.3247072
- **Summary:** Systematic review (PRISMA method) of 72 papers (2015–2022) on avatar and agent visualisation in AR/VR displayed via HMDs. Classifies studies by rendering style (abstract, stickman, hybrid, robot, cartoon, stylized, video, point cloud, translucent, generic/personalized/scanned realistic) and by visible body part configuration, across five task domains (physical activity, hand interaction, communication, game-like scenarios, education/training). Conclusion: full-body visualisations usually outperform partial-body configurations; a realistic rendering style yields better results than other styles in most studies; but task-focused activities (e.g. gaming, education) do not benefit much from highly realistic avatars and are sometimes hampered by them; personalized avatars that resemble the actual user tend to perform even better than generic realistic ones.
- **Used in:** `01_introduction.tex` §Motivation, opening paragraph (abstract/intro's "AR/VR pushing from labs towards consumers... avatars or agents" framing); `02_related_work.tex` §2.2 Trust (task-dependence of photorealism's advantage, the Conclusion's task-domain-dependence finding). **Note (2026-08-01):** an earlier draft also cited this source a second time in the Introduction's "Communication through avatars" paragraph for the 72-study systematic-review finding; that sentence was removed as too Related-Work-like for the Introduction. The finding remains properly cited, once, in Related Work.
- **Cited sentences:** "As virtual assistants, game characters, and avatars in immersive environments increasingly involve users in sustained interactions with virtual humans, users are no longer limited to passive viewing~\cite{weidner2023}." / (Related Work) "Weidner et al.\ synthesised the effect of rendering style at a much larger scale in a systematic review of 72 studies on avatar and agent visualisation in augmented and virtual reality~\cite{weidner2023}."
- **Relevance:** Corroborates, at a much larger systematically-reviewed scale, that avatar/agent rendering style has measurable perceptual and behavioural consequences, and that photorealism's advantages are task-dependent rather than unconditional — directly relevant to testing whether they transfer to this thesis's video-based advisory scenario.

```bibtex
@article{weidner2023,
  author    = {Weidner, Florian and Boettcher, Gerd and Arboleda, Stephanie Arevalo and Diao, Chenyao and Sinani, Luljeta and Kunert, Christian and Gerhardt, Christoph and Broll, Wolfgang and Raake, Alexander},
  title     = {A Systematic Review on the Visualization of Avatars and Agents in {AR} \& {VR} Displayed Using Head-Mounted Displays},
  journal   = {IEEE Transactions on Visualization and Computer Graphics},
  year      = {2023},
  doi       = {10.1109/TVCG.2023.3247072},
  note      = {Presented at IEEE VR 2023},
}
```

### `mcdonnell2012`
- **Physical file:** ` McDonnell, R., Breidt, M., and Bülthoff, H. H. (2012). Render me Real? Investigating.pdf`
- **DOI:** 10.1145/2185520.2185587
- **Used in:** `01_introduction.tex` (Motivation, opening paragraph: paraphrase of the paper's own opening sentence, on the difficulty of the render-style decision; Motivation, "This holds for CG characters generally"), `02_related_work.tex` §2.1 (paragraph on render style, appeal, reassurance, and trustworthiness). **No longer used in the Problem Statement** — the §1.2 sentence pairing this with `isenberg2003` was removed 2026-08-04 since `mcdonnell2012` is a perceptual/uncanny-valley study, not NPR-technique literature, and Nidanur asked that paragraph to cite NPR papers only.
- **CORRECTED 2026-08-09 (`02_related_work.tex` §2.1):** the sentence previously said participants were exposed to "six distinct styles" and that photorealistic rendering scored significantly worse than stylised conditions on eeriness and appeal, with NPR styles "consistently" doing better. Both were wrong: the paper used **11** render styles (10 in the stills block); "six" is the number of statistically distinct realism levels a post-hoc analysis grouped those styles into. And the actual finding is the valley-shaped pattern described in the Summary below — both the most abstract and the most realistic styles scored best on appeal, reassurance, and trustworthiness, with the mid-realism styles (including one Toon/NPR style, ToonBare) scoring worst. Corrected sentence: "Participants were exposed to video stimuli of the same animated character, rendered across eleven distinct styles spanning the range from photorealistic to fully stylised. The results showed a valley-shaped pattern across appeal, reassurance, and trustworthiness alike: styles at the most abstract and the most realistic ends of the range scored significantly higher on all three measures than styles in the mid-realism range."
- **Summary:** Two motion-captured actors were rendered in 11 styles spanning a continuum from highly abstract (ToonPencil, flat outlines, no shading) to near-photorealistic (HumanHQ2, ray-traced lighting, subsurface scattering, dynamic wrinkle maps). Participants rated each style on appeal, reassurance, familiarity, friendliness, and trustworthiness. Both the most abstract and the most realistic styles received the highest appeal and trustworthiness ratings, with mid-range styles receiving significantly lower ratings on both measures, directly replicating the dip Mori's Uncanny Valley predicts. A second experiment showed that realistic styles tolerate motion artefacts far worse than stylised ones, and a third found that render style does not bias implicit lie-detection judgements despite shaping explicit trust ratings.
- **Relevance:** Provides direct empirical evidence that a non-linear (valley-shaped) relationship between render style and both appeal and trustworthiness exists for animated virtual humans, and that stylised rendering does not carry a trust penalty relative to photorealistic rendering. Grounds the Motivation section's claim that near-realism can undermine trust, and grounds the Problem Statement's characterisation of prior controlled rendering studies as relying on custom, fully authored render pipelines rather than a closed production SDK.
- **Opening-sentence paraphrase (2026-08-01):** The paper's own first sentence reads: "Choosing an appropriate rendering style for virtual humans in movies, games, and other domains can be a challenging task." This is paraphrased (not quoted) as the closing sentences of the Introduction's opening paragraph: "This leads to several design concerns with consequences across film, games, and other domains where synthetic humans appear. One of the most difficult is how realistically or abstractly such a participant should be rendered~\cite{mcdonnell2012}. This tension between realism and abstraction is the starting point for the work presented in this thesis." Restructured into a different sentence architecture (split across two sentences, with an embedded WH-question as the subject of the second), and deliberately uses "synthetic humans" rather than the source's own "virtual humans" term to keep the paraphrase in the thesis's own established vocabulary rather than echoing the source's title term.

```bibtex
@inproceedings{mcdonnell2012,
  author    = {McDonnell, Rachel and Breidt, Martin and B{\"u}lthoff, Heinrich H.},
  title     = {Render Me Real? {I}nvestigating the Effect of Render Style on the Perception of Animated Virtual Humans},
  booktitle = {ACM SIGGRAPH 2012 Papers},
  year      = {2012},
  pages     = {91:1--91:11},
  doi       = {10.1145/2185520.2185587},
  publisher = {ACM},
}
```

### `macdorman2006`
- **Physical file:** `MacDorman2006AndroidScience.pdf` (42 pages)
- **Used in:** `02_related_work.tex` §2.1, paragraph on androids as controllable research stimuli.
- **Summary:** Argues that androids (robots built to be indistinguishable from humans in appearance and behaviour) provide a uniquely controllable experimental apparatus for cognitive and social science research, since their human-likeness can be positioned precisely along a continuum in a way a human confederate cannot.
- **Confirmed excerpt:** p.~297 abstract: "The development of robots that closely resemble human beings can contribute to cognitive research. An android provides an experimental apparatus that has the potential to be controlled more precisely than any human actor." p.~298: android defined as "an artificial system designed with the ultimate goal of being indistinguishable from humans in its external appearance and behavior" (MacDorman & Ishiguro, 2005).
- **REMOVED CLAIMS (2026-08-09):** two claims previously attributed to this paper were removed from `02_related_work.tex` §2.1 after a full-text search (`pdftotext` + grep across all 42 pages) found no support:
  1. "They proposed semantic differential instruments to quantify eeriness and strangeness as measurable affective dimensions" — zero hits for "semantic differential" anywhere in the paper. This methodological contribution actually belongs to `ho2010` (Ho & MacDorman 2010's validated two-subscale eeriness instrument), already correctly cited for this in §2.2.
  2. "They identified the mechanism underlying the valley effect as categorical perception... When an android occupies an ambiguous position between the human and nonhuman categories, this produces a conflict in the human brain" — zero hits for "categorical perception" anywhere in the paper's body text (the only "categorical" match is an unrelated 1997 reference in the bibliography). No source for this specific mechanistic claim was located; it was not replaced with an alternative citation, since none has been verified. The surrounding sentence was rewritten to instead draw on `mori1970` (already cited earlier in the same section), which does support the general point that ambiguous human-likeness sits in the region of steepest comfort drop.

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
- **Used in:** `01_introduction.tex` (Problem Statement: "Likewise, classical NPR techniques are typically demonstrated in rendering environments where developers have direct control over rendering operations and asset creation~\cite{isenberg2003}." — revised 2026-08-04, no longer paired with `mcdonnell2012`); `02_related_work.tex` §2.3 (silhouette-rendering paragraph, added 2026-08-11 — see cited sentence and excerpt below); also used repeatedly in `04_methodology.tex` (V1 inverted hull / shell method design rationale, image-space/object-space/hybrid classification), not re-verified as part of this update.
- **Summary:** A developer-facing survey and decision guide for silhouette detection algorithms on polygonal models, classifying methods as image-space (operate on rendered buffers such as the z-buffer or normal buffer), object-space (operate on the mesh directly), or hybrid (both, requiring two or more rendering passes). Table 1 gives requirement-to-algorithm recommendations. The example algorithms throughout (Figures 1-2) are demonstrated on simple custom test geometry (a nut, a cross) built specifically to illustrate the technique, not production or captured assets.
- **Relevance:** Supports the Problem Statement's claim that classical NPR technique papers are typically demonstrated in rendering environments where the developer has direct control over rendering operations (inserting extra passes, reading/writing the z-buffer and normal buffer directly) and over asset creation (custom test geometry built for the demonstration). This grounds the technical gap: production avatar SDKs do not offer this level of pipeline or asset control.
- **Verified excerpt (2026-08-04):** p.~28, "This article provides a guideline for developers who need to choose one of these algorithms for his or her application." p.~30, "Hybrid algorithms are characterized by operations in object space that are followed by rendering the modified polygons in a more or less ordinary way using the z-buffer. This usually requires two or more rendering passes." Figures 1-2 (pp.~29-30) show the surveyed algorithms applied to a simple nut model and a cross-shaped model, both evidently built as test geometry rather than adapted from a production or photogrammetric source.
- **CORRECTED 2026-08-11 (`02_related_work.tex` §2.3):** an earlier draft attributed the paraphrase "geometry-based methods are robust and distance-independent but structurally incapable of detecting internal surface detail" to this paper. On rereading the full PDF, no sentence stating "robust and distance-independent" was found, and the paper's real classification is image-space/object-space/hybrid, not a "geometry-based" category. The corrected sentence instead uses the paper's own definitional framework, its explicit distinction between silhouette edges (an object's outer boundary) and feature lines (creases, borders, self-intersections, i.e.\ interior detail). This framing is directly supported by the paper's terminology section.
- **Cited sentence (new, §2.3):** "Moreover, Isenberg et al.\ provided a systematic survey of silhouette detection algorithms. They distinguish silhouette edges from feature lines such as creases, borders, and self-intersections~\cite{isenberg2003}."
- **Verified excerpt (2026-08-11):** p.~28-29, the paper defines silhouette edges as marking the outer boundary of an object as seen from the current viewpoint, and separately defines feature lines (creases, borders, self-intersections) as a distinct category of interior edges that a silhouette-only algorithm does not detect. Confirmed against `Isenberg_2003_ADG.pdf` in full, not a secondary paraphrase.

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
- **Physical file:** `lake et al Stylized rendering.pdf` (also present, encrypted, as `npar2000_lake_et_al.pdf`)
- **Used in:** `02_related_work.tex` §2.3 (toon-shading definition, corrected 2026-08-11); `04_methodology.tex` (V2 toon shading design rationale and formula, two citations)
- **CORRECTED 2026-08-11 (`02_related_work.tex` §2.3):** an earlier draft attributed an "inverted hull" outline technique to this paper ("expands back-facing polygons along vertex normals by a small offset, creating a slightly enlarged shell of the mesh"). A full read of the primary PDF found no such description anywhere in the paper. Lake et al.\ describe silhouette edge detection (SED) via front/back-facing polygon classification, not backface-normal expansion, and the paper's own text states that outline width is measured in screen pixels and therefore varies with distance, directly contradicting the "remains consistent regardless of camera distance" claim that had been attached to it. The inverted hull citation was replaced with `raskar1999`, the paper that actually describes that mechanism (see below). `lake2000` was kept for a claim it does support: §3.1 "Cartoon Shading" describes basic toon shading as quantising the diffuse lighting term into a small texture (1-2 texels) to produce hard-edged shading bands, which matches the corrected thesis sentence.
- **Cited sentence (new, §2.3):** "Toon shading is one strand of this tradition. It quantises the continuous diffuse lighting term into a small number of discrete bands~\cite{lake2000}."
- **Verified excerpt (2026-08-11):** §3.1 "Cartoon Shading" describes computing a 1D lighting value and using it to index a small 1-2 texel gradient texture, producing a small number of discrete, hard-edged tonal bands rather than a continuous Lambertian ramp.

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

### `raskar1999`
- **Physical file:** `raskar_cohen_real.pdf` (author's own copy, downloaded from `web.media.mit.edu/~raskar/UNC/NPR/sil-i3d99.pdf`; a Semantic-Scholar-cached PDF found first, `raskar_cohen_1999.pdf`, turned out to be a third-party student summary slide deck by "Melanie Coggan," not the primary paper, and was discarded)
- **DOI:** 10.1145/300523.300539
- **Used in:** `02_related_work.tex` §2.3 (silhouette-rendering paragraph, added 2026-08-11)
- **Summary:** Introduces two related image-precision silhouette techniques computed by rendering the mesh twice from the same viewpoint. §3.2 "Translated Back-facing Polygons" draws front-facing polygons normally, then draws back-facing polygons translated towards the camera by a fixed or depth-scaled offset, so that a rim of the translated back-facing geometry protrudes in front of the occluding front-facing surface and forms the visible outline. §3.3 additionally describes a view-dependent variant that "fattens" polygon edges outward in proportion to distance from the camera.
- **Relevance:** Provides the verified, primary-source-grounded description of the two-render back-facing-polygon silhouette technique that an earlier thesis draft had incorrectly attributed to `lake2000`. This paper is cited by Isenberg et al.\ (`isenberg2003`), whose Figure 3 ("Enlargement of a back-facing polygon to achieve wide silhouette lines") is credited "Courtesy of Ramesh Raskar and Michael Cohen (c) 1999 ACM," which is how this source was located.
- **Cited sentence:** "Raskar and Cohen proposed processing the mesh twice from the same viewpoint~\cite{raskar1999}. Initially, it draws the front-facing polygons in the usual way. The back-facing polygons are then rendered and translated towards the camera."
- **Verified excerpt (2026-08-11):** §3.2 "Translated Back-facing Polygons": the front-facing polygons are rendered as normal, then the back-facing polygons are rendered a second time, translated toward the viewer by a fixed amount $t$ or a depth-scaled amount $k \cdot z$, so that the translated back-facing geometry is visible in front of the front-facing surface along silhouette boundaries. Read in full, not from a secondary summary.

```bibtex
@inproceedings{raskar1999,
  author    = {Raskar, Ramesh and Cohen, Michael},
  title     = {Image Precision Silhouette Edges},
  booktitle = {Proceedings of the 1999 Symposium on Interactive 3D Graphics},
  year      = {1999},
  pages     = {135--140},
  doi       = {10.1145/300523.300539},
  publisher = {ACM},
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
  4. `thesis/chapters/01_introduction.tex` §Motivation — new usage (2026-08-01), grounding the claim that avatar/agent design choice (human-like appearance and behaviour) shapes trust
- **Introduction usage — cited sentence (2026-08-01):** "This design choice can be categorised along a fidelity axis. Additionally, human-like appearance and behaviour have been shown to enhance a user's compliance and confidence in an avatar~\cite{alipour2025}." ("artificial agent" narrowed to "avatar" for consistency with the rest of the paragraph, per Nidanur's request — Alipour et al.'s own Introduction lists avatars as one of the agent types their claim covers.)
- **Introduction usage — supporting passage (p.~3, Introduction, direct quote):** "A key strategy followed by developers and designers is to create agents that might instigate trust by being more human-like in behavior and appearance. Indeed, research suggests that anthropomorphic features of agents (e.g., human voice, human-like appearance, human-like responses; Følstad \& Brandtzæg, 2017) can enhance users' compliance and trust in agents (Lee \& Nass, 2010; Natarajan \& Gombolay, 2020)." Read directly from \texttt{Articles/trust/Alipor\_Would You Rely on an Eerie Agent?.pdf}, pp.~3--4 (title page through Figure 1 discussion), 2026-08-01. Note: Alipour et al.\ are here synthesising prior literature (Følstad \& Brandtzæg 2017; Lee \& Nass 2010; Natarajan \& Gombolay 2020) in their own Introduction as background framing, not reporting this specific claim as their own novel empirical finding — citing Alipour et al.\ for this synthesis statement is standard practice, consistent with how their Introduction itself frames it.

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
- **Used in:** `01_introduction.tex` §1.2 Problem Statement (paired with `zell2015`), and separately `04_methodology.tex` §4.3 NPR Technique Design (paired with `zell2015`, different wording — see that section's own log entry).
- **Exact cited sentence (01_introduction.tex, corrected 2026-08-08):** "This is because stronger abstraction typically reduces the perceived intensity of facial expressions, even where basic recognition is preserved~\cite{zell2015,wallraven2008}." **CORRECTION NOTE:** the previous wording said "reduces the legibility of interior features such as facial expressions," but this paper explicitly found shape blurring does *not* significantly affect recognition, only intensity/sincerity judgments. "Legibility" maps most naturally to recognition, which this source says is preserved, not reduced. Wording corrected to match the actual finding.
- **Original excerpt supporting this claim:** §4 Summary, p. 23:19 — "In addition, in Experiment 2, we found clear effects of shape blurring on both intensity and sincerity judgments. This demonstrates that, even though reduced shape information does not affect recognition, it does influence the perceived quality of the expression."

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
- **Used in:** `01_introduction.tex` §1.2 Problem Statement (paired with `wallraven2008`), and separately `04_methodology.tex` §4.3 NPR Technique Design (paired with `wallraven2008`, different wording — see that section's own log entry).
- **Exact cited sentence (01_introduction.tex, corrected 2026-08-08):** "This is because stronger abstraction typically reduces the perceived intensity of facial expressions, even where basic recognition is preserved~\cite{zell2015,wallraven2008}." **CORRECTION NOTE:** the previous wording said "reduces the legibility of interior features such as facial expressions," but this paper measures perceived *intensity*, not legibility/recognisability. Wording corrected to match the actual finding.
- **Original excerpt supporting this claim:** Main Findings list, p. 184:2 — "The perceived intensity of expressions decreases with realism of shape, but is nearly independent of material stylization." (Interpretation: as shape stylisation increases and realism decreases, perceived intensity also decreases.)

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

---

## Added in Session: V4 Sobel and V4.2 Gaussian Prefiltered Sobel (2026-07-14)

### `gonzalez2018` — additional usage in V4 and V4.2

**V4, §Sobel Edge Detection, paragraph 1**
- Claim: Sobel incorporates spatial averaging to suppress noise
- Supporting passage (p.719): "It can be demonstrated… that using a 2 in the center location provides image smoothing." and "The fact that the Sobel kernels have better noise-suppression (smoothing) characteristics makes them preferable because… noise suppression is an important issue when dealing with derivatives."
- Used as: `~\cite{gonzalez2018}` on the opening sentence (removed the previously incorrect `kong2023` co-citation)

**V4, §Sobel Edge Detection, paragraph 2 — equation**
- Claim: gradient magnitude formula $M_S = \sqrt{g_x^2 + g_y^2}$
- Supporting passage (p.716, Eq.10-17): $M(x,y) = \|\nabla f(x,y)\| = \sqrt{g_x^2(x,y) + g_y^2(x,y)}$
- Sobel-specific partials (p.719, Eqs.10-24, 10-25): $g_x = (z_7 + 2z_8 + z_9) - (z_1 + 2z_2 + z_3)$, $g_y = (z_3 + 2z_6 + z_9) - (z_1 + 2z_4 + z_7)$
- Used as: second `~\cite{gonzalez2018}` in paragraph 2, on the equation prose sentence

**V4.2, §Gaussian Prefiltered Sobel, paragraph 1 — Gaussian domain smoothness**
- Claim: Gaussian is smooth in both spatial and frequency domains, avoiding ringing artefacts
- Supporting passage (p.725): "the Gaussian function is smooth in both the spatial and frequency domains (see Section 4.8), and is thus less likely to introduce artifacts (e.g., ringing) not present in the original image"
- Used as: `~\cite{marr1980,gonzalez2018}` combined on the Marr-Hildreth sentence

### `marr1980` — additional usage in V4.2

**V4.2, §Gaussian Prefiltered Sobel, paragraph 1**
- Claim: Marr and Hildreth argued that gradient operators should be preceded by Gaussian filtering
- Supporting passage (Gonzalez p.724, summarising Marr and Hildreth): "Marr and Hildreth argued (1) that intensity changes are not independent of image scale, implying that their detection requires using operators of different sizes; and (2) that a sudden intensity change will give rise to a peak or trough in the first derivative"
- Used as: `~\cite{marr1980,gonzalez2018}` combined on the argument sentence

### `canny1986` — additional usage in V4.2

**V4.2, §Gaussian Prefiltered Sobel, paragraph 1**
- Claim: Canny showed Gaussian pre-smoothing is optimal under additive noise
- Supporting passage (Gonzalez p.729–730): "using numerical optimization with 1-D step edges corrupted by additive white Gaussian noise led to the conclusion that a good approximation to the optimal step edge detector is the first derivative of a Gaussian"
- Supporting passage (Gonzalez p.732): "Summarizing, the Canny edge detection algorithm consists of the following steps: 1. Smooth the input image with a Gaussian filter."
- Used as: `~\cite{canny1986}` on the Canny confirmation sentence

---

### `roshaan2026` — AHEAD: Adaptive Hierarchical Edge Detection

**V5, §Hierarchical Edge Detection, paragraph 1**
- Claim 1: Hierarchical edge detection fuses multiple complementary cues into a unified edge representation
  - Supporting passage (AHEAD Abstract): "The suggested framework uses a Max-pooling fusion technique to integrate the scene after breaking it down into separate Silhouette, Structure and Texture layers."
  - Supporting passage (AHEAD Contributions): "We introduce a novel three layer hierarchy (Silhouette, Structure and Texture)… We demonstrate how stratifying edges based on their semantic role allows for precise control over image composition."
- Claim 2 (implicit, sentence 5): combining independent responses produces a more complete boundary representation than any single detector
  - Supporting passage (AHEAD Introduction): "use of any one of these solely as a single pass filter results in subpar edge detection"
  - Supporting passage (AHEAD Abstract): "This method preserves edge integrity better than conventional linear averaging of the single-pass filters."
- Full reference: Roshaan, M. K. L. (2026). AHEAD: Adaptive hierarchical edge detection for real-time artistic stylization. Research Square preprint, Article rs-8849147/v1. February 2026.
- DOI: None (preprint). URL: https://www.researchsquare.com/article/rs-8849147/v1
- Physical PDF verified: `Adaptive Hierarchical Edge Detection.pdf` in Articles folder
- Used as: `~\cite{roshaan2026}` on the opening sentence of V5 paragraph 1

---

---

## Added in Session: Related Work Chapter Expansion (2026-07-25)

### `mcdonnell2009`
- **Full title:** Investigating the Role of Body Shape on the Perception of Emotion
- **Authors:** Rachel McDonnell, Sören Jörg, Jennifer McHugh, Fiona N. Newell, Carol O'Sullivan
- **Journal:** ACM Transactions on Applied Perception, Vol. 6, No. 3, Article 14
- **Year:** 2009
- **DOI:** 10.1145/1577755.1577757
- **Physical PDF:** `McDonnell09_HappyZombies.pdf` in Articles folder — verified pages 1–3
- **Used in:** `02_related_work.tex` §Uncanny Valley in Virtual Characters, paragraph 2
- **Cited sentence:** "A companion study by the same group further demonstrated that the perception of emotional actions portrayed by animated characters is largely independent of avatar body style, remaining consistent across photorealistic, cartoon, and stylised skeletal representations~\cite{mcdonnell2009}."
- **What the paper argues:** Participants were shown motion-captured animations of 6 emotions performed on 5 body types (realistic CG, low-resolution CG, cartoon, mannequin, zombie). Emotion recognition accuracy did not differ across body types; all five conditions achieved comparable hit rates for all 6 emotions. Removing all body form (point-light display) reduced perceived intensity but not recognition. Biological motion carries the emotional signal; rendering style has no effect on whether the emotion is communicated, only on perceived expressiveness.
- **Relevance:** Supports the C3 design assumption that NPR stylisation will not impair the advisor's communicative clarity during the user study. Eeriness and emotional legibility operate on separate perceptual channels.

```bibtex
@article{mcdonnell2009,
  author    = {McDonnell, R. and J\"{o}rg, S. and McHugh, J. and Newell, F. N. and O'Sullivan, C.},
  title     = {Investigating the Role of Body Shape on the Perception of Emotion},
  journal   = {{ACM} Transactions on Applied Perception},
  volume    = {6},
  number    = {3},
  articleno = {14},
  year      = {2009},
  doi       = {10.1145/1577755.1577757},
}
```

---

### `dill2012`
- **Full title:** Evaluation of the Uncanny Valley in CG Characters
- **Authors:** V. Dill, L. M. Flach, R. Hocevar, C. Lykawka, S. R. Musse, M. S. Pinho
- **Venue:** Intelligent Virtual Agents (IVA 2012), Lecture Notes in AI Vol. 7502, pp. 511–513. Springer.
- **Year:** 2012
- **DOI:** Proceedings-level only: 10.1007/978-3-642-33197-8 (no paper-level DOI confirmed for this poster)
- **Physical PDF:** Not in Articles folder. Short poster paper; proceedings available via Springer.
- **Used in:** `02_related_work.tex` §Uncanny Valley in Virtual Characters, paragraph 3
- **Cited sentence:** "Dill et al.\ validated the uncanny valley response specifically for CG characters drawn from contemporary commercial films and games, finding that familiarity ratings followed Mori's predicted curve, with the strongest negative response in the near-human range; motion amplified this effect for every stimulus tested~\cite{dill2012}."
- **What the paper argues:** Participants rated CG characters from commercial games and films on familiarity and eeriness. Familiarity ratings reproduced Mori's predicted non-linear curve, with the strongest negative response in the near-human range. Adding motion amplified the uncanny valley effect for every stimulus. Confirms the valley is not restricted to physical robots or androids but extends to digital characters in popular media.
- **Relevance:** Confirms that the uncanny valley problem is relevant to the CG avatar context of this thesis, not merely to robotics.

```bibtex
@inproceedings{dill2012,
  author    = {Dill, V. and Flach, L. M. and Hocevar, R. and Lykawka, C. and Musse, S. R. and Pinho, M. S.},
  title     = {Evaluation of the Uncanny Valley in {CG} Characters},
  booktitle = {Intelligent Virtual Agents: 12th International Conference, {IVA} 2012},
  series    = {Lecture Notes in Artificial Intelligence},
  volume    = {7502},
  pages     = {511--513},
  publisher = {Springer},
  year      = {2012},
  note      = {Poster paper. Proceedings DOI: 10.1007/978-3-642-33197-8},
}
```

---

### `tao2025`
- **Full title:** Impact of Virtual Avatar Appearance Realism on Perceptual Interaction Experience: A Network Meta-Analysis
- **Authors:** Z. Tao, Y. Liu, J. Qiu, S. Li
- **Journal:** Frontiers in Psychology, Vol. 16, Article 1624975
- **Year:** 2025
- **DOI:** 10.3389/fpsyg.2025.1624975
- **Physical PDF:** Not in Articles folder; open access at Frontiers DOI.
- **Used in:** `02_related_work.tex` §Uncanny Valley in Virtual Characters, paragraph 3
- **Cited sentence:** "A network meta-analysis by Tao et al., pooling 13 independent studies and 2,343 participants, subsequently quantified these effects across three realism levels: avatars at medium realism produced significantly higher eeriness than those at both abstract and photorealistic levels, while trustworthiness scaled monotonically with realism, reaching its highest values for photorealistic avatars~\cite{tao2025}."
- **What the paper argues:** Network meta-analysis of 13 studies (2,343 participants) on avatar appearance realism and perceptual interaction experience. Three realism levels compared: abstract, medium, and photorealistic. Eeriness was highest at medium realism, consistent with Mori's valley shape. Trustworthiness scaled monotonically with realism, with photorealistic avatars rated highest. This dissociation (eeriness non-monotonic, trust monotonic) directly establishes the opposing pressures the user study hypotheses address.
- **Relevance:** Provides quantitative meta-analytic evidence for both the uncanny valley shape and the trust-realism relationship. Directly motivates H1 and H2 by establishing that lowering realism (through NPR) can reduce eeriness without necessarily collapsing trust.

```bibtex
@article{tao2025,
  author  = {Tao, Z. and Liu, Y. and Qiu, J. and Li, S.},
  title   = {Impact of Virtual Avatar Appearance Realism on Perceptual Interaction Experience: A Network Meta-Analysis},
  journal = {Frontiers in Psychology},
  volume  = {16},
  pages   = {1624975},
  year    = {2025},
  doi     = {10.3389/fpsyg.2025.1624975},
}
```

---

### `kuffner2024`
- **Full title:** Effects of Realism and Representation on Self-Embodied Avatars in Immersive Virtual Environments
- **Authors:** R. Kuffner dos Anjos, J. Madeiras Pereira
- **Venue:** arXiv preprint arXiv:2405.02672 [cs.HC]
- **Year:** 2024
- **arXiv:** https://arxiv.org/abs/2405.02672
- **Physical PDF:** Available in Articles folder: `Effects of Realism and Representation on Self-Embodied Avatars in Immersive Virtual Environments.pdf`
- **Used in:** `02_related_work.tex` §Uncanny Valley in Virtual Characters, paragraph 3
- **Cited sentence:** "Kuffner dos Anjos and Pereira further observed that realistic mesh avatars in third-person VR perspective produced pronounced uncanny effects when animation quality was constrained by sensor resolution, while abstract representations avoided the valley entirely in the same viewing condition, consistent with the escape by design principle Mori originally proposed~\cite{kuffner2024}."
- **What the paper argues:** Compares self-embodied avatar representations (realistic mesh, low-poly, stick figure, point cloud) across first- and third-person perspectives in immersive VR. Realistic avatars in third-person produced the strongest uncanny valley responses when tracking fidelity was limited. Abstract representations consistently avoided valley responses regardless of perspective. Confirms the "escape by abstraction" as a reliable strategy distinct from improving animation quality.
- **Relevance:** Provides a VR-specific empirical confirmation that abstract avatar representations avoid the uncanny valley, supporting the rationale for NPR stylisation in the thesis.

```bibtex
@misc{kuffner2024,
  author       = {Kuffner dos Anjos, R. and Madeiras Pereira, J.},
  title        = {Effects of Realism and Representation on Self-Embodied Avatars in Immersive Virtual Environments},
  howpublished = {arXiv preprint},
  year         = {2024},
  note         = {arXiv:2405.02672},
}
```

---

### `alimardani2024`
- **Full title:** Effect of a Virtual Agent's Appearance and Voice on Uncanny Valley and Trust in Human-Agent Collaboration
- **Authors:** M. Alimardani, R. de Roode, J. Vaitonyté, M. M. Louwerse
- **Venue:** Proceedings of the 24th ACM International Conference on Intelligent Virtual Agents (IVA '24), Article 5
- **Year:** 2024
- **DOI:** 10.1145/3652988.3673970
- **Physical PDF:** Not in Articles folder; available via ACM DL at DOI.
- **Used in:** `02_related_work.tex` §Trust and Credibility in Virtual Agents, paragraph on appearance–voice factorial
- **Cited sentence:** "Alimardani et al.\ isolated the contribution of visual appearance from voice quality in a $2 \times 2$ factorial study, finding that mismatches between the two modalities elevated eeriness yet produced no significant change in the rate at which participants adopted the agent's recommendations~\cite{alimardani2024}."
- **What the paper argues:** 2×2 factorial design crossing avatar appearance (photorealistic vs. stylised) with voice (natural vs. synthetic) in a collaboration task. Appearance–voice mismatches significantly elevated eeriness. Despite elevated eeriness from mismatches, no significant difference in recommendation adoption rate was found. Competence perception, not eeriness, drove behavioural trust. Aligns with Mayer et al. ABI model: when competence is held constant, perceptual eeriness does not alter trust-based behaviour.
- **Relevance:** Supports H2 (NPR does not reduce trust behaviourally). Demonstrates the dissociation between perceptual eeriness and behavioural trust that the user study is designed to measure.

```bibtex
@inproceedings{alimardani2024,
  author    = {Alimardani, M. and de Roode, R. and Vaitonyt\.{e}, J. and Louwerse, M. M.},
  title     = {Effect of a Virtual Agent's Appearance and Voice on Uncanny Valley and Trust in Human-Agent Collaboration},
  booktitle = {Proceedings of the 24th {ACM} International Conference on Intelligent Virtual Agents},
  series    = {{IVA} '24},
  articleno = {5},
  publisher = {ACM},
  year      = {2024},
  doi       = {10.1145/3652988.3673970},
}
```

---

### `dubosc2025`
- **Full title:** Effect of Avatar Stylization and Facial Expression Intensity in Virtual Interactions
- **Authors:** C. Dubosc, G. Gorisse, T. Lefrou, S. Richir, O. Christmann
- **Journal:** Virtual Reality (Springer), published online 8 October 2025
- **Year:** 2025
- **DOI:** 10.1007/s10055-025-01238-6
- **Physical PDF:** Not in Articles folder; available via Springer DOI.
- **Used in:** `02_related_work.tex` §Trust and Credibility in Virtual Agents, paragraph on stylisation and trust convergence
- **Cited sentence:** "Convergent evidence comes from Dubosc et al., who found in a VR face-to-face interaction study that stylised avatars produced significantly lower eeriness and significantly higher trustworthiness ratings than photorealistic avatars, with no interaction between stylisation level and facial expression intensity~\cite{dubosc2025}."
- **What the paper argues:** VR face-to-face interaction study crossing avatar stylisation level (photorealistic vs. stylised) with facial expression intensity. Stylised avatars produced significantly lower eeriness and significantly higher trustworthiness ratings than photorealistic avatars. No significant interaction between stylisation and expression intensity, meaning the stylisation effect on trust was consistent across expression levels. Directly contradicts the assumption that photorealism maximises trustworthiness in interactive avatar contexts.
- **Relevance:** Provides the strongest direct empirical evidence supporting H1 (NPR lowers eeriness) and H2 (NPR does not reduce trust). Also confirms that facial expression intensity does not interact with stylisation level, validating the study's controlled animation protocol.

```bibtex
@article{dubosc2025,
  author  = {Dubosc, C. and Gorisse, G. and Lefrou, T. and Richir, S. and Christmann, O.},
  title   = {Effect of Avatar Stylization and Facial Expression Intensity in Virtual Interactions},
  journal = {Virtual Reality},
  year    = {2025},
  doi     = {10.1007/s10055-025-01238-6},
  note    = {Published online 8 October 2025, Springer Nature.},
}
```

---

### `cihodaru2025`
- **Full title:** The Uncanny Valley Effect in Embodied Conversational Agents: A Critical Systematic Review of Attractiveness, Anthropomorphism, and Uncanniness
- **Authors:** Ş. Cihodaru-Ştefanache, I. R. Podina
- **Journal:** Frontiers in Psychology, Vol. 16, Article 1625984
- **Year:** 2025
- **DOI:** 10.3389/fpsyg.2025.1625984
- **Physical PDF:** Not in Articles folder; open access at Frontiers DOI.
- **Used in:** `02_related_work.tex` §Trust and Credibility in Virtual Agents, closing paragraph of trust section; also `01_introduction.tex` §Motivation, opening paragraph (second, distinct usage)
- **Cited sentence (Related Work):** "Cihodaru-\c{S}tefanache and Podina's systematic review of 29 empirical studies on embodied conversational agents further identified consistent stylisation across all visual features as the most reliably recommended design strategy for avoiding uncanny valley responses, alongside accurate lip synchronisation and consistency between visual and voice realism levels~\cite{cihodaru2025}."
- **What the paper argues:** Critical systematic review of 29 empirical studies on the uncanny valley effect in embodied conversational agents (ECAs). Synthesises findings on attractiveness, anthropomorphism, and uncanniness. Most reliably recommended design strategies: consistent stylisation across all visual features (avoiding realism mismatches), accurate lip synchronisation, and cross-modal consistency between visual and voice realism. Highlights that inconsistency across features — not high realism per se — is the primary driver of uncanny responses in ECAs.
- **Relevance (Related Work):** Confirms that the design principle of consistent NPR stylisation across the avatar's appearance (the approach taken in C3) is the empirically supported strategy for avoiding uncanny valley responses.
- **Note (2026-08-01):** An earlier draft of the Introduction's opening paragraph also used this review's "Technology familiarity: more experience with virtual agents attenuated UVE responses" finding (from the "User characteristics identified as moderators" subsection) as a second, distinct usage. That draft was superseded — the final opening paragraph focuses on avatars rather than AI/familiarity framing and does not currently cite this finding. Kept here as a verified, ready-to-use finding if a familiarity/exposure argument is reintroduced later.

```bibtex
@article{cihodaru2025,
  author  = {Cihodaru-{\c{S}}tefanache, {\c{S}}. and Podina, I. R.},
  title   = {The Uncanny Valley Effect in Embodied Conversational Agents: A Critical Systematic Review of Attractiveness, Anthropomorphism, and Uncanniness},
  journal = {Frontiers in Psychology},
  volume  = {16},
  pages   = {1625984},
  year    = {2025},
  doi     = {10.3389/fpsyg.2025.1625984},
}
```

---

### `kumar2019`
- **Full title:** A Comprehensive Survey on Non-Photorealistic Rendering and Benchmark Developments for Image Abstraction and Stylization
- **Authors:** T. Kumar, B. G. Poornima
- **Journal:** Iran Journal of Computer Science, 2019
- **Year:** 2019
- **DOI:** 10.1007/s42044-019-00034-1
- **Physical PDF:** Not confirmed in Articles folder; available via Springer DOI.
- **Used in:** `02_related_work.tex` §Non-Photorealistic Rendering Techniques, opening paragraph
- **Cited sentence:** "Kumar and Poornima provide a comprehensive survey of this design space, classifying methods into five families: stroke-based rendering, colour image analogy, region-based rendering, image filtering abstraction, and direct stylisation~\cite{kumar2019}."
- **What the paper argues:** Comprehensive NPR survey classifying techniques into five families: (1) stroke-based rendering (hatching, stippling), (2) colour image analogy, (3) region-based rendering (segmentation and fill), (4) image filtering abstraction (Kuwahara, Gaussian, edge-based), and (5) direct stylisation (toon, cel, XToon). Provides benchmark comparisons and evaluation metrics for each family. Covers both artistic intent and computational cost tradeoffs.
- **Relevance:** Provides the taxonomic framework used to situate the thesis techniques within the broader NPR design space. The five-family classification is used in the Related Work chapter to organise the NPR technique survey.

```bibtex
@article{kumar2019,
  author  = {Kumar, T. and Poornima, B. G.},
  title   = {A Comprehensive Survey on Non-Photorealistic Rendering and Benchmark Developments for Image Abstraction and Stylization},
  journal = {Iran Journal of Computer Science},
  year    = {2019},
  doi     = {10.1007/s42044-019-00034-1},
}
```

---

### `petikam2021`
- **Full title:** Shading Rig: Dynamic Art-Directable Stylised Shading for 3D Characters
- **Authors:** L. Petikam, K. Anjyo, T. Rhee
- **Journal:** ACM Transactions on Graphics, Vol. 40, No. 5, Article 205
- **Year:** 2021
- **DOI:** 10.1145/3461696
- **Physical PDF:** Not confirmed in Articles folder; available via ACM DL DOI.
- **REMOVED FROM THESIS 2026-08-11:** dropped from `02_related_work.tex` §2.3 during the same reorganisation that removed `gooch1998` (toon-shading/silhouette-rendering narrative rewritten around Kumar and Poornima's taxonomy). Confirmed via full-text grep across `thesis/chapters/*.tex` that `petikam2021` is no longer cited anywhere in the thesis. Entry kept here for reference only; not currently used. This citation was also never confirmed against a physical PDF (see note above), so it should not be reintroduced without first locating and reading the primary source.
- **Used in (historical, no longer current):** `02_related_work.tex` §NPR Techniques — Silhouette and Outline Methods, paragraph on toon shading limitations
- **Cited sentence:** "Petikam et al.\ addressed a related limitation in this style of shading, proposing a shading rig that interpolates between shading states defined at authoring time so that the tonal boundary remains stable as lighting conditions change rather than sliding with the Lambertian angle~\cite{petikam2021}."
- **What the paper argues:** Proposes a shading rig system that allows artists to define target shading appearances at key lighting angles, with interpolation between these defined states during rendering. The core limitation addressed is that Lambertian-based toon quantisation produces a tonal boundary that slides as lighting direction changes, undermining artistic intent. The rig fixes boundary positions relative to authored states. Demonstrated on animated characters in production pipelines.
- **Relevance:** Identifies the tonal boundary instability problem that motivates the lighting-independent toon approach in V1. Provides peer-reviewed context for the design decision to use a fixed quantisation threshold rather than a Lambertian ramp.

```bibtex
@article{petikam2021,
  author    = {Petikam, L. and Anjyo, K. and Rhee, T.},
  title     = {Shading Rig: Dynamic Art-Directable Stylised Shading for {3D} Characters},
  journal   = {{ACM} Transactions on Graphics},
  volume    = {40},
  number    = {5},
  articleno = {205},
  year      = {2021},
  doi       = {10.1145/3461696},
}
```

---

### `kyprianidis2011`
- **Full title:** Image and Video Abstraction by Multi-Scale Anisotropic Kuwahara Filtering
- **Author:** J. E. Kyprianidis
- **Venue:** Proceedings of the 8th International Symposium on Non-Photorealistic Animation and Rendering (NPAR '11), pp. 55–64. ACM.
- **Year:** 2011
- **DOI:** Not confirmed at article level. ISBN: 978-1-4503-0907-3
- **Physical PDF:** `anisotropic_multicale_209.pdf` in Articles/NPR folder — verified pages 1–3
- **Used in:** `02_related_work.tex` §NPR Techniques — Painterly Filtering, paragraph on Kuwahara extensions
- **Cited sentence:** "A multiscale variant of this filter, also by Kyprianidis, propagates orientation estimates and filter outputs through a resolution pyramid, removing artefacts in low-contrast regions while maintaining real-time performance~\cite{kyprianidis2011}."
- **What the paper argues:** Extends the 2009 anisotropic Kuwahara filter with a coarse-to-fine multi-scale pyramid. Orientation estimates from the structure tensor are propagated from coarser to finer scales, avoiding instability in low-contrast regions where the tensor is unreliable. Filter outputs from multiple pyramid levels are blended, removing block artefacts visible in the single-scale version. A stabilised weighting formula replaces α_i = 1/s_i^q with α_i = 1/(ε + s_i)^q to prevent division by near-zero values. Demonstrated on video with temporal coherence.
- **Relevance:** Documents the gap between the isotropic Kuwahara implemented in this thesis (V6) and the state-of-the-art multi-scale anisotropic extension. The multi-scale pyramid requires a separate structure tensor render pass that exceeds the single-pass SDK fragment hook constraint.

```bibtex
@inproceedings{kyprianidis2011,
  author    = {Kyprianidis, J. E.},
  title     = {Image and Video Abstraction by Multi-Scale Anisotropic {Kuwahara} Filtering},
  booktitle = {Proceedings of the 8th International Symposium on Non-Photorealistic Animation and Rendering},
  series    = {{NPAR} '11},
  pages     = {55--64},
  publisher = {ACM},
  year      = {2011},
  isbn      = {978-1-4503-0907-3},
  note      = {Article DOI not confirmed; verified from physical PDF.},
}
```

---

### `wisessing2016`
- **Full title:** Perception of Lighting and Shading for Animated Virtual Characters
- **Authors:** P. Wisessing, J. Dingliana, R. McDonnell
- **Venue:** Proceedings of the ACM Symposium on Applied Perception (SAP 2016)
- **Year:** 2016
- **DOI:** 10.1145/2931002.2931015
- **Physical PDF:** Filename not confirmed in Articles folder; available via ACM DL DOI.
- **Used in:** `02_related_work.tex` §Perceptual Impact of NPR on Avatar Social Reception, paragraph 1
- **Cited sentence:** "Wisessing et al.\ demonstrated that toon shading reduces the perceived intensity of facial emotional expression while leaving recognition accuracy intact, meaning that characters rendered in this style convey the correct emotional content without the perceptual amplification that photorealistic rendering provides~\cite{wisessing2016}."
- **What the paper argues:** Study measuring how lighting and shading style (photorealistic vs. toon/stylised) affect the perceived intensity and recognition of emotional expressions in animated virtual characters. Toon shading reduced the perceived intensity of emotional expressions relative to photorealistic rendering. However, emotion recognition accuracy was not significantly impaired; participants correctly identified the intended emotion at comparable rates. This dissociation (intensity reduced, recognition preserved) establishes that NPR shading affects the scale but not the categorical content of emotional communication.
- **Relevance:** Provides the key perceptual mechanism: NPR reduces perceived emotional intensity but not comprehension accuracy. Combined with mcdonnell2009, this supports the C3 design assumption that the NPR avatar's advisory content will remain communicatively clear.

```bibtex
@inproceedings{wisessing2016,
  author    = {Wisessing, P. and Dingliana, J. and McDonnell, R.},
  title     = {Perception of Lighting and Shading for Animated Virtual Characters},
  booktitle = {Proceedings of the {ACM} Symposium on Applied Perception},
  publisher = {ACM},
  year      = {2016},
  doi       = {10.1145/2931002.2931015},
}
```

---

### `wisessing2020`
- **Full title:** Enlighten Me: Importance of Brightness and Shadow for Character Emotion and Appeal
- **Authors:** P. Wisessing, K. Zibrek, D. W. Cunningham, J. Dingliana, R. McDonnell
- **Journal:** ACM Transactions on Graphics, Vol. 39, No. 3, Article 30
- **Year:** 2020
- **DOI:** 10.1145/3383195
- **Physical PDF:** Not confirmed in Articles folder; available via ACM DL DOI.
- **Used in:** `02_related_work.tex` §Perceptual Impact of NPR on Avatar Social Reception, paragraph 1
- **Cited sentence:** "A follow-up study identified lighting parameters as a further modulator of eeriness: brighter key lighting and lighter shadow regions significantly reduced eeriness and increased appeal for both photorealistic and stylised characters, with a larger absolute reduction for photorealistic rendering, which starts from a higher eeriness baseline~\cite{wisessing2020}."
- **What the paper argues:** Psychophysical study measuring the effect of brightness (key light intensity) and shadow darkness on perceived eeriness, emotion, and appeal in both photorealistic and stylised virtual characters. Brighter key lighting and lighter shadows significantly reduced eeriness and increased appeal. The reduction was larger in absolute terms for photorealistic characters, which start from a higher eeriness baseline. Stylised characters were less affected because their eeriness baseline is already lower.
- **Relevance:** Provides a psychophysical mechanism explaining why NPR stylisation reduces eeriness. Also confirms that the starting eeriness level (high for photorealistic, lower for stylised) drives the magnitude of any lighting-based eeriness reduction, strengthening the rationale for NPR as an eeriness mitigation strategy.

```bibtex
@article{wisessing2020,
  author    = {Wisessing, P. and Zibrek, K. and Cunningham, D. W. and Dingliana, J. and McDonnell, R.},
  title     = {Enlighten Me: Importance of Brightness and Shadow for Character Emotion and Appeal},
  journal   = {{ACM} Transactions on Graphics},
  volume    = {39},
  number    = {3},
  articleno = {30},
  year      = {2020},
  doi       = {10.1145/3383195},
}
```

---

### `roberts1963`
- **Full title:** Machine Perception of Three-Dimensional Solids
- **Author:** L. G. Roberts
- **Venue:** PhD thesis, Massachusetts Institute of Technology. Lincoln Laboratory Report TR-315.
- **Year:** 1963
- **DOI:** None (MIT DSpace and ResearchGate)
- **Physical PDF:** Available at MIT DSpace and ResearchGate; not confirmed in local Articles folder.
- **Used in:** `04_methodology.tex` §V5 Hierarchical Edge Detection, paragraph 1
- **Cited sentence:** "…colour gradients computed using the Roberts Cross operator detect texture boundaries that have no corresponding geometric signal~\cite{roberts1963, gonzalez2018}."
- **What the paper argues:** Roberts' 1963 MIT PhD thesis introduced the Roberts Cross operator, a 2×2 discrete gradient approximation for detecting edges in digital images. The operator applies two diagonal convolution kernels (effectively detecting edges at ±45°) and combines the responses to produce a gradient magnitude. It is among the earliest edge detection operators in computer vision. Gonzalez and Woods (2018) document the mathematical derivation and properties. Roberts Cross is the lightest edge detection operator available: 4 samples per pixel, no Gaussian pre-smoothing, extremely low computational cost.
- **Relevance:** Cited as the original source for the Roberts Cross operator used as the colour edge detection component in V5 (Hierarchical Edge Detection). The 4-sample cost makes it feasible as one component within a multi-cue technique that must remain within the Quest performance budget.

```bibtex
@phdthesis{roberts1963,
  author = {Roberts, L. G.},
  title  = {Machine Perception of Three-Dimensional Solids},
  school = {Massachusetts Institute of Technology},
  year   = {1963},
  note   = {Lincoln Laboratory Report TR-315. Available via MIT DSpace and ResearchGate.},
}
```

---

> **Instructions:** Before submission, open each DOI link, confirm title and authors match what is in `references.bib`, and tick it off. For entries without a DOI, check the ResearchGate or ACM DL link listed above.

---

### `demsar2006` — Statistical Comparisons of Classifiers over Multiple Data Sets

**§4.7 Pre-study & §4.8.4 P1 Analysis Plan**
- Claim: Friedman test as omnibus nonparametric test for ranked comparisons, followed by Wilcoxon signed-rank for pairwise post-hoc
- Supporting passage: "We recommend Friedman test, with the corresponding post-hoc tests for comparison of more classifiers over multiple data sets." Also recommends Wilcoxon signed-rank for two-condition pairwise comparison. Uses rank aggregation across datasets (equivalent to Borda count aggregation).
- Full reference: Demšar, J. (2006). Statistical comparisons of classifiers over multiple data sets. *Journal of Machine Learning Research*, 7, 1–30.
- DOI: None (JMLR open access). URL: https://www.jmlr.org/papers/v7/demsar06a.html
- Physical PDF: freely available at JMLR URL above
- Used as: `~\cite{demsar2006}` at end of Friedman + Wilcoxon sentence in §4.7 and §4.8.4
- Note: Paper addresses classifier comparison, but is the canonical methodological reference for Friedman + Wilcoxon on ranking data, cited broadly in HCI and perception research.

---

## Added in Session: BT.709 Luma Coefficient Citation (2026-07-28)

### `itu709`
- **Full title:** Recommendation ITU-R BT.709-6: Parameter Values for the HDTV Standards for Production and International Programme Exchange
- **Author/Publisher:** International Telecommunication Union, Radiocommunication Sector (ITU-R)
- **Series:** BT Series, Broadcasting service (television)
- **Date:** 06/2015 (Geneva, 2015)
- **DOI:** None (ITU-R Recommendation, not a journal article)
- **Verify at:** https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.709-6-201506-I!!PDF-E.pdf
- **Source:** Official ITU-R document, fetched and verified directly (PDF read in full: cover page confirms title/series/date; §3.2 "Derivation of luminance signal E'_Y" on p.4 gives the formula E'_Y = 0.2126 E'_R + 0.7152 E'_G + 0.0722 E'_B, matching the coefficients used in this thesis exactly).
- **Summary:** Defines the parameter values (image format, chromaticity primaries, opto-electronic transfer function, luminance/colour-difference derivation) for HDTV production and international programme exchange. Item 3.2 specifies the luma (luminance signal) derivation from linear RGB via the perceptually weighted sum reproduced in this thesis.
- **Relevance to thesis:** Provides the authoritative source for the BT.709 luma coefficients used to convert the rendered colour image to a single scalar intensity channel before Sobel/gradient-based edge detection (V4, V4.2) and before the Kuwahara structure tensor and AHEAD adaptive gain (V5). Superseded an earlier, less standards-consistent BT.601 coefficient set previously used in V4/V4.2; BT.709 matches the sRGB primaries of the actual Unity URP rendering pipeline, so it is now used exclusively throughout the thesis.
- **Used in:** `03_background.tex` §3.2.1 (Gradient-Based Detection), Equation~\ref{eq:bt709_luma}
- **Sentence:** "...following the coefficients defined in ITU-R Recommendation BT.709 for high-definition video~\cite{itu709}."

```bibtex
@techreport{itu709,
  author       = {{International Telecommunication Union, Radiocommunication Sector}},
  title        = {Recommendation {ITU-R} {BT.709-6}: Parameter Values for the {HDTV} Standards for Production and International Programme Exchange},
  institution  = {International Telecommunication Union},
  year         = {2015},
  note         = {Available at \url{https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.709-6-201506-I!!PDF-E.pdf}},
}
```

---

## Added in Session: V3 Normal Edge Detection Citations (2026-07-30)

### `saitotakahashi1990`
- **Full title:** Comprehensible Rendering of 3-D Shapes
- **Authors:** Takafumi Saito, Tokiichiro Takahashi
- **Venue:** Proceedings of the 17th Annual Conference on Computer Graphics and Interactive Techniques (SIGGRAPH 1990), pp. 197–206
- **DOI:** 10.1145/97880.97901
- **Source:** Physical PDF read directly, `Articles/NPR/Comprehensible Rendering of 3-D Shapes Saito.pdf`, pp. 197–200
- **Summary:** Introduces Geometric Buffers (G-buffers), where each buffer stores one geometric property of the visible surface per pixel (e.g. depth or normal vector). The paper develops 2D image-processing operations on these buffers to draw discontinuity lines, contour lines, and curved hatching.
- **Relevance to thesis:** Cited as the origin of storing per-pixel surface normals in G-buffer channels as a cue for edge detection, supporting the image-space classification of V3's technique.
- **Used in:** `04_methodology.tex` §4.4.5 (V3 — Screen Space Normal Edge Detection)
- **Sentence:** "In prior work, per-pixel surface normals stored in G-buffer channels have been used as a cue for edge detection~\cite{saitotakahashi1990}."

```bibtex
@inproceedings{saitotakahashi1990,
  author    = {Saito, Takafumi and Takahashi, Tokiichiro},
  title     = {Comprehensible Rendering of 3-{D} Shapes},
  booktitle = {Proceedings of the 17th Annual Conference on Computer Graphics and Interactive Techniques ({SIGGRAPH})},
  year      = {1990},
  pages     = {197--206},
  doi       = {10.1145/97880.97901},
  publisher = {ACM},
}
```

### `nienhaus2003`
- **Full title:** Edge-Enhancement: An Algorithm for Real-Time Non-Photorealistic Rendering
- **Authors:** Marc Nienhaus, Jürgen Döllner
- **Venue:** Journal of WSCG, Vol. 11, No. 1, pp. 346–353 (11th International Conference in Central Europe on Computer Graphics, Visualization and Computer Vision)
- **DOI:** None available (ISSN 1213-6972)
- **Source:** Physical PDF read directly, `Articles/NPR/Edge Enhancement.pdf`
- **Summary:** Presents an edge map, a 2D texture encoding silhouette, border, and crease edges of 3D scene objects, computed in real time from discontinuities in depth and normal buffers. Crease edges specifically are shown to correspond to abrupt changes in the normal buffer.
- **Relevance to thesis:** Cited to support the claim that normal-buffer discontinuities detect silhouette, border, and crease edges in real-time NPR rendering, with crease edges in particular recovered from the normal buffer, directly motivating V3's normal-gradient approach.
- **Used in:** `04_methodology.tex` §4.4.5 (V3 — Screen Space Normal Edge Detection)
- **Sentence:** "Discontinuities across these same channels detect silhouette, border, and crease edges in real-time NPR rendering, and crease edges in particular are recovered from the normal buffer~\cite{nienhaus2003}."

```bibtex
@article{nienhaus2003,
  author    = {Nienhaus, Marc and D{\"o}llner, J{\"u}rgen},
  title     = {Edge-Enhancement: An Algorithm for Real-Time Non-Photorealistic Rendering},
  journal   = {Journal of {WSCG}},
  year      = {2003},
  volume    = {11},
  number    = {1},
  pages     = {346--353},
  note      = {11th International Conference in Central Europe on Computer Graphics, Visualization and Computer Vision, ISSN 1213-6972. No DOI available.},
}
```

---

## Added in Session: Introduction Motivation — AI Ubiquity Framing (2026-08-01)

### `rapp2025`
- **Full title:** How Do People Experience the Images Created by Generative Artificial Intelligence? An Exploration of People's Perceptions, Appraisals, and Emotions Related to a Gen-AI Text-to-Image Model and Its Creations
- **Authors:** Amon Rapp, Chiara Di Lodovico, Federico Torrielli, Luigi Di Caro
- **Journal:** International Journal of Human-Computer Studies, Vol. 193, Article 103375
- **Year:** 2025
- **DOI:** 10.1016/j.ijhcs.2024.103375
- **Bibliographic verification:** Cross-checked against CrossRef API and Semantic Scholar; both independently agree on authors, journal, volume, article number, and DOI.
- **Physical PDF:** `Articles/ScienceDirect_articles_01Aug2026_12-56-41.045/How-do-people-experience-the-images-created-by-generative_2025_International.pdf`. Read in full (16 pages, ScienceDirect offprint), 2026-08-01.
- **Summary:** Qualitative study (semi-structured interviews, 20 Italian participants with diverse technical/design backgrounds, most without prior Gen-AI experience) exploring how people perceive and emotionally react to 20 images generated by Stable Diffusion from single-word prompts (e.g. "Love," "Anarchy," "Wisdom," "Justice," a steering wheel). The introduction establishes that Gen-AI systems attracted millions of users within a short period (citing DALL-E 2 and Midjourney adoption figures) and that AI-generated images are now widespread on social networks, magazine covers, news articles, and art competitions, so that "these technologies are seeing into many aspects of people's daily lives, whereby an increasingly wide spectrum of individuals not only create digital representations through automated means, but also are exposed to them." Findings: participants judged the images mainly on technical quality and subject fidelity rather than artistic merit, perceiving them as either "strange" or "prototypical," and these perceptions evoked feelings the paper characterises as uncanny/unsettling even before participants knew the images were AI-generated (and these feelings intensified once revealed). Participants used "relational strategies," devaluing or overvaluing the Gen-AI or themselves, to cope with this unfamiliarity.
- **Important nuance — do not overstate:** The paper explicitly distinguishes its "uncanny" finding from Mori's classic uncanny valley. Their stimuli are abstract/concrete noun representations, not human faces or avatars, and the paper argues (Discussion, §5.1) that the uncanniness here stems from the "alien nature of the technology" itself rather than from near-human appearance triggering categorical uncertainty as in Mori's original formulation. This paper is cited only for the ubiquity/passive-exposure claim (Gen-AI content is now widespread and increasingly encountered rather than actively created), not as additional evidence for the avatar-specific Mori uncanny valley, which remains grounded in `mori1970`, `mcdonnell2012`, and `canales2024` elsewhere in the thesis.
- **Status (2026-08-01): not currently cited.** An earlier draft of the Introduction's opening paragraph used this source for the sentence "This rapid adoption is not confined to active users, since an increasing share of the population now encounters AI-generated imagery passively through social media, entertainment, and daily digital content rather than producing it directly~\cite{rapp2025}." That draft was superseded when the opening paragraph was refocused on avatars rather than AI ubiquity generally. Kept here as a fully verified, ready-to-use source (bibliography entry retained in `references.bib`) in case an AI-ubiquity argument is reintroduced later in the thesis.
- **Relevance (if reused):** Grounds the claim that generative AI content has become an ordinary, passively-encountered part of daily life.

```bibtex
@article{rapp2025,
  author    = {Rapp, Amon and Di Lodovico, Chiara and Torrielli, Federico and Di Caro, Luigi},
  title     = {How Do People Experience the Images Created by Generative Artificial Intelligence? {A}n Exploration of People's Perceptions, Appraisals, and Emotions Related to a {G}en-{AI} Text-to-Image Model and Its Creations},
  journal   = {International Journal of Human-Computer Studies},
  year      = {2025},
  volume    = {193},
  pages     = {103375},
  doi       = {10.1016/j.ijhcs.2024.103375},
}
```

---

## Added in Session: Motivation Nested-Citation Resolution (2026-08-02)

### `natarajan2020`
- **Full title:** Effects of Anthropomorphism and Accountability on Trust in Human Robot Interaction
- **Authors:** Manisha Natarajan, Matthew Gombolay
- **Venue:** Proceedings of the 2020 ACM/IEEE International Conference on Human-Robot Interaction (HRI '20), Cambridge, United Kingdom
- **Year:** 2020
- **DOI:** 10.1145/3319502.3374839
- **Source:** Primary PDF located and added by Nidanur 2026-08-02: `Articles/Natarajan-Effects of Anthropomorphism and Accountability on Trust inHuman Robot Interaction.pdf`. Read directly in full, 2026-08-02. Bibliographic details confirmed from the paper's own header/footer (HRI '20, March 23-26 2020, Cambridge UK, p.33 start, ACM ISBN 978-1-4503-6746-2/20/03, DOI 10.1145/3319502.3374839), matching `references.bib` exactly.
- **Why this citation was added:** The thesis sentence in `01_introduction.tex` §Motivation ("realistic appearance and behaviour of this kind have been shown to enhance a user's compliance and confidence in an avatar") was citing only `alipour2025`, a systematic review. Alipour et al.'s own Introduction (p.3) attributes this specific claim to a further source rather than presenting it as their own finding: "research suggests that anthropomorphic features of agents... can enhance users' compliance and trust in agents (Lee & Nass, 2010; Natarajan & Gombolay, 2020)." Reading further into Alipour et al.'s body text (pp.9-10, "How an Agent's Human-Likeness Affects Trust") confirmed Natarajan & Gombolay (2020) is the concrete empirical study being invoked: "Empirical studies show that integrating human-like features into an agent's appearance and behavior can foster more favorable user responses and increase trust (Natarajan & Gombolay, 2020; Salem et al., 2013). By way of example, Natarajan and Gombolay (2020) demonstrated that features (e.g., gestures, voice, expressiveness) significantly enhanced trust." This is a direct experimental finding (robots Pepper/Nao/Sawyer/Kuri, four behavioural styles, trust measured via survey after a time-sensitive task), a much closer match to the thesis's specific claim than the alternative nested citations (Lee & Nass 2010 is a theoretical CASA-paradigm chapter; Følstad & Brandtzæg 2017 is about chatbot HCI generally, not the compliance/trust claim specifically).
- **Used in:** `01_introduction.tex` §Motivation, paragraph 3, sentence ending `~\cite{natarajan2020, alipour2025}` (added `natarajan2020` alongside the existing `alipour2025`, rather than replacing it, since `alipour2025` still provides useful synthesis/context and is independently a Following of correctly-scoped citation for the surrounding review-level claims).
- **Sentence:** "Furthermore, realistic appearance and behaviour of this kind have been shown to enhance a user's compliance and confidence in an avatar~\cite{natarajan2020, alipour2025}."
- **Confirmed directly from primary source (2026-08-02):** Abstract: "Results from the 4x4x2x2 study show that behavior and anthropomorphism of the agent are the most significant factors in predicting the trust and compliance with the robot." §3.4 H1 hypothesis text explicitly ties anthropomorphism to "an increase in compliance with the agent's recommendations and overall trust in the agent." §4.1 Results: perceived anthropomorphism significantly and positively correlated with trust (p<0.001, F(1,720)=17.6276, coefficient 0.29335). §4.2 H2: agent behavior also significantly affects trust (p<0.001, F(4,670)=73.5384). This directly and precisely supports the thesis claim; no caveat remains.

```bibtex
@inproceedings{natarajan2020,
  author    = {Natarajan, Manisha and Gombolay, Matthew},
  title     = {Effects of Anthropomorphism and Accountability on Trust in Human Robot Interaction},
  booktitle = {Proceedings of the 2020 {ACM/IEEE} International Conference on Human-Robot Interaction},
  series    = {{HRI} '20},
  year      = {2020},
  address   = {Cambridge, United Kingdom},
  doi       = {10.1145/3319502.3374839},
}
```

---

## Added in Session: Consumer Gaming/Advertising Replacement Citation (2026-08-02)

### `rahman2024`
- **Full title:** Navigating Avatar-Based Marketing From Value Aspects: A Systematic Literature Review and Forward-Looking Research Agenda
- **Authors:** Md. Shahinur Rahman, Md. Mahiuddin Sabbir, Jing Zhang, Khan Md. Raziuddin Taufique, Md. Masudur Rahman
- **Journal:** International Journal of Consumer Studies, Vol. 48, No. 6, Article e13096
- **Year:** 2024
- **DOI:** 10.1111/ijcs.13096
- **Source:** Physical PDF located and added by Nidanur 2026-08-02: `Articles/Navigating_Avatar-Based_Marketing_From_Value_Aspec.pdf`. Read directly, 2026-08-02 (pp. 1-2 of 46, Abstract and Introduction). Bibliographic details confirmed from the paper's own title page and running header/footer, matching `references.bib` exactly.
- **Why this citation replaces `weidner2023` here:** The thesis sentence "virtual avatars move beyond research settings into widely used consumer applications such as gaming and advertising" was previously citing `weidner2023`, whose "game-like scenario" category was found (2026-08-02) to classify academic AR/VR research studies using game-like experimental tasks in controlled lab settings, not avatars in real commercial deployment. That citation did not support the claim. Rahman et al.'s systematic review (57 articles on avatar-based marketing, 2005-2023) gives concrete, named, real-world examples of avatars deployed in actual consumer contexts, directly supporting both halves of the sentence in a single citation.
- **Summary:** A systematic literature review of avatar-based marketing (ABM) using the theory-context-characteristics-methods framework. Reviews 57 published articles (2005-2023). Cites concrete industry examples: Nike's "Nikeland" avatar space in the Metaverse via Roblox (a gaming platform), IKEA's customer-service avatar "Anna," Samsung's AI avatar "Neon," and Calvin Klein's deployment of virtual influencer "Lil Miquela" (2.4M+ Instagram followers) for marketing/advertising purposes. Explicitly states avatars are used across "online services (e.g., banking, gaming, education, shopping, m-health, etc.)" and are "a huge prospect in the virtual gaming, smartphone, and fashion industries."
- **Used in:** `01_introduction.tex` §Motivation, closing sentence of the paragraph transitioning into the Problem Statement
- **Sentence:** "This question is becoming increasingly relevant as virtual avatars move beyond research settings into widely used consumer applications such as gaming and advertising~\cite{rahman2024}."
- **Cited text (p.2 of 46):** "Companies like Nike have introduced Nikeland in the Metaverse through platforms like Roblox. Similarly, IKEA has introduced a customer-focused avatar named Anna, who can address inquiries regarding IKEA's products, services, and operating hours." Also (same page): "...the growing importance of avatars in online services (e.g., banking, gaming, education, shopping, m-health, etc.)... the usage of avatars is not limited to a particular sector, like banking or hotel; it is seen as a huge prospect in the virtual gaming, smartphone, and fashion industries." Also (same page, advertising half): "...the famous fashion brand Calvin Klein has deployed Lil Miquela, a virtual influencer (another form of avatar); interestingly, Lil Miquela has more than 2.4 million followers on Instagram."

```bibtex
@article{rahman2024,
  author    = {Rahman, Md. Shahinur and Sabbir, Md. Mahiuddin and Zhang, Jing and Taufique, Khan Md. Raziuddin and Rahman, Md. Masudur},
  title     = {Navigating Avatar-Based Marketing From Value Aspects: A Systematic Literature Review and Forward-Looking Research Agenda},
  journal   = {International Journal of Consumer Studies},
  year      = {2024},
  volume    = {48},
  number    = {6},
  pages     = {e13096},
  doi       = {10.1111/ijcs.13096},
}
```

---

## Added in Session: Background §3.2 Edge Detection — Image/Pixel and Edge Definitions (2026-08-09)

### `gonzalez2018` — additional usage in §3.2 Edge Detection (chapter opening)

**§3.2 Edge Detection, opening paragraph, sentences 1–2 (single citation covering both)**
- Claim 1: a digital image is a discrete grid of pixels, each storing an intensity value
- Supporting passage (p.18, §1.1 "What Is Digital Image Processing?"): "Note that a digital image is composed of a finite number of elements, each of which has a particular location and value. These elements are called picture elements, image elements, pels, and pixels."
- Supporting passage (p.66, Ch.2, Eq. 2-9–2-10): the image is formally represented as an M×N array f(x,y), and "[e]ach element of this array is called an image element, picture element, pixel, or pel."
- Claim 2: an edge is conventionally defined as a location where image intensity changes rapidly
- Supporting passage (p.702, §10.2 "Point, Line, and Edge Detection"): "Edge pixels are pixels at which the intensity of an image changes abruptly, and edges (or edge segments) are sets of connected edge pixels."
- Note: this is a near-verbatim match (source: "changes abruptly"; thesis: "changes rapidly" — same meaning).
- Used as: single `~\cite{gonzalez2018}` at the end of sentence 2 only: "A digital image consists of a grid of pixels and each stores an intensity value. And an edge in an image is conventionally defined as a location where this intensity changes rapidly~\cite{gonzalez2018}." Sentence 1 is left uncited since both sentences are basic definitions from the same source functioning as one two-sentence unit; a second inline citation on sentence 1 was judged redundant.

**Verification:** Physical PDF read directly (`Articles/Gonzales,Woods-Digital.Image.Processing.4th.Edition.pdf`, pp. 18, 66, 702), 2026-08-09. Both claims CONFIRMED against the primary source. Logged in `citation_check.tex` §Chapter 3 — Background as a single unstarred entry covering both sentences (pending Nidanur's review).
