"""
H3 main figure: both predictors against each trust subscale.

Top row    -- person-centred eeriness against each trust subscale.
Bottom row -- person-centred likeability against the same three subscales.

Replaces the earlier eeriness-only version of fig_h3_eeriness_trust so the two
predictors named in H3 can be read side by side on the same axes.

Slopes use the within (fixed-effects) estimator on person-centred variables.
For a random-intercept model with person-centred predictors this is the same
fixed-effect slope, and it reproduces the values in main_study_analysis.py to
three decimals (-1.166 / -1.103 / -1.017 against the reported -1.17 / -1.10 /
-1.02). Written this way so the figure needs no statsmodels dependency.

Palette and rcParams follow main_study_figures.py.
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path
from scipy import stats

DATA_DIR = Path("/Users/nidanurgunay/ThesisMetaAvatar/thesis/user_study _results")
FIG_DIR = Path("/Users/nidanurgunay/ThesisMetaAvatar/thesis/figures/user_study")
FIG_DIR.mkdir(parents=True, exist_ok=True)

BLUE, ORANGE = "#2a78d6", "#eb6834"
GREEN = "#1baf7a"

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


def fe(dv, x):
    """Within estimator: slope and p for a single person-centred predictor."""
    y = within(d[dv]).values
    X = d[x].values
    b = float((X * y).sum() / (X * X).sum())
    resid = y - b * X
    dof = len(y) - npart - 1
    se = np.sqrt((resid @ resid / dof) / (X * X).sum())
    p = 2 * (1 - stats.t.cdf(abs(b / se), dof))
    return b, p


SUBS = [("E_score", "Ability"), ("F_score", "Benevolence"), ("G_score", "Integrity")]
ROWS = [("Dc", "Eeriness", BLUE), ("Bc", "Likeability", GREEN)]

fig, axes = plt.subplots(2, 3, figsize=(11.5, 7.2), sharex="row", sharey=True)

for r, (xcol, xlabel, colour) in enumerate(ROWS):
    for c, (col, label) in enumerate(SUBS):
        ax = axes[r, c]
        y_c = within(d[col])
        b, p = fe(col, xcol)
        ax.scatter(d[xcol], y_c, s=16, alpha=0.5, color=colour, edgecolor="none")
        xs = np.linspace(d[xcol].min(), d[xcol].max(), 50)
        ax.plot(xs, b * xs, color=ORANGE, lw=2)
        ax.axhline(0, color="#c3c2b7", lw=0.7)
        ax.axvline(0, color="#c3c2b7", lw=0.7)
        ptxt = "p<.0001" if p < .0001 else f"p={p:.4f}"
        ax.set_title(f"{label}\n(b={b:+.2f}, {ptxt})", fontsize=10.5)
        ax.set_xlabel(f"{xlabel}, person-centred")
    axes[r, 0].set_ylabel("Trust subscale, person-centred")

fig.suptitle("H3: within-participant eeriness and likeability against trust "
             "(multilevel regression fit lines)", fontsize=11, y=1.0)
fig.tight_layout()
fig.savefig(FIG_DIR / "fig_h3_eeriness_trust.pdf")
fig.savefig(FIG_DIR / "fig_h3_eeriness_trust.png")
plt.close(fig)

for xcol, xlabel, _ in ROWS:
    for col, label in SUBS:
        b, p = fe(col, xcol)
        print(f"{xlabel:<12} -> {label:<12} b={b:+.3f}  p={p:.4g}")
print("Saved fig_h3_eeriness_trust.pdf / .png (2 rows x 3 columns)")
