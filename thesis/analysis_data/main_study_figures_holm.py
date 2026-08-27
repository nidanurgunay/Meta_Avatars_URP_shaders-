"""
Regenerates the three user-study figures whose significance brackets depend on the
multiple-comparison correction, using Holm's step-down procedure instead of Bonferroni.

Why a separate script: main_study_figures.py produced the original Bonferroni figures
via pingouin (padjust="bonf"). The analysis plan now specifies Holm, which controls the
familywise error rate at the same level while rejecting more hypotheses. Holm is
implemented directly here, so this script needs only pandas/numpy/scipy/matplotlib and
runs without pingouin or statsmodels.

Regenerated:
  fig_manipulation_check   -- Part I stylisation rating
  fig_subscales_grid       -- B, D, E, F, G subscale composites
  fig_rankings             -- P1 / trustworthiness / unsettlingness forced rankings

NOT regenerated (unaffected -- neither involves a pairwise correction):
  fig_h3_eeriness_trust    -- multilevel regression slopes
  fig_tost_equivalence     -- TOST confidence intervals

Palette, rcParams, panel layout, and the Cousineau-Morey within-subject error bars are
carried over unchanged from main_study_figures.py so the regenerated figures stay
visually identical to the rest of the set.
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path
from scipy.stats import ttest_rel, wilcoxon

DATA_DIR = Path("/Users/nidanurgunay/ThesisMetaAvatar/thesis/user_study _results")
FIG_DIR = Path("/Users/nidanurgunay/ThesisMetaAvatar/thesis/figures/user_study")
FIG_DIR.mkdir(parents=True, exist_ok=True)

ORDER = ["C1_Real", "C2_Realistic", "C3_NPR"]
COLORS = {"C1_Real": "#2a78d6", "C2_Realistic": "#eb6834", "C3_NPR": "#1baf7a"}
LABELS = {"C1_Real": "Real\n(C1)", "C2_Realistic": "Photorealistic\n(C2)", "C3_NPR": "NPR\n(C3)"}
PAIRS = [("C1_Real", "C2_Realistic"), ("C1_Real", "C3_NPR"), ("C2_Realistic", "C3_NPR")]

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


def holm(pvals):
    """Holm (1979) step-down correction. Sorts p ascending, compares p_i against
    alpha/(k-i), and enforces monotonicity so no adjusted p falls below an earlier one."""
    pvals = np.asarray(pvals, dtype=float)
    order = np.argsort(pvals)
    adjusted = np.empty(len(pvals))
    running = 0.0
    for rank, idx in enumerate(order):
        running = max(running, pvals[idx] * (len(pvals) - rank))
        adjusted[idx] = min(running, 1.0)
    return adjusted


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


def bar_panel(ax, means, sems, n, ylim, ylabel, title, pairwise=None, bracket_top=None, show_n=True):
    x = np.arange(3)
    bars = ax.bar(x, [means[c] for c in ORDER], yerr=[sems[c] for c in ORDER],
                  color=[COLORS[c] for c in ORDER], edgecolor="#0b0b0b", linewidth=0.8,
                  width=0.62, capsize=4,
                  error_kw=dict(elinewidth=1.1, ecolor="#0b0b0b", capthick=1.1))
    ax.set_xticks(x)
    ax.set_xticklabels([LABELS[c] for c in ORDER], fontsize=9.5)
    ax.set_ylim(*ylim)
    ax.set_ylabel(ylabel)
    ax.set_title(f"{title}  (n={n})" if show_n else title, fontsize=11, pad=8)
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


def paired_holm(wide, label=""):
    """Paired t-tests across the three condition pairs, Holm-corrected."""
    raw = [ttest_rel(wide[a], wide[b]).pvalue for a, b in PAIRS]
    adj = holm(raw)
    if label:
        for (a, b), r, h in zip(PAIRS, raw, adj):
            print(f"  {label:22s} {a[:2]} vs {b[:2]}: raw={r:.4f}  Holm={h:.4f}")
    return dict(zip(PAIRS, adj))


def wilcoxon_holm(sub, qname, label=""):
    """Pairwise Wilcoxon signed-rank across the three condition pairs, Holm-corrected."""
    raw = [wilcoxon(sub[f"{qname}_{a}"], sub[f"{qname}_{b}"]).pvalue for a, b in PAIRS]
    adj = holm(raw)
    if label:
        for (a, b), r, h in zip(PAIRS, raw, adj):
            print(f"  {label:22s} {a[:2]} vs {b[:2]}: raw={r:.4f}  Holm={h:.4f}")
    return dict(zip(PAIRS, adj))


# ---------------------------------------------------------------------------
# Load data
# ---------------------------------------------------------------------------
long_df = pd.read_csv(DATA_DIR / "long_format_scores_clean.csv")
wide = pd.read_csv(DATA_DIR / "wide_format_participant_clean.csv")

print("Holm-corrected pairwise p-values (these drive the significance brackets):\n")

# ---------------------------------------------------------------------------
# Figure 1: Manipulation check (Part I stylisation)
# ---------------------------------------------------------------------------
styl_long = wide.melt(id_vars="participant",
                      value_vars=[f"stylisation_{c}" for c in ORDER],
                      var_name="condition", value_name="stylisation")
styl_long["condition"] = styl_long["condition"].str.replace("stylisation_", "", regex=False)
styl_long["stylisation"] = pd.to_numeric(styl_long["stylisation"], errors="coerce")
styl_long = styl_long.dropna(subset=["stylisation"])

means, sems, n, styl_wide = cousineau_morey(styl_long, "participant", "condition", "stylisation")
pw = paired_holm(styl_wide, "Manipulation check")

fig, ax = plt.subplots(figsize=(4.6, 4.2))
bar_panel(ax, means, sems, n, (1, 7.6), "Stylisation rating",
          "Manipulation check", pairwise=pw, bracket_top=6.7, show_n=False)
fig.tight_layout()
save(fig, "fig_manipulation_check")

# ---------------------------------------------------------------------------
# Figure 2: Subscale grid (B, D, E, F, G)
# ---------------------------------------------------------------------------
SUBSCALES = [
    ("B_score", "Likeability", (1, 5), 4.55),
    ("D_score", "Eeriness (H1)", (1, 5), 4.55),
    ("E_score", "Ability", (1, 7), 6.5),
    ("F_score", "Benevolence", (1, 7), 6.5),
    ("G_score", "Integrity", (1, 7), 6.5),
]

fig, axes = plt.subplots(2, 3, figsize=(11.5, 7.6))
axes = axes.flatten()
for i, (col, title, ylim, btop) in enumerate(SUBSCALES):
    means, sems, n, sub_wide = cousineau_morey(long_df, "participant", "condition", col)
    pw = paired_holm(sub_wide, title)
    bar_panel(axes[i], means, sems, n, ylim, "Mean rating", title, pairwise=pw, bracket_top=btop)
axes[-1].axis("off")
handles = [plt.Rectangle((0, 0), 1, 1, color=COLORS[c]) for c in ORDER]
axes[-1].legend(handles, [LABELS[c].replace("\n", " ") for c in ORDER],
                loc="center", frameon=False, fontsize=11, title="Condition")
fig.suptitle("Per-block subscale ratings by condition (Holm-corrected pairwise: * p<.05, ** p<.01, *** p<.001, ns = not significant)",
             fontsize=10.5, y=1.01)
fig.tight_layout()
save(fig, "fig_subscales_grid")

# ---------------------------------------------------------------------------
# Figure 3: Post-study rankings (P1, trustworthy, unsettling)
# ---------------------------------------------------------------------------
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
    pw = wilcoxon_holm(sub, qname, title)
    bar_panel(ax, means, sems, n, (0.8, 3.5), "Mean rank (1 = best, taller = less preferred)",
              title, pairwise=pw, bracket_top=3.15)
fig.suptitle("Post-study forced-choice rankings (lower = more preferred / less unsettling)", fontsize=11, y=1.03)
fig.tight_layout()
save(fig, "fig_rankings")

print("\nRegenerated 3 figures in", FIG_DIR)
print("fig_h3_eeriness_trust and fig_tost_equivalence are unchanged by the correction "
      "and were deliberately left as produced by main_study_figures.py.")
