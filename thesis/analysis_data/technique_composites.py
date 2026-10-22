#!/usr/bin/env python3
"""One labelled, ready-to-paste image per NPR technique, all three platforms in it.

The per-platform files are fine for LaTeX, where the deck arranges and labels them,
but they are awkward in Google Slides: three separate images have to be placed,
sized and captioned by hand on every slide. This builds a single composite per
technique with the platform captions already burned in, so each backup slide takes
one paste.

Portrait renders (V1, V2) go side by side. Wide multi-panel strips stack as rows.

Run from this folder:  python3 technique_composites.py
"""
import os

from PIL import Image, ImageDraw, ImageFont

SRC = "/Users/nidanurgunay/ThesisMetaAvatar/defense slide images/technique figures"
OUT = os.path.join(SRC, "composites")

LABELS = ["Mixamo (Jody)", "Meta SDK", "Avaturn"]
SUFFIX = ["mixamo_jody", "meta_sdk", "avaturn"]

TECHNIQUES = [
    ("V1_silhouette",       "V1 — Silhouette outline"),
    ("V2_toon",             "V2 — Toon shading"),
    ("V2-2_xtoon",          "V2.2 — X-Toon"),
    ("V3_normal_edges",     "V3 — Screen-space normal edges"),
    ("V4_sobel",            "V4 — Sobel"),
    ("V4-2_gaussian_sobel", "V4.2 — Gaussian prefiltered Sobel"),
    ("V5_hierarchical",     "V5 — Hierarchical multi-cue"),
    ("V6_kuwahara",         "V6 — Kuwahara"),
]

CAP_H, PAD, MARGIN = 62, 26, 18
GREY, WHITE = (90, 90, 90), (255, 255, 255)


def font(size):
    for path in ("/System/Library/Fonts/Supplemental/Arial.ttf",
                 "/System/Library/Fonts/Helvetica.ttc"):
        if os.path.exists(path):
            try:
                return ImageFont.truetype(path, size)
            except OSError:
                pass
    return ImageFont.load_default()


def caption(draw, text, cx, top, f):
    w = draw.textbbox((0, 0), text, font=f)[2]
    draw.text((cx - w / 2, top), text, fill=GREY, font=f)


def build(stem, target_w=2400):
    ims = [Image.open(f"{SRC}/technique_{stem}_{s}.png").convert("RGB") for s in SUFFIX]
    f = font(38)
    side_by_side = all(im.width / im.height < 1.0 for im in ims)

    if side_by_side:
        h = max(im.height for im in ims)
        ims = [im.resize((int(im.width * h / im.height), h), Image.LANCZOS) for im in ims]
        scale = (target_w - 2 * MARGIN - 2 * PAD) / sum(im.width for im in ims)
        ims = [im.resize((int(im.width * scale), int(im.height * scale)), Image.LANCZOS) for im in ims]
        W = sum(im.width for im in ims) + 2 * PAD + 2 * MARGIN
        H = max(im.height for im in ims) + CAP_H + 2 * MARGIN
        canvas = Image.new("RGB", (W, H), WHITE)
        d = ImageDraw.Draw(canvas)
        x = MARGIN
        for im, lab in zip(ims, LABELS):
            canvas.paste(im, (x, MARGIN))
            caption(d, lab, x + im.width / 2, MARGIN + im.height + 12, f)
            x += im.width + PAD
    else:
        w = target_w - 2 * MARGIN
        ims = [im.resize((w, int(im.height * w / im.width)), Image.LANCZOS) for im in ims]
        H = sum(im.height for im in ims) + 3 * CAP_H + 2 * PAD + 2 * MARGIN
        canvas = Image.new("RGB", (target_w, H), WHITE)
        d = ImageDraw.Draw(canvas)
        y = MARGIN
        for im, lab in zip(ims, LABELS):
            canvas.paste(im, (MARGIN, y))
            caption(d, lab, target_w / 2, y + im.height + 12, f)
            y += im.height + CAP_H + PAD

    dst = f"{OUT}/composite_{stem}.png"
    canvas.save(dst)
    return dst, canvas.size, "side by side" if side_by_side else "stacked"


def main():
    os.makedirs(OUT, exist_ok=True)
    for stem, title in TECHNIQUES:
        dst, size, how = build(stem)
        print(f"{title:<36} {size[0]:>5} x {size[1]:<5} {how:<13} {os.path.basename(dst)}")


if __name__ == "__main__":
    main()
