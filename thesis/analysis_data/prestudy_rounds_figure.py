"""
Full per-round rank distributions for the parameter adjustment (pre-study).

Regenerates figures/prestudy_round_results_full.{pdf,png}.

Borda convention: 1-based, i.e. an option placed at rank r out of N scores
(N - r + 1), so the best-ranked option scores N and the worst scores 1. This is
the same convention used by prestudy_analysis.py, prestudy_figure.py, and the
Methodology chapter. The previous version of this figure plotted 0-based totals
(N - r) while its own footnote quoted the 1-based formula.
"""
import csv, os
import numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl

mpl.rcParams.update({
    "font.family": "sans-serif",
    "font.size": 9.5,
    "axes.edgecolor": "#c3c2b7",
    "axes.linewidth": 0.8,
    "axes.axisbelow": True,
})

BASE = os.path.dirname(os.path.abspath(__file__))
CSV_PATH = os.path.join(BASE, "prestudy_responses.csv")
FIG_DIR = os.path.join(os.path.dirname(BASE), "figures")

ROUNDS = {
    "R1": {"cols": [1, 2, 3, 4, 5], "n": 5, "labels": list("ABCDE"),
           "title": "R1 — Inner line threshold"},
    "R2": {"cols": [7, 8, 9, 10, 11, 12], "n": 6, "labels": list("ABCDEF"),
           "title": "R2 — Outline width × depth"},
    "R3": {"cols": [14, 15, 16, 17, 18], "n": 5, "labels": list("ABCDE"),
           "title": "R3 — Shadow strength × detail"},
    "R4": {"cols": [20, 21, 22, 23], "n": 4, "labels": list("ABCD"),
           "title": "R4 — Kuwahara hardness × sharp"},
    "R5": {"cols": [25, 26, 27, 28, 29, 30], "n": 6, "labels": list("ABCDEF"),
           "title": "R5 — Hierarchical depth thresh"},
}


def is_valid(values, labels):
    normed = [v.strip().upper() for v in values]
    return "" not in normed and all(v in labels for v in normed) \
        and len(set(normed)) == len(normed)


with open(CSV_PATH, newline="", encoding="utf-8-sig") as f:
    rows = list(csv.reader(f))[1:]

results = {}
for rname, cfg in ROUNDS.items():
    labels, n = cfg["labels"], cfg["n"]
    ballots = []
    for row in rows:
        if len(row) <= max(cfg["cols"]):
            continue
        vals = [row[c] for c in cfg["cols"]]
        if is_valid(vals, labels):
            ballots.append({v.strip().upper(): pos for pos, v in enumerate(vals, 1)})
    n_valid = len(ballots)
    # 1-based Borda: rank 1 -> n points, rank n -> 1 point
    borda = {L: sum(n - b[L] + 1 for b in ballots) for L in labels}
    mr = {L: sum(b[L] for b in ballots) / n_valid for L in labels}
    dist = {L: [100.0 * sum(1 for b in ballots if b[L] == r) / n_valid
                for r in range(1, n + 1)] for L in labels}
    results[rname] = dict(borda=borda, mr=mr, dist=dist, n_valid=n_valid)

heights = [len(cfg["labels"]) for cfg in ROUNDS.values()]
fig, axes = plt.subplots(len(ROUNDS), 1, figsize=(7.6, 9.4),
                         gridspec_kw={"height_ratios": heights})

MAXN = max(cfg["n"] for cfg in ROUNDS.values())
cmap = plt.get_cmap("YlGnBu")
RANK_COLORS = [cmap(0.80 - 0.66 * i / (MAXN - 1)) for i in range(MAXN)]


def label_color(rgba):
    """White text on dark fills, dark slate on light fills (BT.601 luma)."""
    r, g, b = rgba[:3]
    return "#ffffff" if (0.299 * r + 0.587 * g + 0.114 * b) < 0.55 else "#22303a"


RANK_TEXT_COLORS = [label_color(c) for c in RANK_COLORS]

for ax, (rname, cfg) in zip(axes, ROUNDS.items()):
    res = results[rname]
    n = cfg["n"]
    # highest Borda at the top
    order = sorted(cfg["labels"], key=lambda L: res["borda"][L], reverse=True)
    ypos = np.arange(len(order))[::-1]

    left = np.zeros(len(order))
    for r in range(n):
        widths = np.array([res["dist"][L][r] for L in order])
        ax.barh(ypos, widths, left=left, height=0.62,
                color=RANK_COLORS[r], edgecolor="white", linewidth=0.6, zorder=3)
        for y, w, l in zip(ypos, widths, left):
            if w >= 9:
                ax.text(l + w / 2, y, f"{w:.0f}%", ha="center", va="center",
                        fontsize=7.2, color=RANK_TEXT_COLORS[r])
        left += widths

    for y, L in zip(ypos, order):
        ax.text(103, y, f"Borda: {res['borda'][L]}   MR: {res['mr'][L]:.2f}",
                va="center", fontsize=7.8, color="#52514e")

    ax.set_yticks(ypos)
    ax.set_yticklabels(order, fontsize=9)
    ax.set_xlim(0, 100)
    ax.set_ylim(-0.7, len(order) - 0.3)
    ax.set_xticks([0, 20, 40, 60, 80, 100])
    ax.tick_params(axis="x", labelsize=8)
    ax.set_title(f"{cfg['title']}  (n = {res['n_valid']} valid)",
                 fontsize=9.5, pad=5)
    for s in ("top", "right", "left"):
        ax.spines[s].set_visible(False)

handles = [plt.Rectangle((0, 0), 1, 1, color=RANK_COLORS[i]) for i in range(MAXN)]
names = ["Rank 1 (most trustworthy)"] + [f"Rank {i}" for i in range(2, MAXN)] \
    + [f"Rank {MAXN} (least trustworthy)"]
fig.legend(handles, names, loc="lower center", ncol=3, frameon=False,
           fontsize=8.5, bbox_to_anchor=(0.5, 0.002))

fig.suptitle("% of participants at each rank position", fontsize=11.5, y=0.998)
fig.tight_layout(rect=[0, 0.048, 0.995, 0.985])
fig.savefig(os.path.join(FIG_DIR, "prestudy_round_results_full.pdf"), bbox_inches="tight")
fig.savefig(os.path.join(FIG_DIR, "prestudy_round_results_full.png"), dpi=200, bbox_inches="tight")
print("Saved prestudy_round_results_full.pdf / .png")
for rname, res in results.items():
    top = sorted(res["borda"].items(), key=lambda x: x[1], reverse=True)
    print(rname, f"n={res['n_valid']}", "top:", top[:2])
