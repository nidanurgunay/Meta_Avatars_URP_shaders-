"""
Main user study analysis pipeline.
Reads the cleaned/merged CSVs in ../user_study _results/ (which themselves preserve the
raw Google Forms exports untouched, per README_cleaned_data.md there).

Applies the pre-registered exclusion rules (block-level comprehension/attention check
failure, per-question duplicate-rank invalidation), computes composite scores, and runs
the analysis plan from 04_methodology.tex Sec. "Analysis Plan":
  - Cronbach's alpha reliability check per subscale (not in the pre-registered text, added
    per Bartneck et al. 2009's own recommendation before trusting any composite mean)
  - Manipulation check (Part I) one-way RM-ANOVA
  - Primary univariate RM-ANOVA + Bonferroni pairwise per subscale (B, D, E, F, G)
  - TOST equivalence (H2: C2 vs C3 trust composite; H4: C1 vs C3 trust composite), d=0.3
  - H3: person-centred multilevel regression, D_score predicting E/F/G per participant
  - Friedman + Wilcoxon (Bonferroni) on P1 / trustworthy / unsettling post-study rankings
  - Mixed-effects model cross-check (robustness against missing blocks from exclusions)
"""
import pandas as pd
import numpy as np
import pingouin as pg
from pathlib import Path

pd.set_option("display.width", 200)
pd.set_option("display.max_columns", 20)

DATA_DIR = Path("/Users/nidanurgunay/ThesisMetaAvatar/thesis/user_study _results")

# ---------------------------------------------------------------------------
# 1. Load and reshape to long format: one row per participant x round
# ---------------------------------------------------------------------------

ROUND_COLS = {
    1: dict(watched=7, comp=8, correct="Job A", attn_col=33, attn_expected="2",
            likeability=range(9, 14), eeriness=range(14, 22),
            competence=range(22, 25), benevolence=range(25, 28), integrity=range(28, 31),
            recommend_agree=31),
    2: dict(watched=35, comp=36, correct="Route B", attn_col=None, attn_expected=None,
            likeability=range(37, 42), eeriness=range(42, 50),
            competence=range(50, 53), benevolence=range(53, 56), integrity=range(56, 59),
            recommend_agree=59),
    3: dict(watched=62, comp=63, correct="Option A", attn_col=88, attn_expected="4",
            likeability=range(64, 69), eeriness=range(69, 77),
            competence=range(77, 80), benevolence=range(80, 83), integrity=range(83, 86),
            recommend_agree=86),
}

FILES = {
    "A": "Perception of Virtual Avatar Advisors-1.csv",
    "B": "Perception of Virtual Avatar Advisors-2.csv",
    "C": "Perception of Virtual Avatar Advisors-3.csv",
}
ROUND_CONDITION = {
    "A": {1: "C2_Realistic", 2: "C1_Real", 3: "C3_NPR"},
    "B": {1: "C3_NPR", 2: "C2_Realistic", 3: "C1_Real"},
    "C": {1: "C1_Real", 2: "C3_NPR", 3: "C2_Realistic"},
}

long_rows = []
item_rows = []  # keep raw items too, for Cronbach's alpha

for version, fname in FILES.items():
    df = pd.read_csv(DATA_DIR / fname, dtype=str, keep_default_na=False)
    for pidx, row in df.iterrows():
        pid = f"{version}_{pidx}"
        for rnd, cfg in ROUND_COLS.items():
            block_valid = (row.iloc[cfg["watched"]].strip() != "") and \
                          (row.iloc[cfg["comp"]].strip() == cfg["correct"])
            if cfg["attn_col"] is not None:
                block_valid = block_valid and (row.iloc[cfg["attn_col"]].strip() == cfg["attn_expected"])

            like_items = [float(row.iloc[c]) for c in cfg["likeability"]] if block_valid else None
            eerie_items = [float(row.iloc[c]) for c in cfg["eeriness"]] if block_valid else None
            comp_items = [float(row.iloc[c]) for c in cfg["competence"]] if block_valid else None
            benev_items = [float(row.iloc[c]) for c in cfg["benevolence"]] if block_valid else None
            integ_items = [float(row.iloc[c]) for c in cfg["integrity"]] if block_valid else None
            rec_agree = float(row.iloc[cfg["recommend_agree"]]) if block_valid else np.nan

            long_rows.append(dict(
                participant=pid, study_version=version, round=rnd,
                condition=ROUND_CONDITION[version][rnd],
                block_valid=block_valid,
                B_score=np.mean(like_items) if like_items else np.nan,
                D_score=np.mean(eerie_items) if eerie_items else np.nan,
                E_score=np.mean(comp_items) if comp_items else np.nan,
                F_score=np.mean(benev_items) if benev_items else np.nan,
                G_score=np.mean(integ_items) if integ_items else np.nan,
                H_recommend_agree=rec_agree,
            ))
            if block_valid:
                for i, v in enumerate(like_items):
                    item_rows.append(dict(participant=pid, condition=ROUND_CONDITION[version][rnd], subscale="Likeability", item=f"B{i+1}", value=v))
                for i, v in enumerate(eerie_items):
                    item_rows.append(dict(participant=pid, condition=ROUND_CONDITION[version][rnd], subscale="Eeriness", item=f"D{i+1}", value=v))
                for i, v in enumerate(comp_items):
                    item_rows.append(dict(participant=pid, condition=ROUND_CONDITION[version][rnd], subscale="Competence", item=f"E{i+1}", value=v))
                for i, v in enumerate(benev_items):
                    item_rows.append(dict(participant=pid, condition=ROUND_CONDITION[version][rnd], subscale="Benevolence", item=f"F{i+1}", value=v))
                for i, v in enumerate(integ_items):
                    item_rows.append(dict(participant=pid, condition=ROUND_CONDITION[version][rnd], subscale="Integrity", item=f"G{i+1}", value=v))

long_df_raw = pd.DataFrame(long_rows)
item_df_raw = pd.DataFrame(item_rows)

print(f"Total participants enrolled: {long_df_raw['participant'].nunique()}")
print(f"Total participant-rounds: {len(long_df_raw)}, valid blocks: {long_df_raw['block_valid'].sum()} / {len(long_df_raw)}")

# Whole-participant exclusion (per 04_methodology.tex Part A): a participant who
# fails any gating check (comprehension or attention) in any block is dropped
# entirely, not just for that block, since the checks are not present
# identically across all three blocks (no attention item in Round 2).
valid_counts = long_df_raw.groupby("participant")["block_valid"].sum()
clean_ids = set(valid_counts[valid_counts == 3].index)
print(f"Clean participants (3/3 valid blocks): {len(clean_ids)} of {long_df_raw['participant'].nunique()}")

long_df = long_df_raw[long_df_raw["participant"].isin(clean_ids)].copy()
item_df = item_df_raw[item_df_raw["participant"].isin(clean_ids)].copy()

long_df.to_csv(DATA_DIR / "long_format_scores_clean.csv", index=False)
item_df.to_csv(DATA_DIR / "long_format_items_clean.csv", index=False)
print("\nSaved long_format_scores_clean.csv and long_format_items_clean.csv")

# ---------------------------------------------------------------------------
# 2. Reliability check (Cronbach's alpha) per subscale, overall and per condition
# ---------------------------------------------------------------------------
print("\n" + "=" * 70)
print("STEP 2: Reliability (Cronbach's alpha)")
print("=" * 70)

for subscale in ["Likeability", "Eeriness", "Competence", "Benevolence", "Integrity"]:
    sub = item_df[item_df["subscale"] == subscale]
    wide = sub.pivot_table(index=["participant", "condition"], columns="item", values="value")
    alpha_overall = pg.cronbach_alpha(data=wide)
    print(f"\n{subscale} (k={wide.shape[1]} items, n_obs={len(wide)}): overall alpha = {alpha_overall[0]:.3f} (95% CI {alpha_overall[1]})")
    for cond in ["C1_Real", "C2_Realistic", "C3_NPR"]:
        w = wide.xs(cond, level="condition")
        a = pg.cronbach_alpha(data=w)
        print(f"    {cond}: alpha = {a[0]:.3f} (n={len(w)})")

# ---------------------------------------------------------------------------
# 3. Wide format (one row per participant), + post-study measures from the
#    per-form cleaned CSVs (stylisation, P1/trust/unsettle ranks)
# ---------------------------------------------------------------------------
print("\n" + "=" * 70)
print("STEP 3: Wide format + manipulation check (Part I, stylisation)")
print("=" * 70)

wide_scores = long_df.pivot_table(
    index="participant", columns="condition",
    values=["B_score", "D_score", "E_score", "F_score", "G_score"]
)
wide_scores.columns = [f"{c}_{s}" for s, c in wide_scores.columns]
wide_scores = wide_scores.reset_index()

poststudy_frames = []
for version, fname in FILES.items():
    cdf = pd.read_csv(DATA_DIR / fname.replace(".csv", "_cleaned.csv"), dtype=str, keep_default_na=False)
    cdf = cdf.reset_index().rename(columns={"index": "pidx"})
    cdf["participant"] = version + "_" + cdf["pidx"].astype(str)
    keep = ["participant", "demand_characteristics_flag", "multi_issue_flag",
            "P1_rank_valid", "trust_rank_valid", "unsettle_rank_valid"]
    for q in ["P1_rank", "trust_rank", "unsettle_rank", "stylisation"]:
        for cond in ["C1_Real", "C3_NPR", "C2_Realistic"]:
            keep.append(f"{q}_{cond}")
    poststudy_frames.append(cdf[keep])
poststudy = pd.concat(poststudy_frames, ignore_index=True)

bool_cols = ["demand_characteristics_flag", "multi_issue_flag",
             "P1_rank_valid", "trust_rank_valid", "unsettle_rank_valid"]
for col in poststudy.columns:
    if col in bool_cols:
        poststudy[col] = poststudy[col].map({"True": True, "False": False})
    elif col != "participant":
        poststudy[col] = pd.to_numeric(poststudy[col], errors="coerce")

wide = wide_scores.merge(poststudy, on="participant", how="left")
wide = wide[wide["participant"].isin(clean_ids)].copy()
wide.to_csv(DATA_DIR / "wide_format_participant_clean.csv", index=False)
print(f"Wide-format participant table (clean): {wide.shape[0]} rows, {wide.shape[1]} cols. Saved wide_format_participant_clean.csv")

# Manipulation check: stylisation rating, one-way RM-ANOVA across conditions
styl_long = wide.melt(id_vars="participant",
                       value_vars=["stylisation_C1_Real", "stylisation_C3_NPR", "stylisation_C2_Realistic"],
                       var_name="condition", value_name="stylisation")
styl_long["condition"] = styl_long["condition"].str.replace("stylisation_", "", regex=False)
styl_long["stylisation"] = pd.to_numeric(styl_long["stylisation"], errors="coerce")
styl_long = styl_long.dropna(subset=["stylisation"])

print("\nDescriptives:")
print(styl_long.groupby("condition")["stylisation"].agg(["mean", "std", "count"]))

def report_rm_anova(long_data, dv, label):
    aov = pg.rm_anova(data=long_data, dv=dv, within="condition", subject="participant", detailed=True)
    ss_eff, ss_err = aov.loc[0, "SS"], aov.loc[1, "SS"]
    df_eff, df_err = aov.loc[0, "DF"], aov.loc[1, "DF"]
    F, p_unc = aov.loc[0, "F"], aov.loc[0, "p_unc"]
    sph_ok = aov.loc[0, "sphericity"] if "sphericity" in aov.columns else True
    partial_eta2 = ss_eff / (ss_eff + ss_err)
    if sph_ok or "p_GG_corr" not in aov.columns:
        p_str = f"p_unc={p_unc:.4f}"
    else:
        p_gg = aov.loc[0, "p_GG_corr"]
        p_str = f"p_GG={p_gg:.4f} (sphericity violated, W={aov.loc[0,'W_spher']:.3f}, p_spher={aov.loc[0,'p_spher']:.2e})"
    print(f"\n{label}: F({df_eff:.0f},{df_err:.0f})={F:.2f}, {p_str}, partial eta^2={partial_eta2:.3f}")
    pw = pg.pairwise_tests(data=long_data, dv=dv, within="condition", subject="participant", padjust="bonf")
    print(pw[["A", "B", "T", "p_unc", "p_corr", "hedges"]].to_string(index=False))
    return aov, pw

report_rm_anova(styl_long, "stylisation", "Manipulation check (Part I stylisation) RM-ANOVA")

# ---------------------------------------------------------------------------
# 4. Primary analysis: univariate RM-ANOVA + Bonferroni pairwise per subscale
#    (B, D, E, F, G) -- H1 (D) and part of H2 (E,F,G vs C2) groundwork.
#    Note: C_score (Anthropomorphism) does not exist -- Part C was never
#    administered in the live form (confirmed against the form PDF).
# ---------------------------------------------------------------------------
print("\n" + "=" * 70)
print("STEP 4: Primary univariate RM-ANOVA per subscale (B, D, E, F, G)")
print("=" * 70)

SUBSCALE_LABELS = {
    "B_score": "Likeability (B)", "D_score": "Eeriness (D) -- H1",
    "E_score": "Competence (E)", "F_score": "Benevolence (F)", "G_score": "Integrity (G)",
}
results_anova = {}
for score_col, label in SUBSCALE_LABELS.items():
    sub_long = long_df.dropna(subset=[score_col])[["participant", "condition", score_col]]
    n_complete = sub_long.groupby("participant").size()
    complete_ids = n_complete[n_complete == 3].index
    sub_long = sub_long[sub_long["participant"].isin(complete_ids)]
    print(f"\n--- {label} --- (n complete cases = {len(complete_ids)})")
    print(sub_long.groupby("condition")[score_col].agg(["mean", "std"]))
    aov, pw = report_rm_anova(sub_long, score_col, label)
    results_anova[score_col] = (aov, pw)

# ---------------------------------------------------------------------------
# 5. TOST equivalence tests: H2 (C2 vs C3 trust composite), H4 (C1 vs C3)
#    Trust composite = mean(E_score, F_score, G_score) per participant/condition.
#    Bound = Cohen's d = 0.3, converted to raw units via pooled SD (paired-diff SD).
# ---------------------------------------------------------------------------
print("\n" + "=" * 70)
print("STEP 5: TOST equivalence tests (H2: C2 vs C3, H4: C1 vs C3), d=0.3 bound")
print("=" * 70)

long_df["Trust_score"] = long_df[["E_score", "F_score", "G_score"]].mean(axis=1)
trust_wide = long_df.dropna(subset=["Trust_score"]).pivot(index="participant", columns="condition", values="Trust_score")

def run_tost(df, cond_a, cond_b, label, d_bound=0.3):
    sub = df[[cond_a, cond_b]].dropna()
    diff = sub[cond_a] - sub[cond_b]
    pooled_sd = np.sqrt((sub[cond_a].var(ddof=1) + sub[cond_b].var(ddof=1)) / 2)
    bound_raw = d_bound * pooled_sd
    res = pg.tost(sub[cond_a], sub[cond_b], bound=bound_raw, paired=True)
    print(f"\n{label} (n={len(sub)}): mean diff={diff.mean():.3f}, pooled SD={pooled_sd:.3f}, "
          f"raw bound=+-{bound_raw:.3f} (d={d_bound})")
    print(res)
    return res

run_tost(trust_wide, "C2_Realistic", "C3_NPR", "H2 TOST: C2 (Realistic) vs C3 (NPR)")
run_tost(trust_wide, "C1_Real", "C3_NPR", "H4 TOST: C1 (Real) vs C3 (NPR)")

# ---------------------------------------------------------------------------
# 6. H3: person-centred multilevel regression, D_score (eeriness, centred)
#    predicting each trust subscale (E, F, G), random intercept per participant.
# ---------------------------------------------------------------------------
print("\n" + "=" * 70)
print("STEP 6: H3 -- person-centred multilevel regression (D_score -> E/F/G)")
print("=" * 70)
import statsmodels.formula.api as smf

h3_df = long_df.dropna(subset=["D_score", "E_score", "F_score", "G_score"]).copy()
h3_df["D_person_mean"] = h3_df.groupby("participant")["D_score"].transform("mean")
h3_df["D_centered"] = h3_df["D_score"] - h3_df["D_person_mean"]

for dv in ["E_score", "F_score", "G_score"]:
    model = smf.mixedlm(f"{dv} ~ D_centered", data=h3_df, groups=h3_df["participant"])
    fit = model.fit(reml=True)
    b = fit.params["D_centered"]
    ci = fit.conf_int().loc["D_centered"]
    p = fit.pvalues["D_centered"]
    var_re = fit.cov_re.iloc[0, 0]
    var_resid = fit.scale
    icc = var_re / (var_re + var_resid)
    print(f"\n{dv} ~ D_centered (n_obs={len(h3_df)}, n_participants={h3_df['participant'].nunique()}):")
    print(f"  b={b:.3f}, 95% CI=[{ci[0]:.3f}, {ci[1]:.3f}], p={p:.4f}, ICC={icc:.3f}")

# ---------------------------------------------------------------------------
# 7. Post-study rankings: Friedman + Bonferroni-corrected Wilcoxon
#    (P1 advisor selection, trustworthy, unsettling). Respects rank-validity
#    flags (drops participants with a duplicate/missing rank for that question).
# ---------------------------------------------------------------------------
print("\n" + "=" * 70)
print("STEP 7: Post-study rankings -- Friedman + Wilcoxon (Bonferroni)")
print("=" * 70)
from scipy.stats import friedmanchisquare, wilcoxon

def run_ranking(qname, valid_col):
    cols = [f"{qname}_C1_Real", f"{qname}_C3_NPR", f"{qname}_C2_Realistic"]
    sub = wide[wide[valid_col] == True][["participant"] + cols].dropna()
    print(f"\n--- {qname} (n={len(sub)}) ---")
    print(sub[cols].mean())
    chi2, p = friedmanchisquare(sub[cols[0]], sub[cols[1]], sub[cols[2]])
    print(f"Friedman chi2={chi2:.2f}, df=2, p={p:.4f}")
    pairs = [("C1_Real", "C2_Realistic"), ("C1_Real", "C3_NPR"), ("C2_Realistic", "C3_NPR")]
    for a, b in pairs:
        ca, cb = f"{qname}_{a}", f"{qname}_{b}"
        stat, pw = wilcoxon(sub[ca], sub[cb])
        p_corr = min(pw * 3, 1.0)
        print(f"  {a} vs {b}: W={stat:.1f}, p_unc={pw:.4f}, p_corr(bonf)={p_corr:.4f}")
    return sub

run_ranking("P1_rank", "P1_rank_valid")
run_ranking("trust_rank", "trust_rank_valid")
run_ranking("unsettle_rank", "unsettle_rank_valid")

# ---------------------------------------------------------------------------
# 8. Mixed-effects model robustness check (Canales et al. 2024 approach):
#    uses ALL valid blocks (not just complete-case participants dropped by
#    listwise deletion in the RM-ANOVA above), participant random intercept.
# ---------------------------------------------------------------------------
print("\n" + "=" * 70)
print("STEP 8: Mixed-effects model cross-check (all valid blocks, not just complete cases)")
print("=" * 70)

for dv, label in [("D_score", "Eeriness (H1)"), ("Trust_score", "Trust composite (H2/H4)")]:
    sub = long_df.dropna(subset=[dv]).copy()
    model = smf.mixedlm(f"{dv} ~ C(condition, Treatment('C2_Realistic'))", data=sub, groups=sub["participant"])
    fit = model.fit(reml=True)
    print(f"\n{label} ~ condition (ref=C2_Realistic), n_obs={len(sub)}, n_participants={sub['participant'].nunique()}:")
    print(fit.summary().tables[1].to_string())
