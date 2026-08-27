"""
H3 supplementary figure: eeriness against likeability, and what happens to the
eeriness slopes once likeability is entered alongside them.

Left panel  -- person-centred eeriness vs person-centred likeability, with the
               within-participant fit. Shows that the two indices, both proposed
               as measures of the vertical axis of the uncanny valley, behave as
               one measure in this sample.
Right panel -- eeriness slope on each trust subscale, alone and adjusted for
               likeability, with 95% CIs. Shows the effect being absorbed.

Slopes use the within (fixed-effects) estimator on person-centred variables.
For a random-intercept model with person-centred predictors this is the same
fixed-effect slope: it reproduces the values in main_study_analysis.py to three
decimals (-1.166 / -1.103 / -1.017 against the reported -1.17 / -1.10 / -1.02).
Written this way so the figure has no statsmodels dependency.

Palette and rcParams copied from main_study_figures.py so the figure sits with
the others.
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path
from scipy import stats

DATA_DIR = Path("/Users/nidanurgunay/ThesisMetaAvatar/thesis/user_study _results")
FIG_DIR = Path("/Users/nidanurgunay/ThesisMetaAvatar/thesis/figures/user_study")
FIG_DIR.mkdir(parents=True, exist_ok=True)

BLUE, ORANGE, GREY = "#2a78d6", "#eb6834", "#898781"

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

# ---------------------------------------------------------------------------
# Data, person-centred within participant
# ---------------------------------------------------------------------------
df = pd.read_csv(DATA_DIR / "long_format_scores_clean.csv")
for c in ["B_score", "D_score", "E_score", "F_score", "G_score"]:
    df[c] = pd.to_numeric(df[c], errors="coerce")
d = df.dropna(subset=["B_score", "D_score", "E_score", "F_score", "G_score"]).copy()
g = d["participant"]
npart = g.nunique()


def within(s):
    return s - s.groupby(g).transform("mean")


d["Dc"] = within(d["D_score"])   # eeriness, person-centred
d["Bc"] = within(d["B_score"])   # likeability, person-centred


def fe(dv, xs):
    """Within estimator: slope, 95% CI, p for each predictor in xs."""
    y = within(d[dv]).values
    X = np.column_stack([d[c].values for c in xs])
    b, *_ = np.linalg.lstsq(X, y, rcond=None)
    resid = y - X @ b
    dof = len(y) - npart - len(xs)
    s2 = resid @ resid / dof
    se = np.sqrt(np.diag(np.linalg.inv(X.T @ X)) * s2)
    tc = stats.t.ppf(0.975, dof)
    return [(b[i], b[i] - tc * se[i], b[i] + tc * se[i],
             2 * (1 - stats.t.cdf(abs(b[i] / se[i]), dof))) for i in range(len(xs))]


SUBS = [("E_score", "Ability"), ("F_score", "Benevolence"), ("G_score", "Integrity")]

fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10.6, 4.0),
                               gridspec_kw={"width_ratios": [1.0, 1.15]})

# ---------------------------------------------------------------------------
# Left: eeriness vs likeability
# ---------------------------------------------------------------------------
r, _ = stats.pearsonr(d["Dc"], d["Bc"])
dof_r = len(d) - npart - 1
t_r = r * np.sqrt(dof_r / (1 - r ** 2))
p_r = 2 * (1 - stats.t.cdf(abs(t_r), dof_r))

ax1.scatter(d["Dc"], d["Bc"], s=18, alpha=0.55, color=BLUE, edgecolor="none")
slope = (d["Dc"] * d["Bc"]).sum() / (d["Dc"] ** 2).sum()
xs = np.linspace(d["Dc"].min(), d["Dc"].max(), 50)
ax1.plot(xs, slope * xs, color=ORANGE, lw=2)
ax1.axhline(0, color="#c3c2b7", lw=0.7)
ax1.axvline(0, color="#c3c2b7", lw=0.7)
ax1.set_xlabel("Eeriness, person-centred")
ax1.set_ylabel("Likeability, person-centred")
ptxt = "$p<.001$" if p_r < .001 else f"$p={p_r:.3f}$"
ax1.set_title(f"Two readings of the same axis\n($r={r:.2f}$, {ptxt})", fontsize=10.5)

# ---------------------------------------------------------------------------
# Right: eeriness slope alone vs adjusted for likeability
# ---------------------------------------------------------------------------
ypos = np.arange(len(SUBS))[::-1]
off = 0.16
plabels = []
for i, (col, label) in enumerate(SUBS):
    y = ypos[i]
    b_a, lo_a, hi_a, p_a = fe(col, ["Dc"])[0]
    (b_j, lo_j, hi_j, p_j), _ = fe(col, ["Dc", "Bc"])
    ax2.plot([lo_a, hi_a], [y + off] * 2, color=BLUE, lw=1.6, solid_capstyle="butt")
    ax2.scatter([b_a], [y + off], s=46, color=BLUE, zorder=3,
                label="eeriness alone" if i == 0 else None)
    ax2.plot([lo_j, hi_j], [y - off] * 2, color=ORANGE, lw=1.6, solid_capstyle="butt")
    ax2.scatter([b_j], [y - off], s=46, facecolor="white", edgecolor=ORANGE,
                linewidth=1.6, zorder=3,
                label="adjusted for likeability" if i == 0 else None)
    plabels.append((y - off, "ns" if p_j >= .05 else "$p=%s$" % f"{p_j:.3f}".lstrip("0")))

ax2.axvline(0, color="#0b0b0b", lw=0.9)
ax2.set_yticks(ypos)
ax2.set_yticklabels([lbl for _, lbl in SUBS])
ax2.set_xlabel("Within-participant slope on trust (95% CI)")
ax2.set_title("Eeriness effect once likeability is\nentered alongside it", fontsize=10.5)
ax2.set_ylim(-1.05, len(SUBS) - 0.4)
x0, x1 = ax2.get_xlim()
ax2.set_xlim(x0, x1 + 0.42)
for ytxt, lab in plabels:
    ax2.text(ax2.get_xlim()[1] - 0.04, ytxt, lab, va="center", ha="right",
             fontsize=8.5, color="#52514e")
ax2.legend(loc="lower left", frameon=False, fontsize=9, ncol=2,
           bbox_to_anchor=(0.0, -0.02))

fig.tight_layout()
fig.savefig(FIG_DIR / "fig_h3_likeability.pdf")
fig.savefig(FIG_DIR / "fig_h3_likeability.png")
plt.close(fig)
print(f"r = {r:+.3f} (df={dof_r}, p={p_r:.2g}), shared variance {100*r*r:.0f}%")
for col, label in SUBS:
    b_a, lo_a, hi_a, p_a = fe(col, ["Dc"])[0]
    (b_j, lo_j, hi_j, p_j), (b_l, lo_l, hi_l, p_l) = fe(col, ["Dc", "Bc"])
    print(f"{label:<12} alone b={b_a:+.3f} [{lo_a:+.3f},{hi_a:+.3f}] p={p_a:.4g}  |  "
          f"adjusted b={b_j:+.3f} p={p_j:.4g}  |  likeability b={b_l:+.3f} p={p_l:.4g}")
print("Saved fig_h3_likeability.pdf / .png")
