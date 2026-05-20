---
title: "User Study Roadmap: Trust in NPR and Non-NPR Avatars"
author: "Master Thesis Planning Document"
date: "2026-05-20"
geometry: margin=1in
fontsize: 11pt
---

# User Study Roadmap: Trust in NPR and Non-NPR Avatars

## 1. Study Purpose

The purpose of this study is to evaluate how avatar rendering style affects human trust in a virtual advisor. The study compares:

- NPR avatar: the avatar rendered with the selected non-photorealistic rendering style.
- Non-NPR avatar: a more realistic or conventionally rendered avatar, for example an Avaturn avatar without NPR effects.

The intended final study is an online video-based experiment. Participants watch short pre-recorded avatar recommendation videos and answer questions about trust, comfort, realism, eeriness, social presence, and willingness to follow the avatar's advice.

This design is suitable for a master thesis because it controls the interaction carefully. Every participant sees the same script, same timing, same camera angle, and same advisor behavior. The main manipulated variable is the avatar rendering style.

## 2. Main Research Question

How does non-photorealistic rendering affect perceived trust in virtual avatar advisors compared with a non-NPR avatar rendering?

## 3. Possible Hypotheses

- H1: NPR rendering will affect perceived trust compared with non-NPR rendering.
- H2: NPR rendering may reduce perceived eeriness compared with a more realistic non-NPR avatar.
- H3: Perceived eeriness will negatively predict trust.
- H4: Perceived competence and social presence will positively predict trust.
- H5: Participants will be more willing to follow advice from the avatar style they rate as more trustworthy and comfortable.

## 4. Recommended Study Type

Use a within-subjects online video study.

Each participant should watch videos from both avatar conditions:

- NPR condition
- Non-NPR condition

The order should be counterbalanced so that some participants see NPR first and others see non-NPR first. This reduces order effects.

The study can be distributed online through Qualtrics, LimeSurvey, Google Forms, Prolific, or a university survey system. Qualtrics or LimeSurvey are better than Google Forms because they support randomization and cleaner experimental control.

## 5. Why A Video-Based Study Is Scientific

A video-based study is scientifically valid if the limitation is clearly reported. The study does not measure live VR interaction. Instead, it measures perceived trust toward controlled pre-recorded avatar advisors.

This is useful because:

- Every participant receives the same stimuli.
- The avatar performance can be held constant.
- The same facial performance can be rendered in different styles.
- The study can reach more participants online.
- It avoids technical problems from running VR experiments remotely.

Suggested limitation statement:

"This study evaluates perceived trust toward pre-recorded avatar advisors in online video scenarios. It does not measure real-time embodied interaction or live conversational trust."

## 6. Avatar And Recording Pipeline

The current direction is:

1. Select the best NPR technique and parameters through a small pilot.
2. Use a more realistic avatar source, such as Avaturn, for the non-NPR baseline.
3. Record the same advisor performance using face tracking or facial animation.
4. Render the same scenario videos in two conditions:
   - NPR avatar
   - Non-NPR avatar
5. Upload the videos into an online survey.
6. Collect trust, perception, and preference responses.

Important control variables:

- Same script
- Same voice
- Same advisor identity where possible
- Same facial performance
- Same camera angle
- Same background
- Same lighting
- Same video length
- Same audio volume

Only the rendering style should change.

## 7. Stimulus Selection / NPR Pilot

Before the main user study, run a small pilot with 5-10 people to choose the best NPR style.

Test several NPR versions, for example:

- Toon/cel shading with subtle outlines
- Soft painterly/Kuwahara abstraction
- Technical illustration/Gooch-like shading
- Hatching or sketch style, only if temporally stable

Pilot questions:

- Which style looks most suitable for a virtual advisor?
- Which style has the clearest facial expressions?
- Which style is least distracting?
- Which style feels most trustworthy?
- Which style feels least uncanny?

After this pilot, choose one NPR style for the main study. The main study should not compare many NPR styles unless there is enough time and enough participants. A clean thesis comparison is:

NPR avatar vs non-NPR avatar.

## 8. Final Study Scenarios

The final decision was to use three recommendation scenarios. The avatar acts as a virtual advisor and gives a recommendation. After each video, participants answer the questionnaire.

Each video should be around 30-60 seconds.

### Scenario 1: Academic Advisor

Participant context:

"You are a master student choosing between two thesis project directions. Project A is technically ambitious and may produce impressive results, but it has higher risk because the implementation is complex. Project B is simpler and easier to finish on time, but it may be less novel. A virtual academic advisor will now give you a recommendation."

Avatar script:

"I recommend Project B. For a master thesis, finishing a complete and well-evaluated system is usually more important than attempting a very ambitious prototype that may remain unfinished. Project A is interesting, but it has several technical risks. Project B gives you a clearer research question, a more realistic timeline, and enough space for a strong user study. If this were my decision, I would choose Project B."

What this scenario measures:

- Trust in academic guidance
- Perceived competence
- Willingness to follow advice in a personally relevant decision

### Scenario 2: Travel And Safety Advisor

Participant context:

"You are visiting an unfamiliar city and need to reach your hotel at night. Route A is faster, but it has several transfers and some areas with low lighting. Route B is slower, but it is simpler and goes through a busy central area. A virtual travel assistant will now give you a recommendation."

Avatar script:

"I recommend Route B. It takes about ten minutes longer, but it is easier to follow and safer at night. Route A may look efficient, but the transfers increase the chance of mistakes. Since you are unfamiliar with the city, I would choose the route that is more predictable and comfortable."

What this scenario measures:

- Trust in practical advice
- Perceived care/benevolence
- Willingness to rely on avatar advice under mild uncertainty

### Scenario 3: Information Reliability Advisor

Participant context:

"You are preparing a short academic presentation and found two online sources. Source A is a blog post with strong claims but no references. Source B is a university page with fewer dramatic details but clear citations and institutional authorship. A virtual research assistant will now give you a recommendation."

Avatar script:

"I recommend Source B. Even though it contains less dramatic information, it is more reliable because it provides institutional authorship and references. Source A may be useful for finding ideas, but I would not rely on it as the main source for an academic presentation."

What this scenario measures:

- Trust in information evaluation
- Perceived reliability
- Willingness to accept advice about source credibility

## 9. Suggested Online Study Flow

1. Consent form
2. Short explanation of the task
3. Demographic and background questions
4. Video 1
5. Questionnaire after Video 1
6. Video 2
7. Questionnaire after Video 2
8. Video 3
9. Questionnaire after Video 3
10. Final comparison questions
11. Debriefing page

Recommended instruction:

"Please complete this study on a laptop or desktop computer with headphones. Watch each video carefully. After each video, answer the questions based on your immediate impression of the avatar advisor."

Target duration:

- Ideal: 8-12 minutes
- Maximum: 15 minutes

## 10. Counterbalancing

The study should avoid showing only one fixed order. A simple counterbalanced design:

Group A:

- Scenario 1: NPR
- Scenario 2: non-NPR
- Scenario 3: NPR

Group B:

- Scenario 1: non-NPR
- Scenario 2: NPR
- Scenario 3: non-NPR

Better version:

Use more survey versions so that each scenario appears equally often with NPR and non-NPR across participants.

## 11. Questionnaire After Each Video

Use a 7-point Likert scale:

1 = strongly disagree  
7 = strongly agree

Trust:

- I trusted the avatar's recommendation.
- I would follow this avatar's advice.
- The avatar seemed reliable.
- The avatar seemed competent.
- The avatar seemed honest.
- The avatar seemed confident in its recommendation.

Comfort and eeriness:

- The avatar felt eerie.
- The avatar felt strange or unsettling.
- I felt comfortable watching this avatar.
- I would be comfortable interacting with this avatar in the future.
- The avatar's appearance distracted me from the recommendation.

Rendering and expression:

- The avatar looked natural.
- The avatar's visual style was appropriate for the scenario.
- The avatar looked professional.
- The avatar's facial expressions were clear.
- The avatar's speech and facial expressions matched well.

Behavioral trust:

- Would you follow the avatar's recommendation? Yes / No / Not sure
- How confident are you in your own decision? 1-7

Open question:

- What influenced your trust or distrust in this avatar?

## 12. Final Comparison Questions

At the end of the study, ask:

- Which avatar style did you trust more?
- Which avatar style felt more suitable for a virtual advisor?
- Which avatar style felt more natural?
- Which avatar style felt less uncanny?
- Which avatar style would you prefer in a real VR or online assistant?
- Please briefly explain your preference.

## 13. Participants

For a master thesis:

- Minimum: 30-40 participants
- Better: 60-100 participants
- Strong online study: 100+ participants

Useful background variables:

- Age
- Gender, optional
- VR experience
- Gaming experience
- Experience with virtual avatars
- Familiarity with Meta avatars or realistic digital humans
- Device used for the study
- Whether headphones were used

## 14. Analysis Plan

Main comparison:

- Mean trust score for NPR
- Mean trust score for non-NPR

Possible statistical tests:

- Paired-samples t-test for NPR vs non-NPR trust ratings
- Wilcoxon signed-rank test if the data is not normally distributed
- Repeated-measures ANOVA or linear mixed model if scenario type is included as a factor

Additional analyses:

- Compare eeriness between NPR and non-NPR.
- Test whether eeriness predicts trust.
- Test whether perceived competence predicts trust.
- Test whether social presence predicts trust.
- Compare behavioral willingness to follow advice across avatar styles.

## 15. Practical Timeline

Week 1:

- Finalize research question and hypotheses.
- Finalize the three scripts.
- Draft questionnaire.

Week 2:

- Test NPR techniques and choose candidate parameters.
- Run small stimulus-selection pilot.

Week 3:

- Finalize realistic/non-NPR avatar.
- Record or generate facial animation for all three scenarios.
- Render NPR and non-NPR video versions.

Week 4:

- Build the online survey.
- Pilot with 5-10 participants.
- Fix unclear questions, loading issues, and video quality issues.

Weeks 5-6:

- Collect main study data.

Week 7:

- Clean data and run analysis.

Weeks 8-9:

- Write method, results, discussion, and limitations.

## 16. Key Academic Sources And Links

Avatar stylization and trust:

- Canales, Roble, and Neff. "The Impact of Avatar Stylization on Trust." IEEE VR 2024.  
  https://www.cs.ucdavis.edu/~neff/papers/Avatar_Stylization_and_Trust_IEEE_VR_2024.pdf

- Alimardani et al. "Effect of a Virtual Agent's Appearance and Voice on Uncanny Valley and Trust in Human-Agent Collaboration." IVA 2024.  
  https://research.vu.nl/en/publications/effect-of-a-virtual-agents-appearance-and-voice-on-uncanny-valley/

- Gao et al. "Trust in Virtual Agents: Exploring the Role of Stylization and Voice." IEEE TVCG 2025.  
  https://www.researchgate.net/publication/389696018_Trust_in_Virtual_Agents_Exploring_the_Role_of_Stylization_and_Voice

Trust measurement:

- Jian, Bisantz, and Drury. "Foundations for an Empirically Determined Scale of Trust in Automated Systems." International Journal of Cognitive Ergonomics, 2000.  
  https://doi.org/10.1207/S15327566IJCE0401_04

- Mayer, Davis, and Schoorman. "An Integrative Model of Organizational Trust." Academy of Management Review, 1995.  
  https://doi.org/10.5465/amr.1995.9508080335

- Schaefer. "Measuring Trust in Human Robot Interactions: Development of the Trust Perception Scale-HRI."  
  https://link.springer.com/chapter/10.1007/978-1-4899-7668-0_10

Avatar perception, social presence, and uncanny valley:

- Bartneck, Kulic, Croft, and Zoghbi. "Measurement Instruments for the Anthropomorphism, Animacy, Likeability, Perceived Intelligence, and Perceived Safety of Robots." International Journal of Social Robotics, 2009.  
  https://www.bartneck.de/publications/2009/measurementInstrumentsRobots/bartneckCroftKulicZogbiSORO2009.pdf

- Ho and MacDorman. "Revisiting the Uncanny Valley Theory: Developing and Validating an Alternative to the Godspeed Indices." Computers in Human Behavior, 2010.  
  https://www.macdorman.com/kfm/writings/pubs/Ho2010UncannyValleyIndices.pdf

- Biocca, Harms, and Burgoon. "Toward a More Robust Theory and Measure of Social Presence." Presence, 2003.  
  https://www.researchgate.net/publication/200772411_The_Networked_Minds_Measure_of_Social_Presence_Pilot_Test_of_the_Factor_Structure_and_Concurrent_Validity

NPR and abstraction techniques:

- Kyprianidis et al. "State of the Art: A Taxonomy of Artistic Stylization Techniques for Images and Video." IEEE TVCG, 2013.  
  https://www.kyprianidis.com/p/tvcg2013/

- Winnemoller, Olsen, and Gooch. "Real-Time Video Abstraction." ACM Transactions on Graphics, 2006.  
  https://cs.colby.edu/courses/S19/cs365/papers/winnemoller-videoAbstraction-SIG06.pdf

- DeCarlo et al. "Suggestive Contours for Conveying Shape." ACM Transactions on Graphics, 2003.  
  https://gfx.cs.princeton.edu/gfx/pubs/DeCarlo_2003_SCF/index.php

- Gooch et al. "A Non-Photorealistic Lighting Model for Automatic Technical Illustration." SIGGRAPH, 1998.  
  https://www.cs.princeton.edu/courses/archive/fall2000/cs597b/papers/gooch98.pdf

## 17. Recommended Final Thesis Framing

Suggested title:

"The Effect of Non-Photorealistic Rendering on User Trust in Virtual Avatar Advisors"

Suggested method summary:

"This thesis investigates whether non-photorealistic rendering affects perceived trust in virtual avatar advisors. Participants complete an online video-based study in which they watch three short recommendation scenarios. Each scenario presents an avatar advisor giving a recommendation. The study compares an NPR-rendered avatar with a non-NPR avatar while keeping script, voice, camera angle, background, and advisor behavior constant. After each video, participants rate trust, perceived competence, comfort, eeriness, visual appropriateness, and willingness to follow the recommendation."

