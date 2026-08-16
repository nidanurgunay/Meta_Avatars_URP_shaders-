"""
One-figure summary of the parameter adjustment (pre-study) results: five rounds,
each a Borda-count ranking task, producing either a clear winner (R4, R5) or no
statistically distinguishable top choice (R1-R3). Reuses the same Borda/Friedman/
Wilcoxon logic as prestudy_analysis.py so the numbers are guaranteed consistent.
"""
import csv, re, os
import numpy as np
from scipy import stats
import matplotlib.pyplot as plt
import matplotlib as mpl

mpl.rcParams.update({
    "font.family": "sans-serif",
    "font.size": 10.5,
    "axes.edgecolor": "#c3c2b7",
    "axes.linewidth": 0.8,
    "axes.grid": True,
    "grid.color": "#e1e0d9",
    "grid.linewidth": 0.6,
    "axes.axisbelow": True,
})

BASE = os.path.dirname(os.path.abspath(__file__))
CSV_PATH = os.path.join(BASE, "prestudy_responses.csv")
FIG_DIR = "/Users/nidanurgunay/ThesisMetaAvatar/thesis/figures"

ROUNDS = {
    "R1": {"cols": [1,2,3,4,5], "n": 5, "labels": list("ABCDE"),
           "title": "R1 — Line threshold", "short": {"A":"0.01","B":"0.02","C":"0.03","D":"0.04","E":"0.05"}},
    "R2": {"cols": [7,8,9,10,11,12], "n": 6, "labels": list("ABCDEF"),
           "title": "R2 — Outline width / depth offset",
           "short": {"A":"w.005\noff","B":"w.005\non","C":"w.007\noff","D":"w.007\non","E":"w.003\noff","F":"w.003\non"}},
    "R3": {"cols": [14,15,16,17,18], "n": 5, "labels": list("ABCDE"),
           "title": "R3 — Shadow strength / detail bias",
           "short": {"A":"sh1.0\nb.5","B":"sh0\nb.5","C":"sh.5\nb.5","D":"sh.5\nb1.0","E":"sh.5\nb0"}},
    "R4": {"cols": [20,21,22,23], "n": 4, "labels": list("ABCD"),
           "title": "R4 — Kuwahara painterly fill",
           "short": {"A":"baseline\n(no filter)","B":"h1\ns18","C":"h9\ns9","D":"h18\ns1"}},
    "R5": {"cols": [25,26,27,28,29,30], "n": 6, "labels": list("ABCDEF"),
           "title": "R5 — Hierarchical depth edge layer",
           "short": {"A":"baseline\n(no layer)","B":"t.01","C":"t.02","D":"t.03","E":"t.04","F":"t.05"}},
}

def is_valid(values, labels):
    normed = [v.strip().upper() for v in values]
    return "" not in normed and all(v in labels for v in normed) and len(set(normed)) == len(normed)

def ballot_to_rank_dict(values, labels):
    return {v.strip().upper(): pos for pos, v in enumerate(values, 1)}

with open(CSV_PATH, newline="", encoding="utf-8-sig") as f:
    rows = list(csv.reader(f))[1:]

results = {}
for rname, cfg in ROUNDS.items():
    labels, n = cfg["labels"], cfg["n"]
    valid_ballots = []
    for row in rows:
        if len(row) <= max(cfg["cols"]):
            continue
        vals = [row[c] for c in cfg["cols"]]
        if is_valid(vals, labels):
            valid_ballots.append(ballot_to_rank_dict(vals, labels))
    n_valid = len(valid_ballots)
    borda = {L: sum(n - d[L] + 1 for d in valid_ballots) for L in labels}
    ranked = sorted(borda.items(), key=lambda x: x[1], reverse=True)
    pct = {L: borda[L] / (n * n_valid) * 100 for L in labels}
    mat = np.array([[d[L] for L in labels] for d in valid_ballots])
    chi, fp = stats.friedmanchisquare(*mat.T)
    w_lbl, ru_lbl = ranked[0][0], ranked[1][0]
    wi, ri = labels.index(w_lbl), labels.index(ru_lbl)
    _, wp = stats.wilcoxon(mat[:, wi], mat[:, ri])
    results[rname] = dict(ranked=ranked, pct=pct, n_valid=n_valid, fp=fp, wp=wp, winner=w_lbl, runner_up=ru_lbl)

# ---------------------------------------------------------------------------
fig, axes = plt.subplots(2, 3, figsize=(13, 7.6))
axes = axes.flatten()

WINNER_COLOR = "#2a78d6"
DECISIVE_COLOR = "#1baf7a"   # winner AND significantly ahead of runner-up (R4, R5)
OTHER_COLOR = "#c3c2b7"

for ax, (rname, cfg) in zip(axes, ROUNDS.items()):
    res = results[rname]
    ranked = res["ranked"]
    order_labels = [l for l, _ in ranked]
    pcts = [res["pct"][l] for l in order_labels]
    decisive = res["wp"] < .05
    colors = []
    for l in order_labels:
        if l == res["winner"]:
            colors.append(DECISIVE_COLOR if decisive else WINNER_COLOR)
        else:
            colors.append(OTHER_COLOR)
    xticks = [cfg["short"][l] for l in order_labels]
    bars = ax.bar(range(len(order_labels)), pcts, color=colors, width=0.66, zorder=3)
    ax.set_xticks(range(len(order_labels)))
    ax.set_xticklabels(xticks, fontsize=8.5)
    ax.set_ylim(0, 100)
    ax.set_ylabel("Borda score (% of max)", fontsize=9)
    sig_tag = "significant top pick" if decisive else "no clear winner"
    p_str = "<.001" if res["fp"] < .001 else f"{res['fp']:.2f}"
    ax.set_title(f"{cfg['title']}\nFriedman p={p_str}, {sig_tag} (n={res['n_valid']})", fontsize=9.5)
    for i, p in enumerate(pcts):
        ax.text(i, p + 2, f"{p:.0f}", ha="center", fontsize=7.5, color="#52514e")

axes[-1].axis("off")
legend_elems = [
    plt.Rectangle((0,0),1,1, color=DECISIVE_COLOR, label="Retained: significantly preferred over runner-up"),
    plt.Rectangle((0,0),1,1, color=WINNER_COLOR, label="Borda winner, not significantly ahead of runner-up"),
    plt.Rectangle((0,0),1,1, color=OTHER_COLOR, label="Not the top choice"),
]
axes[-1].legend(handles=legend_elems, loc="center", fontsize=9.5, frameon=False)

fig.suptitle("Parameter adjustment study: Borda-count preference by round", fontsize=13, y=0.995)
fig.tight_layout(rect=[0, 0, 1, 0.97])
fig.savefig(f"{FIG_DIR}/prestudy_summary.pdf", bbox_inches="tight")
fig.savefig(f"{FIG_DIR}/prestudy_summary.png", dpi=200, bbox_inches="tight")
print("Saved prestudy_summary.pdf / .png")
for rname, res in results.items():
    print(rname, "winner", res["winner"], f"Friedman p={res['fp']:.4f}", f"Wilcoxon winner-vs-runnerup p={res['wp']:.4f}")
