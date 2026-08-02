#!/usr/bin/env python3
"""Pre-study Borda-count analysis: Friedman omnibus + Wilcoxon pairwise."""

import csv, re, os
import numpy as np
from scipy import stats
from collections import Counter

# ── Round configuration ────────────────────────────────────────────────────────
ROUNDS = {
    'R1': {
        'cols': [1,2,3,4,5], 'n': 5,
        'labels': ['A','B','C','D','E'],
        'desc': {
            'A': 'threshold 0.01',
            'B': 'threshold 0.02',
            'C': 'threshold 0.03',
            'D': 'threshold 0.04',
            'E': 'threshold 0.05',
        },
    },
    'R2': {
        'cols': [7,8,9,10,11,12], 'n': 6,
        'labels': ['A','B','C','D','E','F'],
        'desc': {
            'A': 'w=0.005 offset OFF',
            'B': 'w=0.005 offset ON',
            'C': 'w=0.007 offset OFF',
            'D': 'w=0.007 offset ON',
            'E': 'w=0.003 offset OFF',
            'F': 'w=0.003 offset ON',
        },
    },
    'R3': {
        'cols': [14,15,16,17,18], 'n': 5,
        'labels': ['A','B','C','D','E'],
        'desc': {
            'A': 'shadow=1.0  bias=0.5',
            'B': 'shadow=0.0  bias=0.5',
            'C': 'shadow=0.5  bias=0.5',
            'D': 'shadow=0.5  bias=1.0',
            'E': 'shadow=0.5  bias=0.0',
        },
    },
    'R4': {
        'cols': [20,21,22,23], 'n': 4,
        'labels': ['A','B','C','D'],
        'desc': {
            'A': 'no Kuwahara (baseline)',
            'B': 'hardness=1  sharpness=18',
            'C': 'hardness=9  sharpness=9',
            'D': 'hardness=18 sharpness=1',
        },
    },
    'R5': {
        'cols': [25,26,27,28,29,30], 'n': 6,
        'labels': ['A','B','C','D','E','F'],
        'desc': {
            'A': 'no hierarchical (baseline)',
            'B': 'depth threshold 0.01',
            'C': 'depth threshold 0.02',
            'D': 'depth threshold 0.03',
            'E': 'depth threshold 0.04',
            'F': 'depth threshold 0.05',
        },
    },
}
FINAL_COL = 32

# ── Helpers ────────────────────────────────────────────────────────────────────
def is_valid(values, labels):
    normed = [v.strip().upper() for v in values]
    return (
        '' not in normed and
        all(v in labels for v in normed) and
        len(set(normed)) == len(normed)
    )

def ballot_to_rank_dict(values, labels):
    """Return {label: rank_position} where rank 1 = best."""
    return {v.strip().upper(): pos for pos, v in enumerate(values, 1)}

def parse_final_answer(s):
    """Extract 'R<n><L>' from free-text answer."""
    m = re.search(r'[Rr](\d)\s*([A-Fa-f])', s)
    if m:
        return f"R{m.group(1)}{m.group(2).upper()}"
    return None

# ── Analysis ───────────────────────────────────────────────────────────────────
def analyze(csv_path):
    with open(csv_path, newline='', encoding='utf-8-sig') as f:
        rows = list(csv.reader(f))[1:]  # skip header

    final_raw = []

    for rname, cfg in ROUNDS.items():
        labels  = cfg['labels']
        n       = cfg['n']
        valid_ballots = []
        n_invalid     = 0

        for row in rows:
            if len(row) <= max(cfg['cols']):
                n_invalid += 1; continue
            vals = [row[c] for c in cfg['cols']]
            if is_valid(vals, labels):
                valid_ballots.append(ballot_to_rank_dict(vals, labels))
            else:
                n_invalid += 1

        n_valid = len(valid_ballots)

        # Borda: rank 1 → n pts, rank n → 1 pt
        borda = {L: sum(n - d[L] + 1 for d in valid_ballots) for L in labels}
        ranked = sorted(borda.items(), key=lambda x: x[1], reverse=True)

        # Rank matrix: rows = participants, cols = label order
        mat = np.array([[d[L] for L in labels] for d in valid_ballots])

        # Friedman omnibus
        chi, fp = stats.friedmanchisquare(*mat.T)

        # Wilcoxon: winner vs runner-up
        w_lbl  = ranked[0][0]
        ru_lbl = ranked[1][0]
        wi = labels.index(w_lbl)
        ri = labels.index(ru_lbl)
        try:
            _, wp = stats.wilcoxon(mat[:, wi], mat[:, ri])
        except Exception:
            wp = float('nan')

        # ── Report ────────────────────────────────────────────────────────────
        print(f"\n{'='*62}")
        print(f"  {rname}  —  n_valid = {n_valid}  /  n_invalid = {n_invalid}")
        print(f"{'='*62}")
        print(f"  Borda totals  (max possible = {n * n_valid}):")
        for lbl, pts in ranked:
            pct = pts / (n * n_valid) * 100
            tag = ''
            if lbl == w_lbl:  tag = '  ← WINNER'
            elif lbl == ru_lbl: tag = '  ← runner-up'
            print(f"    {lbl}  {pts:4d} pts  ({pct:4.1f}%)   {cfg['desc'][lbl]}{tag}")

        df  = n - 1
        sig = 'SIGNIFICANT' if fp < .05 else 'not significant'
        print(f"\n  Friedman  χ²_F({df}) = {chi:.2f},  p = {fp:.4f}  →  {sig}")

        wsig = 'SIGNIFICANT' if (not np.isnan(wp) and wp < .05) else 'not significant'
        print(f"  Wilcoxon  (winner {w_lbl} vs runner-up {ru_lbl})  p = {wp:.4f}  →  {wsig}")

    # ── Final question ─────────────────────────────────────────────────────────
    for row in rows:
        if len(row) > FINAL_COL:
            raw = row[FINAL_COL].strip()
            if raw:
                final_raw.append(raw)

    parsed  = [parse_final_answer(a) for a in final_raw]
    valid_p = [p for p in parsed if p is not None]
    counts  = Counter(valid_p)

    print(f"\n{'='*62}")
    print(f"  FINAL QUESTION — Most visually appealing")
    print(f"  {len(valid_p)} answers parsed  /  {len(final_raw) - len(valid_p)} unparseable")
    print(f"{'='*62}")
    for lbl, cnt in sorted(counts.items(), key=lambda x: -x[1]):
        bar = '█' * cnt
        print(f"    {lbl:5s}  {cnt:2d}x  {bar}")
    print()

if __name__ == '__main__':
    csv_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'prestudy_responses.csv')
    analyze(csv_path)
