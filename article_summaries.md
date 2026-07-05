# Article Summaries — Abstraction Mechanisms for Virtual Avatars

Nidanur Günay, University of Konstanz — Master's Thesis 2026

This document collects detailed summaries of all articles that form the theoretical and empirical foundation of the thesis and user study. Entries are grouped by topic. Each entry includes the full bibliographic reference, DOI where available, a content summary, and notes on relevance to this thesis.

---

## 1. Uncanny Valley

---

### Mori, M. (1970) — The Uncanny Valley

**Full reference:** Mori, M. (1970). The uncanny valley. *Energy*, 7(4), 33–35. Translated by Karl F. MacDorman and Norri Kageki.

**Physical file:** `uncanny1970.pdf`

**Bib key:** `mori1970`

**What the paper argues.**
Mori proposed that human affinity toward an artificial figure increases with its degree of human likeness up to a critical threshold, at which point subtle imperfections cause a sharp drop in comfort. The drop persists until the figure achieves complete human fidelity, after which affinity recovers. Mori plots two curves: one for still figures (solid) and one for moving figures (dashed). The motion curve descends far deeper into negative comfort than the still curve, indicating that animation substantially amplifies the perceptual discomfort triggered by near human imperfection. The reference points Mori places inside the valley, a corpse, a zombie, and a prosthetic hand, all share a common characteristic: each closely resembles a human in most dimensions but fails on some dimension that perception detects without effort.

**Key implication for this thesis.**
A figure at roughly 60–70% human likeness (the region occupied by a stuffed animal or a humanoid robot) sits on the safe rising slope before the drop. A figure at 80–95%, realistic enough to raise expectations of full human fidelity yet not realistic enough to satisfy them, occupies the most problematic region, and motion makes that positioning considerably worse. NPR stylisation can shift a photorealistic avatar leftward on the curve, away from the problematic zone.

---

### MacDorman, K. F. & Ishiguro, H. (2006) — Uncanny Valley Empirical Programme

**Full reference:** MacDorman, K. F. & Ishiguro, H. (2006). The uncanny advantage of using androids in cognitive and social science research. In *Proceedings of the ICDL-2006 Workshop on Android Science*, 1–9.

**Note:** Conference proceedings; no DOI assigned. Available from author's website.

**Bib key:** `macdorman2006`

**What the paper argues.**
MacDorman and Ishiguro argued that androids, robotic systems designed to closely resemble humans, are uniquely valuable scientific tools precisely because they can be positioned at any point along the human likeness continuum with experimental control. By manipulating android appearance systematically, researchers can generate Uncanny Valley responses on demand and study the psychological and cognitive mechanisms that produce them. The paper proposed a set of semantic differential scales to operationalise eeriness and strangeness as measurable affective responses, converting Mori's qualitative curve into a quantifiable experimental variable. It also proposed that the Uncanny Valley effect is driven not merely by imperfection in appearance, but by violations of categorical perception: when an agent is ambiguous between the "human" and "non-human" categories, the cognitive mismatch produces a negative affective response.

**Methodology.**
The paper combines a theoretical argument with the introduction of a measurement instrument. A pilot study is reported but sample size and full statistical details are not provided in the proceedings version.

**Relevance to this thesis.**
MacDorman and Ishiguro's eeriness scales are the original source of the eeriness measurement approach used in this study. Their categorical perception account of the Uncanny Valley supports the prediction that NPR stylisation can reduce eeriness by shifting the stimulus away from the ambiguous boundary region between human and non-human categories, even if perceived human likeness is not dramatically reduced.

---

### Ho, C.-C. & MacDorman, K. F. (2010) — Validated Eeriness Instrument

**Full reference:** Ho, C.-C. & MacDorman, K. F. (2010). Revisiting the uncanny valley theory: Developing and validating an alternative to the Godspeed indices. *Computers in Human Behavior*, 26(6), 1508–1518.

**DOI:** `10.1016/j.chb.2010.05.015`

**Bib key:** `ho2010`

**Core problem.**
Mori's (1970) uncanny valley graph has two axes: *bukimi* (eeriness) on the y-axis and degree of human likeness on the x-axis. To test the theory empirically, these must be measured by independent, validated instruments. The Godspeed questionnaire (Bartneck et al., 2009) proposed anthropomorphism and likeability as potential candidates. Ho and MacDorman tested this empirically and found it does not work.

**Phase 1 — Testing the Godspeed indices.**
384 participants rated 10 video clips (five CG characters from *Final Fantasy*, *The Incredibles*, *The Polar Express*, and similar productions, plus five robots) on all 24 Godspeed items. The four cognitive-perceptual subscales were so strongly intercorrelated that they cannot claim to measure distinct concepts. Anthropomorphism and animacy correlate at r = .89; anthropomorphism and likeability at r = .73. The subscales are effectively measuring the same underlying construct, most likely interpersonal warmth. Multidimensional scaling confirmed the axes are collinear, not orthogonal. A second conceptual problem: eeriness is not the same as negative warmth. The specific emotions that predict eeriness — fear, anxiety, disgust — are distinct from the emotional content of coldness.

**Phase 2 — Developing new indices.**
Ho and MacDorman developed four new indices through two rounds of testing (Round 1: n = 19; Round 2: n = 253), using the same 10 video clips. Items were semantic differential pairs selected to be decoupled from interpersonal warmth and from each other.

- **Perceived Humanness** (6 items, α = .92): Artificial–Natural, Human-made–Humanlike, Without Definite Lifespan–Mortal, Inanimate–Living, Mechanical Movement–Biological Movement, Synthetic–Real
- **Eeriness** (8 items, α = .74 overall): Two stable subfactors — Eerie subfactor (Reassuring–Eerie, Numbering–Freaky, Ordinary–Supernatural, Bland–Uncanny) and Spine-tingling subfactor (Unemotional–Hair-raising, Uninspiring–Spine-tingling, Boring–Shocking, Predictable–Thrilling)
- **Attractiveness** (5 items, α = .90): included as a decoupling check
- **Warmth** (5 items, α = .88): used as a decoupling check only

**Critical validation result.**
Eeriness and humanness are not significantly correlated (r = .02, p = .514). Eeriness is also decoupled from warmth (r = −.05, p = .083). The two axes of Mori's graph are now empirically independent. This result provides the theoretical basis for combining the eeriness subscale (Part B) with the Godspeed anthropomorphism subscale (Part D) in this study.

**Relevance to this thesis.**
The eeriness subscale in Part B of the questionnaire is grounded in Ho and MacDorman's validated eeriness index. Because eeriness and perceived humanness are orthogonal dimensions, it is possible to test whether NPR stylisation shifts the C2→C3 eeriness reduction through a change in perceived human likeness (the mediation path in H5), or whether eeriness decreases for other reasons while anthropomorphism scores remain relatively stable.

---

## 2. User Study — Trust and Avatar Perception

---

### McKnight, D. H. & Chervany, N. L. (2001) — Trust Conceptual Typology

**Full reference:** McKnight, D. H. & Chervany, N. L. (2001). What trust means in e-commerce customer relationships: An interdisciplinary conceptual typology. *International Journal of Electronic Commerce*, 6(2), 35–59.

**DOI:** `10.1080/10864415.2001.11044235`

**Bib key:** `mcknight2001`

**Background and motivation.**
Trust research across disciplines had produced dozens of incompatible definitions. The word "trust" carried on average 17 distinct meanings across major unabridged dictionaries, more than conceptually adjacent terms such as "cooperation" or "confidence." Psychologists viewed trust as a personal trait, sociologists viewed it as a social structure, and economists viewed it as a mechanism for rational choice. This disciplinary fragmentation meant empirical results could not be meaningfully compared or accumulated. McKnight and Chervany argued that before empirical research on trust can progress, the field needs a clear, parsimonious, interdisciplinary conceptual typology.

**Method: how the typology was constructed.**
The authors reviewed approximately 80 articles and books on trust across three disciplinary clusters: psychology and social psychology (23 sources), sociology, economics, and political science (19 sources), and management and communications (23 sources). From these they identified 65 sources that provided usable trust definitions. All existing definitions fell into two independent cross-cutting dimensions: the conceptual type of the construct (disposition, attitude, belief, intention, or behavior), and the referent of the construct (people in general, a specific situation, or a specific other person). Sixteen specific trust-related characteristics collapsed into five second-order categories, with benevolence (38.8%), integrity (26.5%), and competence (20.4%) accounting for the largest shares.

**The four trust constructs.**

1. **Disposition to Trust** — a stable, generalised personality tendency to be willing to depend on general others across a broad spectrum of situations and persons. Two subconstructs: Faith in Humanity (belief about human nature) and Trusting Stance (behavioural strategy regardless of specific beliefs about others).

2. **Institution-based Trust** — one believes that favorable conditions are in place that are conducive to situational success. Two subconstructs: Structural Assurance (belief that protective structures are in place) and Situational Normality (belief that the situation is normal and appropriate).

3. **Trusting Beliefs** — one believes that the other party has one or more characteristics beneficial to one. Four subconstructs: Competence belief, Benevolence belief, Integrity belief, and Predictability belief. Directed at a specific other person and cross-situational.

4. **Trusting Intentions** — one is willing to depend on, or intends to depend on, the other party even though one cannot control that party. Two subconstructs: Willingness to Depend and Subjective Probability of Depending.

**Overarching definition of trust** (McKnight & Chervany, 2001, p. 10): *"To willingly become vulnerable to the trustee — another person, institution, or people generally — having taken into consideration the characteristics of the trustee, with a feeling of relative security in a situation of risk."*

**Relevance to this thesis.**
The McKnight and Chervany typology provides the theoretical foundation for the three-part trust battery (Parts E, F, and G of the questionnaire). The three Trusting Beliefs subconstructs retained — competence, benevolence, and integrity — correspond directly to their framework, as adopted by Canales et al. (2024) for the avatar trust context. Disposition to Trust and Institution-based Trust are excluded because they are antecedents that do not vary between avatar conditions; Disposition to Trust is included only as a between-subjects covariate (Demographics Q9).

---

### Mayer, R. C., Davis, J. H. & Schoorman, F. D. (1995) — Integrative Model of Trust

**Full reference:** Mayer, R. C., Davis, J. H., & Schoorman, F. D. (1995). An integrative model of organizational trust. *Academy of Management Review*, 20(3), 709–734.

**DOI:** `10.5465/amr.1995.9508080335`

**Bib key:** `mayer1995`

**Core argument.**
Prior trust research suffered from conceptual fragmentation: disciplines used definitions that were not interchangeable, making findings hard to compare. Mayer et al. synthesised these into one integrative model. Trust is defined as *"the willingness of a party to be vulnerable to the actions of another party based on the expectation that the other will perform a particular action important to the trustor, irrespective of the ability to monitor or control that other party"* (p. 712). Three elements are essential: (1) willingness to be vulnerable; (2) the absence of monitoring and control; (3) a positive expectation about the other party's behaviour. Trust is therefore a disposition toward risk, not a response to certainty.

**The three trustworthiness factors — the ABI model.**
Trust in a specific other party arises from that party's perceived trustworthiness, decomposed into three independent factors:

- **Ability:** A cluster of skills and competencies that enable a party to have influence within a specific domain. Ability is domain-specific: a trustee may be highly competent in one area and not in another.
- **Benevolence:** The extent to which the trustee is believed to want to do good for the trustor, apart from any self-interested motive. Benevolence is relational and specific to the trustor-trustee dyad.
- **Integrity:** The trustor's perception that the trustee adheres to a set of principles the trustor finds acceptable. This includes honesty, consistency between stated values and observed actions, and credibility in communication.

The three factors are conceptually independent and can take different values for the same trustee. Collapsing them into a single trust score obscures these distinctions and masks differential effects.

**Full causal model.**
Perceived trustworthiness (ability + benevolence + integrity) produces trust (willingness to be vulnerable), which produces risk-taking behaviour in the relationship. Two moderators: (1) the trustor's propensity to trust, a stable individual trait; (2) the perceived risk of the situation.

**Relevance to this thesis.**
The Mayer et al. ABI model is the theoretical foundation for the trust battery in Parts E, F, and G of the questionnaire. The three subscales correspond directly: ability (Part E), benevolence (Part F: caring and acting in the participant's interest), and integrity (Part G: honesty and transparent reasoning). The forced-choice advisor selection (Part P1) operationalises the risk-taking behavioural outcome that Mayer et al. place downstream of trust in their model.

---

### Bartneck, C., Kulić, D., Croft, E. & Zoghbi, S. (2009) — Godspeed Questionnaire Series

**Full reference:** Bartneck, C., Kulić, D., Croft, E., & Zoghbi, S. (2009). Measurement instruments for the anthropomorphism, animacy, likeability, perceived intelligence, and perceived safety of robots. *International Journal of Social Robotics*, 1(1), 71–81.

**DOI:** `10.1007/s12369-008-0001-3`

**Bib key:** `bartneck2009`

**Background and motivation.**
Robot developers in HRI had been creating their own ad hoc questionnaires without validation, making results from different studies impossible to compare. Bartneck et al. conducted a literature review of existing instruments for five key perceptual concepts, then standardised and validated them into a single coherent battery named Godspeed. All five subscales use 5-point semantic differential format: participants rate their impression of the robot by choosing between two opposing adjective anchors (e.g., Fake ↔ Natural). This format was chosen over Likert items to reduce acquiescence bias and to maintain consistency across subscales.

**The five Godspeed subscales.**

- **Godspeed I — Anthropomorphism** (5 items): Captures the degree to which participants attribute human form, characteristics, or behavior to the observed entity. Items: Fake–Natural, Machinelike–Humanlike, Unconscious–Conscious, Artificial–Lifelike, Moving rigidly–Moving elegantly. Cronbach's α: 0.878 (Study 1).
- **Godspeed II — Animacy** (6 items): Captures perceived aliveness and responsiveness. Cronbach's α: 0.702 (Study 1). Note: Artificial/Lifelike appears in both Anthropomorphism and Animacy.
- **Godspeed III — Likeability** (5 items): Captures positive affective appeal and social warmth. Items: Dislike–Like, Unfriendly–Friendly, Unkind–Kind, Unpleasant–Pleasant, Awful–Nice. Cronbach's α: 0.865 (Study 1).
- **Godspeed IV — Perceived Intelligence** (5 items): Captures the observer's subjective judgment of the entity's intellectual capacity. Items: Incompetent–Competent, Ignorant–Knowledgeable, Irresponsible–Responsible, Unintelligent–Intelligent, Foolish–Sensible. Cronbach's α: 0.750–0.769 across studies.
- **Godspeed V — Perceived Safety** (3 items): Captures the observer's subjective sense of comfort and absence of anxiety during interaction. Items: Anxious–Relaxed, Agitated–Calm, Quiescent–Surprised. Cronbach's α: 0.91 in validation study.

**Which subscales are used in this study.**

Used:
- **Godspeed I (Anthropomorphism) → Part D.** Operationalises perceived human likeness, which is the perceptual axis along which the three conditions differ. Including anthropomorphism ratings allows testing whether differences in eeriness across conditions are mediated by shifts in perceived human likeness (H5).
- **Godspeed III (Likeability) → Part C.** The primary affective indicator in this study. Likeability captures warmth, social appeal, and positive first impressions — the affective dimension most directly disrupted by eeriness.

Not used:
- **Godspeed II (Animacy):** The animation is held constant across C2 and C3 (the critical comparison pair). Including it would add items without contributing to the core hypotheses.
- **Godspeed IV (Perceived Intelligence):** Covered with greater specificity by the McKnight and Chervany trust subscales in Parts E–G. Adding it alongside the trust battery would create redundancy.
- **Godspeed V (Perceived Safety):** Measures anxiety during physical proximity to a robot. This construct has no meaningful referent in a video-only study where the avatar is not physically co-present.

**General limitation noted by the authors.**
Results from Godspeed subscales should be interpreted as comparative tools, not absolute values. Cultural background, prior experience with robots, and individual personality all influence ratings.

---

### Canales, R., Roble, D. & Neff, M. (2024) — Trust and Avatar Stylisation

**Full reference:** Canales, R., Roble, D., & Neff, M. (2024). The impact of avatar stylization on trust. In *2024 IEEE Conference on Virtual Reality and 3D User Interfaces (VR)*, 418–428.

**DOI:** `10.1109/VR58804.2024.00063`

**Bib key:** `canales2024`

**Study design.**
66 participants in VR each interviewed three virtual doctors in a 3 (identity) × 3 (stylisation level) within-subjects design. Three doctor identities (Asian female, South Asian male, Caucasian male) were each rendered at three stylisation levels: photorealistic (Real), semi-realistic (Mid), and caricatured. All responses were pre-recorded using high-quality offline motion capture (Vicon for body, Faceware for face) and played back in Unreal Engine 5 on a Meta Quest 2. The scenario was high-stakes medical: participants imagined they had been diagnosed with a potentially cancerous kidney lump and needed a second opinion. Each doctor answered three preset questions, one designed to address each trust component from the Mayer et al. (1995) ABI model.

**Questionnaire and behavioural measure.**
Trust survey on 7-point Likert scales covering Ability (2 items), Benevolence (2 items), Integrity (2 items), and Composite trust (1 item). After all three doctor interviews, participants chose their most preferred doctor for a follow-up second opinion and their least preferred — the primary behavioural trust indicator.

**Key results.**
Style had no significant main effect on any self-report trust dimension (ability: p = .12; benevolence partial: p = .034; integrity: p = .16; composite trust: p = .13). Realistic avatars were not trusted more than stylised ones. However, stylisation significantly affected *behavioural* doctor selection (p = .044): Mid-style was chosen as most preferred doctor by 48% of participants, compared to approximately 26% each for Real and Caricature. The strongest effect was identity: the Caucasian male condition was consistently rated lower on all trust dimensions and selected as least preferred most often, driven by motion and body language artefacts from the retargeting pipeline rather than visual style.

**Relevance to this thesis.**
This is the closest prior work to the current study. Three design decisions are adopted directly: (1) the video-based advisor paradigm with pre-recorded scripted responses; (2) the Mayer et al. ABI trust battery on 7-point Likert scales (Parts E, F, G of the questionnaire); (3) the forced-choice advisor selection as a behavioural trust indicator (Part P1). The finding that self-reported trust was equivalent across stylisation levels is the empirical basis for H2. The dissociation between self-report (no style effect) and behavioural selection (Mid preferred) is the reason this study includes both measures: a self-report battery alone would have missed the style preference entirely.

---

### Alipour, A., Hartmann, T. & Alimardani, M. (2025) — Systematic Review

**Full reference:** Alipour, A., Hartmann, T., & Alimardani, M. (2025). Would you rely on an eerie agent? A systematic review of the impact of the Uncanny Valley Effect on trust in human-agent interaction. *arXiv preprint arXiv:2505.05543*.

**DOI / arXiv:** `arXiv:2505.05543` — https://arxiv.org/abs/2505.05543

**Bib key:** `alipour2025`

**Core question.**
How does the Uncanny Valley Effect (UVE) impact human trust in agents? This is the first systematic review to map the intersection of UVE research and trust across the empirical literature as a whole.

**Method.**
PRISMA 2020 systematic review. The search covered seven databases (Scopus, Web of Science, PubMed, APA PsycInfo, IEEE Xplore, ProQuest, WorldCat). The initial pool of 641 records was reduced to 311 after removing duplicates and excluded formats. After two-stage screening (title/abstract then full text), 53 studies were retained. Inter-rater reliability was Fleiss' Kappa = 0.61, indicating substantial agreement. Data were extracted using predefined codes covering agent type, modality, study design, UVE measures, trust measures, and key findings.

**Key observation on interaction type.**
42 out of 53 studies (79%) used indirect encounters: participants passively viewed static images, videos, or transcripts rather than engaging in live interaction with an agent. Agent types spanned robots (n = 25), virtual agents (n = 21), chatbots (n = 2), and voice-only systems (n = 2).

**Novel trust measurement framework.**
The paper's central theoretical contribution is a three-category taxonomy of how trust has been assessed across the literature:

| Category | Studies | What it captures |
|---|---|---|
| Direct trust measures | 24 | Explicit self-reported trust or trustworthiness ratings |
| Trust-related constructs | 11 | Competence, acceptability, credibility, believability, persuasion |
| Trust-related intentions | 18 | Behavioural intentions: advice following, willingness to interact, purchase decisions |

Of the 53 studies, 46 relied exclusively on subjective self-report. Only 7 used objective behavioural measures such as trust games or decision tasks.

**Main findings.**
Among the 41 studies that empirically tested the UVE-trust relationship:
- 17 studies reported a direct effect: in every case, UVE diminished trust or trust-related outcomes.
- 24 studies reported a conditional or indirect effect: the UVE-trust relationship was moderated or mediated by additional factors. Prominent moderators included: context of use and task type (n = 6), age (n = 3), familiarity with the agent (n = 3), personality traits (n = 3).
- 10 studies found no effect: the UVE was successfully induced but did not translate into reduced trust.

**Competence as a buffer.**
A cross-cutting finding across several no-effect and moderation studies is that perceived competence can counteract the negative influence of eeriness on trust. MacDorman (2019) found that eeriness did not reduce persuasion when the computer-animated agent was perceived as competent. Patel and MacDorman (2015) found that advice quality exerted a stronger influence on compliance than the agent's appearance or rated trustworthiness.

**Three categories of moderating factors:**
- **User-related:** age, personality traits, individual neural response differences, initial impressions, familiarity and satisfaction with the agent, prior interpersonal trust levels.
- **Agent-related:** design mismatches, competence, warmth, autonomy, emotional expressiveness, curated imperfections, overall trustworthiness signal.
- **Environment-related:** context of use, task type, interaction frequency and repetition.

**Recommendations for future research.**
1. Move toward dynamic, video-based interaction paradigms; add longitudinal designs.
2. Combine self-report surveys with objective behavioural measures: trust games, forced-choice tasks, physiological signals.
3. Manipulate human likeness across at least 3–5 levels to reveal the non-linear UVE pattern; measure both eeriness and positive responses (familiarity, likeability).
4. Justify sample sizes through power analysis; ensure diversity across gender, age, and cultural background.
5. Model the relationship structurally: treat UVE as predictor and trust as outcome, with candidate mediators including emotional discomfort, perceived competence, warmth, anthropomorphism, and threat perception.

**Relevance to this thesis.**
- Validates the video-based design: 42 out of 53 reviewed studies used indirect exposure. Video stimuli sit squarely within the established empirical norm.
- Validates combining self-report with a behavioural indicator: the paper explicitly identifies reliance on self-report alone as a major limitation and recommends pairing surveys with behavioural measures. Part P1 (forced-choice advisor selection) implements exactly this recommendation.
- Validates eeriness as the primary UVE instrument (Part B): eeriness is identified as the best-practice measure with the largest effect sizes across the prior meta-analysis.

---

## 3. NPR — Nonphotorealistic Rendering

*Detailed summaries for the NPR articles will be added here. The following entries are referenced in the thesis; full summaries to be expanded from the physical PDFs in the Articles folder.*

---

### Gooch, A., Gooch, B., Shirley, P. & Cohen, E. (1998) — NPR Lighting Model

**Full reference:** Gooch, A., Gooch, B., Shirley, P., & Cohen, E. (1998). A non-photorealistic lighting model for automatic technical illustration. In *Proceedings of SIGGRAPH*, 447–452.

**DOI:** `10.1145/280814.280950`

**Physical file:** `Gooch1998.pdf` | **Bib key:** `gooch1998`

**Core contribution.** Replaced the continuous Lambertian diffuse term with a hue shift from cool shadows to warm highlights, mimicking the conventions of technical illustration. The core insight is that shading can communicate form without physically simulating light. This became the foundational reference for cool-to-warm toon shading in the NPR literature.

---

### Lake, A., Marshall, C., Harris, M. & Blackstein, M. (2000) — Inverted Hull Outline

**Full reference:** Lake, A., Marshall, C., Harris, M., & Blackstein, M. (2000). Stylized rendering techniques for scalable real-time 3D animation. In *Proceedings of the 1st International Symposium on Non-Photorealistic Animation and Rendering (NPAR)*, 13–20.

**DOI:** `10.1145/340916.340918`

**Bib key:** `lake2000`

**Core contribution.** Described the inverted hull (back-face expansion) technique for geometry-based silhouette outlines. Back-facing polygons are expanded along vertex normals by a small offset, creating a slightly enlarged shell; when front-facing geometry is rendered on top, only the protruding rim remains visible as an outline. Requires no image space computation and scales predictably with polygon count.

---

### Isenberg, T., Freudenberg, B., Halper, N., Schlechtweg, S. & Strothotte, T. (2003) — Silhouette Survey

**Full reference:** Isenberg, T., Freudenberg, B., Halper, N., Schlechtweg, S., & Strothotte, T. (2003). A developer's guide to silhouette algorithms for polygonal models. *IEEE Computer Graphics and Applications*, 23(4), 28–37.

**DOI:** `10.1109/MCG.2003.1210862`

**Physical file:** `Isenberg_2003_ADG.pdf` | **Bib key:** `isenberg2003`

**Core contribution.** Systematic survey of silhouette algorithms. Concludes that geometry-based methods are robust and distance-independent but structurally incapable of detecting internal surface detail — a key limitation for avatar rendering where facial features, clothing folds, and skin creases lie within, not on, the silhouette boundary.

---

### Barla, P., Thollot, J. & Markosian, L. (2006) — X-Toon Extended Toon Shading

**Full reference:** Barla, P., Thollot, J., & Markosian, L. (2006). X-Toon: An extended toon shader. In *Proceedings of the 4th International Symposium on Non-Photorealistic Animation and Rendering (NPAR)*, 127–132.

**DOI:** `10.1145/1124728.1124749`

**Physical file:** `x-toon.pdf` | **Bib key:** `barla2006`

**Core contribution.** Parameterises the shading tone ramp by both view angle and depth, enabling a two-dimensional lookup table (Normal Field Abstraction) that encodes artistic intent unavailable in a one-dimensional quantisation step. Introduced the concept of an abstraction axis alongside the standard lighting axis, allowing stylisation to vary with depth or view-dependent detail.

---

### Kyprianidis, J. E., Kang, H. & Döllner, J. (2009) — Anisotropic Kuwahara Filter

**Full reference:** Kyprianidis, J. E., Kang, H., & Döllner, J. (2009). Image and video abstraction by anisotropic Kuwahara filtering. *Computer Graphics Forum*, 28(7), 1955–1963.

**DOI:** `10.1111/j.1467-8659.2009.01574.x`

**Physical file:** `anisotropic_kuwahara.pdf` | **Bib key:** `kyprianidis2009`

**Core contribution.** Extended the isotropic Kuwahara filter with an anisotropic formulation aligned to local image structure, producing brush-stroke effects oriented along salient contours. The anisotropic extension requires a structure tensor computed from a prior render pass. In this thesis, the single-pass fragment hook constraint means only the isotropic variant is implementable on the Meta Avatar SDK.

---

### Praun, E., Hoppe, H., Webb, M. & Finkelstein, A. (2001) — Real-Time Hatching

**Full reference:** Praun, E., Hoppe, H., Webb, M., & Finkelstein, A. (2001). Real-time hatching. In *Proceedings of the 28th Annual Conference on Computer Graphics and Interactive Techniques (SIGGRAPH)*, 581–586.

**DOI:** `10.1145/383259.383328`

**Physical file:** `hatching.pdf` | **Bib key:** `praun2001`

**Core contribution.** Demonstrated real-time NPR hatching as a complementary branch of the NPR design space, in which tonal regions are conveyed by oriented stroke textures (tonal art maps) rather than flat fills or edge lines. Provides a reference point for texture-based tonal abstraction as an alternative to edge detection or quantised shading.

---

### Gonzalez, R. C. & Woods, R. E. (2018) — Digital Image Processing

**Full reference:** Gonzalez, R. C. & Woods, R. E. (2018). *Digital Image Processing* (4th ed.). Pearson.

**ISBN:** `9780133356724`

**Physical file:** `Gonzales,Woods-Digital.Image.Processing.4th.Edition.pdf` | **Bib key:** `gonzalez2018`

**Core contribution.** Foundational textbook covering discrete gradient approximation (Sobel operator, Roberts Cross operator), BT.601 luma coefficients for luminance conversion, and Gaussian pre-filtering for stable gradient computation. The mathematical formulations for all edge detection techniques in this thesis are grounded in this reference.

---

*Last updated: June 2026*
