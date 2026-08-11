"""
Publication-quality figures for the user study results (Evaluation chapter).

Reads long_format_scores.csv and wide_format_participant.csv, both produced by
main_study_analysis.py in this same folder -- run that script first.

Palette: the three conditions use slots 1-3 (blue/orange/aqua) of the project's
validated categorical palette, chosen because that specific 3-slot subset passes
the CVD/normal-vision separation checks for ALL pairwise comparisons (not just
adjacent), which matters here since every condition is compared against every
other condition in the analysis. Validated via the dataviz skill's
scripts/validate_palette.js (worst-pair CVD dE 9.2, normal-vision dE 24.0).

Output: PDF (vector, for LaTeX \\includegraphics) + PNG (300dpi, for quick preview)
in thesis/figures/user Study/.
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import pingouin as pg
from pathlib import Path
from scipy.stats import wilcoxon

DATA_DIR = Path("/Users/nidanurgunay/ThesisMetaAvatar/thesis/user_study _results")
FIG_DIR = Path("/Users/nidanurgunay/ThesisMetaAvatar/thesis/figures/user_study")
FIG_DIR.mkdir(parents=True, exist_ok=True)

ORDER = ["C1_Real", "C2_Realistic", "C3_NPR"]
COLORS = {"C1_Real": "#2a78d6", "C2_Realistic": "#eb6834", "C3_NPR": "#1baf7a"}
LABELS = {"C1_Real": "Real\n(C1)", "C2_Realistic": "Photorealistic\n(C2)", "C3_NPR": "NPR\n(C3)"}

plt.rcParams.update({
    "font.family": "sans-serif",
    "font.size": 10.5,
    "axes.edgecolor": "#898781",
    "axes.linewidth": 0.8,
    "axes.labelcolor": "#0b0b0b",
    "text.color": "#0b0b0b",
    "xtick.color": "#52514e",
    "ytick.color": "#52514e",
    "axes.spines.top": False,
    "axes.spines.right": False,
    "axes.grid": True,
    "grid.color": "#e1e0d9",
    "grid.linewidth": 0.6,
    "axes.axisbelow": True,
    "figure.dpi": 150,
    "savefig.dpi": 300,
    "savefig.bbox": "tight",
})


def save(fig, name):
    fig.savefig(FIG_DIR / f"{name}.pdf")
    fig.savefig(FIG_DIR / f"{name}.png")
    plt.close(fig)
    print(f"Saved {name}.pdf / .png")


def cousineau_morey(df, subject_col, cond_col, value_col, conditions=ORDER):
    """Within-subject corrected mean/SEM for repeated-measures bar charts
    (Cousineau 2005, Morey 2008 correction) -- avoids overstating uncertainty
    from between-subject variance that the RM-ANOVA already factors out."""
    wide = df.pivot(index=subject_col, columns=cond_col, values=value_col)[conditions].dropna()
    grand_mean = wide.values.mean()
    subj_means = wide.mean(axis=1)
    normed = wide.sub(subj_means, axis=0).add(grand_mean)
    n_cond = wide.shape[1]
    correction = np.sqrt(n_cond / (n_cond - 1))
    sems = normed.std(axis=0, ddof=1) / np.sqrt(len(wide)) * correction
    means = wide.mean(axis=0)
    return means, sems, len(wide), wide


def stars(p):
    if p < .001:
        return "***"
    if p < .01:
        return "**"
    if p < .05:
        return "*"
    return "ns"


def bracket(ax, x1, x2, y, h, label, lw=1.0):
    ax.plot([x1, x1, x2, x2], [y, y + h, y + h, y], lw=lw, color="#0b0b0b", clip_on=False)
    ax.text((x1 + x2) / 2, y + h, label, ha="center", va="bottom", fontsize=9.5)


def bar_panel(ax, means, sems, n, ylim, ylabel, title, pairwise=None, bracket_top=None):
    x = np.arange(3)
    bars = ax.bar(x, [means[c] for c in ORDER], yerr=[sems[c] for c in ORDER],
                   color=[COLORS[c] for c in ORDER], edgecolor="#0b0b0b", linewidth=0.8,
                   width=0.62, capsize=4,
                   error_kw=dict(elinewidth=1.1, ecolor="#0b0b0b", capthick=1.1))
    ax.set_xticks(x)
    ax.set_xticklabels([LABELS[c] for c in ORDER], fontsize=9.5)
    ax.set_ylim(*ylim)
    ax.set_ylabel(ylabel)
    ax.set_title(f"{title}  (n={n})", fontsize=11, pad=8)
    for b, c in zip(bars, ORDER):
        ax.text(b.get_x() + b.get_width() / 2, means[c] + sems[c] + 0.02 * (ylim[1] - ylim[0]),
                 f"{means[c]:.2f}", ha="center", va="bottom", fontsize=8.5, color="#52514e")
    if pairwise is not None:
        span = ylim[1] - ylim[0]
        top = bracket_top if bracket_top is not None else ylim[1] - 0.12 * span
        step = 0.11 * span
        pair_x = {("C1_Real", "C2_Realistic"): (0, 1), ("C1_Real", "C3_NPR"): (0, 2),
                  ("C2_Realistic", "C3_NPR"): (1, 2)}
        for i, (pair, p) in enumerate(pairwise.items()):
            x1, x2 = pair_x[pair]
            bracket(ax, x1, x2, top - i * step, 0.02 * span, stars(p))
    return bars


# ---------------------------------------------------------------------------
# Load data
# ---------------------------------------------------------------------------
long_df = pd.read_csv(DATA_DIR / "long_format_scores.csv")
wide = pd.read_csv(DATA_DIR / "wide_format_participant.csv")
long_df["Trust_score"] = long_df[["E_score", "F_score", "G_score"]].mean(axis=1)


def get_pairwise(df, dv):
    sub = df.dropna(subset=[dv])[["participant", "condition", dv]]
    n_complete = sub.groupby("participant").size()
    sub = sub[sub["participant"].isin(n_complete[n_complete == 3].index)]
    pw = pg.pairwise_tests(data=sub, dv=dv, within="condition", subject="participant", padjust="bonf")
    out = {}
    for _, row in pw.iterrows():
        key = (row["A"], row["B"]) if (row["A"], row["B"]) in [
            ("C1_Real", "C2_Realistic"), ("C1_Real", "C3_NPR"), ("C2_Realistic", "C3_NPR")
        ] else (row["B"], row["A"])
        out[key] = row["p_corr"]
    return out


# ---------------------------------------------------------------------------
# Figure 1: Manipulation check (Part I stylisation)
# ---------------------------------------------------------------------------
styl_long = wide.melt(id_vars="participant",
                       value_vars=[f"stylisation_{c}" for c in ORDER],
                       var_name="condition", value_name="stylisation")
styl_long["condition"] = styl_long["condition"].str.replace("stylisation_", "", regex=False)
styl_long["stylisation"] = pd.to_numeric(styl_long["stylisation"], errors="coerce")
styl_long = styl_long.dropna(subset=["stylisation"])

means, sems, n, _ = cousineau_morey(styl_long, "participant", "condition", "stylisation")
pw = get_pairwise(styl_long.rename(columns={"stylisation": "styl"}), "styl")

fig, ax = plt.subplots(figsize=(4.6, 4.2))
bar_panel(ax, means, sems, n, (1, 7.6), "Stylisation rating (1=realistic, 7=stylised)",
          "Manipulation check", pairwise=pw, bracket_top=6.7)
fig.tight_layout()
save(fig, "fig_manipulation_check")

# ---------------------------------------------------------------------------
# Figure 2: Subscale grid (B, D, E, F, G)
# ---------------------------------------------------------------------------
SUBSCALES = [
    ("B_score", "Likeability", (1, 5), 4.55),
    ("D_score", "Eeriness (H1)", (1, 5), 4.55),
    ("E_score", "Competence", (1, 7), 6.5),
    ("F_score", "Benevolence", (1, 7), 6.5),
    ("G_score", "Integrity", (1, 7), 6.5),
]

fig, axes = plt.subplots(2, 3, figsize=(11.5, 7.6))
axes = axes.flatten()
for i, (col, title, ylim, btop) in enumerate(SUBSCALES):
    means, sems, n, _ = cousineau_morey(long_df, "participant", "condition", col)
    pw = get_pairwise(long_df, col)
    bar_panel(axes[i], means, sems, n, ylim, "Mean rating", title, pairwise=pw, bracket_top=btop)
axes[-1].axis("off")
handles = [plt.Rectangle((0, 0), 1, 1, color=COLORS[c]) for c in ORDER]
axes[-1].legend(handles, [LABELS[c].replace("\n", " ") for c in ORDER],
                 loc="center", frameon=False, fontsize=11, title="Condition")
fig.suptitle("Per-block subscale ratings by condition (Bonferroni-corrected pairwise: * p<.05, ** p<.01, *** p<.001, ns = not significant)",
             fontsize=10.5, y=1.01)
fig.tight_layout()
save(fig, "fig_subscales_grid")

# ---------------------------------------------------------------------------
# Figure 3: H3 -- person-centred eeriness vs trust subscales
# ---------------------------------------------------------------------------
h3_df = long_df.dropna(subset=["D_score", "E_score", "F_score", "G_score"]).copy()
h3_df["D_c"] = h3_df["D_score"] - h3_df.groupby("participant")["D_score"].transform("mean")

fig, axes = plt.subplots(1, 3, figsize=(11.5, 3.8), sharex=True, sharey=True)
for ax, (col, label, b) in zip(axes, [
    ("E_score", "Competence", -1.10), ("F_score", "Benevolence", -1.09), ("G_score", "Integrity", -1.02)
]):
    y_c = h3_df[col] - h3_df.groupby("participant")[col].transform("mean")
    ax.scatter(h3_df["D_c"], y_c, s=16, alpha=0.5, color="#2a78d6", edgecolor="none")
    xs = np.linspace(h3_df["D_c"].min(), h3_df["D_c"].max(), 50)
    ax.plot(xs, b * xs, color="#eb6834", lw=2)
    ax.axhline(0, color="#c3c2b7", lw=0.7)
    ax.axvline(0, color="#c3c2b7", lw=0.7)
    ax.set_title(f"{label}\n(b={b:.2f}, p<.0001)", fontsize=10.5)
    ax.set_xlabel("Eeriness, person-centred")
axes[0].set_ylabel("Trust subscale, person-centred")
fig.suptitle("H3: within-participant eeriness predicts trust (multilevel regression fit lines)", fontsize=11, y=1.03)
fig.tight_layout()
save(fig, "fig_h3_eeriness_trust")

# ---------------------------------------------------------------------------
# Figure 4: Post-study rankings (P1, trustworthy, unsettling)
# ---------------------------------------------------------------------------
def ranking_pairwise(sub, qname):
    pairs = [("C1_Real", "C2_Realistic"), ("C1_Real", "C3_NPR"), ("C2_Realistic", "C3_NPR")]
    out = {}
    for a, b in pairs:
        stat, p = wilcoxon(sub[f"{qname}_{a}"], sub[f"{qname}_{b}"])
        out[(a, b)] = min(p * 3, 1.0)
    return out


fig, axes = plt.subplots(1, 3, figsize=(11.5, 4.2))
for ax, (qname, valid_col, title) in zip(axes, [
    ("P1_rank", "P1_rank_valid", "Most want to consult"),
    ("trust_rank", "trust_rank_valid", "Most trustworthy overall"),
    ("unsettle_rank", "unsettle_rank_valid", "Least unsettling overall"),
]):
    cols = [f"{qname}_{c}" for c in ORDER]
    sub = wide[wide[valid_col] == True][["participant"] + cols].dropna()
    long_r = sub.melt(id_vars="participant", value_vars=cols, var_name="condition", value_name="rank")
    long_r["condition"] = long_r["condition"].str.replace(f"{qname}_", "", regex=False)
    means, sems, n, _ = cousineau_morey(long_r, "participant", "condition", "rank")
    pw = ranking_pairwise(sub, qname)
    bar_panel(ax, means, sems, n, (0.8, 3.5), "Mean rank (1 = best, taller = less preferred)", title, pairwise=pw, bracket_top=3.15)
fig.suptitle("Post-study forced-choice rankings (lower = more preferred / less unsettling)", fontsize=11, y=1.03)
fig.tight_layout()
save(fig, "fig_rankings")

# ---------------------------------------------------------------------------
# Figure 5: TOST equivalence (H2: C2 vs C3, H4: C1 vs C3)
# ---------------------------------------------------------------------------
trust_wide = long_df.dropna(subset=["Trust_score"]).pivot(index="participant", columns="condition", values="Trust_score")


def tost_summary(df, a, b, d_bound=0.3):
    sub = df[[a, b]].dropna()
    diff = sub[a] - sub[b]
    pooled_sd = np.sqrt((sub[a].var(ddof=1) + sub[b].var(ddof=1)) / 2)
    bound = d_bound * pooled_sd
    mean_diff = diff.mean()
    se = diff.std(ddof=1) / np.sqrt(len(sub))
    ci90 = (mean_diff - 1.645 * se, mean_diff + 1.645 * se)
    return mean_diff, ci90, bound, len(sub)


fig, ax = plt.subplots(figsize=(7.5, 3.2))
rows = [
    ("H2: C2 (Realistic) vs C3 (NPR)", *tost_summary(trust_wide, "C2_Realistic", "C3_NPR")),
    ("H4: C1 (Real) vs C3 (NPR)", *tost_summary(trust_wide, "C1_Real", "C3_NPR")),
]
for i, (label, mean_diff, ci90, bound, n) in enumerate(rows):
    y = len(rows) - i
    ax.plot([-bound, bound], [y, y], color="#e1e0d9", lw=10, solid_capstyle="butt", zorder=1)
    ax.plot(ci90, [y, y], color="#0b0b0b", lw=2, zorder=2)
    ax.plot(mean_diff, y, "o", color="#eb6834", markersize=9, zorder=3)
    ax.text(max(ci90[1], bound) + 0.1, y, f"n={n}", va="center", fontsize=9, color="#898781")
ax.axvline(0, color="#c3c2b7", lw=1, linestyle="--")
ax.set_yticks([len(rows), len(rows) - 1])
ax.set_yticklabels([r[0] for r in rows], fontsize=10.5)
ax.set_xlabel("Mean trust-composite difference (90% CI), shaded = equivalence bound (d=0.3)")
ax.set_ylim(0.4, len(rows) + 0.6)
ax.grid(axis="x", color="#e1e0d9", linewidth=0.6)
ax.grid(axis="y", visible=False)
fig.suptitle("TOST equivalence tests", fontsize=11)
fig.tight_layout()
save(fig, "fig_tost_equivalence")

print("\nAll figures saved to", FIG_DIR)
