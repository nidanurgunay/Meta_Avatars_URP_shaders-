# Cleaned/derived data files — what they are and how they were built

All four files below are **new, derived files**. The three original raw exports
(`Perception of Virtual Avatar Advisors-1/2/3.csv`) are untouched — every value in them is
preserved unchanged in the corresponding `_cleaned.csv`; nothing was deleted or overwritten,
only new columns appended.

- `Perception of Virtual Avatar Advisors-1_cleaned.csv` (Study Version A, n=17)
- `Perception of Virtual Avatar Advisors-2_cleaned.csv` (Study Version B, n=16)
- `Perception of Virtual Avatar Advisors-3_cleaned.csv` (Study Version C, n=19)
- `AllVersions_cleaned_merged.csv` — the three above concatenated (n=52), for convenience.

## Columns added (same 27 columns appended to each file)

**`study_version`** — A / B / C, from the confirmed positional mapping (file -1/-2/-3 → version A/B/C).

**`round1_condition`, `round2_condition`, `round3_condition`** — which condition (C1_Real /
C2_Realistic / C3_NPR) was actually shown in each round, per the Latin square:

| Version | Round 1 | Round 2 | Round 3 |
|---|---|---|---|
| A | C2_Realistic | C1_Real | C3_NPR |
| B | C3_NPR | C2_Realistic | C1_Real |
| C | C1_Real | C3_NPR | C2_Realistic |

**`R1_block_valid`, `R2_block_valid`, `R3_block_valid`** — `True` only if, for that round: the
"watched the video" box was checked, the comprehension-check answer (which job/route/option was
recommended) was correct, and the round's embedded attention check ("select option 2/4
regardless") was answered as instructed. Round 2 has no attention-check item in the form, so
only the watched + comprehension conditions apply there.

*Assumption made explicit:* the Methodology text states comprehension-check failure excludes
that block. It doesn't explicitly say the same for the attention check, but I've applied the
same rule to both since that's the standard purpose of an attention check — flag if you intended
something different.

**`P1_rank_valid`, `trust_rank_valid`, `unsettle_rank_valid`** — `False` if that participant
assigned a duplicate or missing rank across the three videos for that question (P1 = "most want
to consult"). A duplicate rank can't be used in Friedman/Wilcoxon as-is.

**`P1_rank_*`, `trust_rank_*`, `unsettle_rank_*`, `stylisation_*`** (12 columns, condition-
labelled) — the four post-study questions, remapped from Video 1/2/3 to condition using each
version's round order, **except Version C**, where the post-study section specifically uses the
displayed-thumbnail mapping (Video 1→C3_NPR, Video 2→C1_Real) rather than round order, per the
image-swap correction discussed and evidenced via the stylisation manipulation check.

**`demand_characteristics_flag`** — `True` if the closing open-text answer ("What do you think
this study was investigating?") contained a keyword suggesting the participant guessed the
realism/stylisation/trust manipulation (realistic, stylised, uncanny, trust, avatar, CGI,
cartoon, etc.). Simple keyword match, not a coded/reviewed classification — spot-check before
relying on it for the sensitivity analysis your Participants section already calls for.

**`multi_issue_flag`** — `True` if a participant has 3 or more of the 6 validity flags above
(`R1/R2/R3_block_valid`, `P1/trust/unsettle_rank_valid`) failing. Two participants trip this:
Form 2 row 14, Form 3 row 16 (both described in the earlier conversation). This is a flag only,
**not an automatic exclusion** — the Methodology text pre-registers block-level exclusion on
comprehension-check failure, not whole-participant exclusion for compounding issues, so whether
to drop these two entirely is a decision for you, not something applied silently here.

## Not yet done

- No participant or block has actually been *removed* — these files still contain all 52 raw
  rows with flags. The composite scoring (D/E/F/G item means, Cronbach's alpha check) and the
  actual hypothesis tests (H1–H4, TOST, H3 multilevel model, Friedman/Wilcoxon) haven't been run
  yet — this is the cleaned/flagged base to build those from next.
- The Anthropomorphism (Part C) non-administration and the Version C post-study swap still need
  their disclosure sentences drafted for Evaluation.
