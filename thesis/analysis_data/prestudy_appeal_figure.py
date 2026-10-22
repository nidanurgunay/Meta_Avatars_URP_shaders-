#!/usr/bin/env python3
"""Closing appeal question of the pre-study, drawn as a wide vertical-bar chart.

Same data and same parser as prestudy_analysis.py. R4 A is the baseline without
the Kuwahara pass, which is the identical configuration to R1 E, and the two are
merged exactly as in the portrait version of this figure.
"""

import csv, os
from collections import Counter

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

from prestudy_analysis import FINAL_COL, parse_final_answer, ROUNDS

HERE = os.path.dirname(os.path.abspath(__file__))
CSV  = os.path.join(HERE, "prestudy_responses.csv")
OUT  = os.path.abspath(os.path.join(HERE, "..", "figures"))

MERGE = {"R4A": "R1E"}          # identical configuration
HIGHLIGHT = "#D9720B"           # the round-one pick
SECOND    = "#2E75B6"           # the round-three pick
BASE      = "#9FC7E8"


def collect():
    with open(CSV, newline="", encoding="utf-8-sig") as f:
        rows = list(csv.reader(f))[1:]

    raw = [r[FINAL_COL].strip() for r in rows if len(r) > FINAL_COL and r[FINAL_COL].strip()]
    parsed = [parse_final_answer(a) for a in raw]
    valid = [MERGE.get(p, p) for p in parsed if p is not None]
    # blanks = every participant who left the closing question empty or unreadable
    return Counter(valid), len(valid), len(rows) - len(valid)


def label(code):
    return f"{code[:2]} {code[2]}"


def desc(code):
    cfg = ROUNDS.get(code[:2])
    return cfg["desc"].get(code[2], "") if cfg else ""


def main():
    counts, n_valid, n_blank = collect()
    order = sorted(counts.items(), key=lambda kv: (-kv[1], kv[0]))
    codes = [c for c, _ in order]
    votes = [v for _, v in order]

    colours = []
    for c in codes:
        colours.append(HIGHLIGHT if c == "R1E" else SECOND if c == "R3B" else BASE)

    fig, ax = plt.subplots(figsize=(12.2, 2.45))
    bars = ax.bar(range(len(codes)), votes, color=colours, width=0.68, zorder=3)

    for rect, v in zip(bars, votes):
        ax.text(rect.get_x() + rect.get_width() / 2, v + 0.12, str(v),
                ha="center", va="bottom", fontsize=8, color="#333333")

    ax.set_xticks(range(len(codes)))
    ax.set_xticklabels([label(c) for c in codes], fontsize=8.5)
    ax.set_ylabel("Votes", fontsize=8.5)
    ax.set_ylim(0, max(votes) + 0.9)
    ax.set_yticks(range(0, max(votes) + 2))
    ax.tick_params(axis="y", labelsize=7.5)
    ax.grid(axis="y", color="#DDDDDD", linewidth=0.7, zorder=0)
    ax.set_axisbelow(True)
    for side in ("top", "right", "left"):
        ax.spines[side].set_visible(False)
    ax.spines["bottom"].set_color("#999999")

    ax.set_title(f"Overall most visually appealing avatar    "
                 f"(n = {n_valid} valid, {n_blank} blank)",
                 fontsize=10, fontweight="bold", loc="left", pad=6)

    note = (f"Winner {label('R1E')} = {desc('R1E')}.    "
            f"Runner-up {label('R3B')} = {desc('R3B')}.    "
            "R4 A merged into R1 E (identical configuration).")
    # the winner descriptions are carried on the slide itself, not in the figure
    _ = note

    fig.tight_layout()
    for ext in ("png", "pdf"):
        path = os.path.join(OUT, f"prestudy_overall_appeal_wide.{ext}")
        fig.savefig(path, dpi=220, bbox_inches="tight", facecolor="white")
        print("wrote", path)

    print("\n".join(f"  {c:5s} {v}" for c, v in order))


if __name__ == "__main__":
    main()
