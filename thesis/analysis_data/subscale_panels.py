#!/usr/bin/env python3
"""One standalone image per subscale, cut from the grid figure.

The grid (fig_subscales_grid) is right for the overview slide but each panel is
too small once a single hypothesis is on screen. This slices the grid into its
five panels at full resolution, so each H slide can carry only its own measure.

Cutting the existing figure rather than re-plotting keeps the panels byte-for-byte
identical to the ones in the thesis, and avoids needing the analysis stack
(pandas/pingouin) just to redraw them.

Run from this folder:  python3 subscale_panels.py
"""
from pathlib import Path

from PIL import Image

SRC = Path("/Users/nidanurgunay/ThesisMetaAvatar/thesis/figures/user_study/fig_subscales_grid.png")
OUT = Path("/Users/nidanurgunay/ThesisMetaAvatar/defense slide images/study figures")

# (x0, y0, x1, y1) as fractions of the grid, 3 columns x 2 rows, legend cell skipped
PANELS = {
    "subscale_1_likeability":  (0.005, 0.045, 0.330, 0.525),
    "subscale_2_eeriness":     (0.335, 0.045, 0.665, 0.525),
    "subscale_3_ability":      (0.670, 0.045, 0.998, 0.525),
    "subscale_4_benevolence":  (0.005, 0.525, 0.330, 0.998),
    "subscale_5_integrity":    (0.335, 0.525, 0.665, 0.998),
}


def main():
    src = Image.open(SRC)
    W, H = src.size
    for name, (x0, y0, x1, y1) in PANELS.items():
        box = (int(W * x0), int(H * y0), int(W * x1), int(H * y1))
        im = src.crop(box)
        dst = OUT / f"{name}.png"
        im.save(dst)
        print(f"{im.size[0]:5d} x {im.size[1]:5d}   {dst}")


if __name__ == "__main__":
    main()
