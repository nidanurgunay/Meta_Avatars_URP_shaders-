#!/usr/bin/env python3
"""The three trust subscales as one ready-to-paste image, for the H2 and H4 slides.

The individual panels are right for LaTeX, where the deck places them in columns,
but in Google Slides three separate images have to be placed and aligned by hand on
two different slides. This joins them into one picture with equal heights and a
single caption line, so each slide takes one paste.

Run from this folder:  python3 trust_subscale_composite.py
"""
import os

from PIL import Image, ImageDraw, ImageFont

DIR = "/Users/nidanurgunay/ThesisMetaAvatar/defense slide images/study figures"
PANELS = ["subscale_3_ability", "subscale_4_benevolence", "subscale_5_integrity"]

PAD, MARGIN, CAP_H = 24, 18, 54
GREY, WHITE = (90, 90, 90), (255, 255, 255)
CAPTION = "ns between the two avatars on all three trust dimensions"


def font(size):
    for path in ("/System/Library/Fonts/Supplemental/Arial.ttf",
                 "/System/Library/Fonts/Helvetica.ttc"):
        if os.path.exists(path):
            try:
                return ImageFont.truetype(path, size)
            except OSError:
                pass
    return ImageFont.load_default()


def main(target_w=2400):
    ims = [Image.open(f"{DIR}/{n}.png").convert("RGB") for n in PANELS]
    h = max(im.height for im in ims)
    ims = [im.resize((int(im.width * h / im.height), h), Image.LANCZOS) for im in ims]

    scale = (target_w - 2 * MARGIN - 2 * PAD) / sum(im.width for im in ims)
    ims = [im.resize((int(im.width * scale), int(im.height * scale)), Image.LANCZOS) for im in ims]

    W = sum(im.width for im in ims) + 2 * PAD + 2 * MARGIN
    H = max(im.height for im in ims) + CAP_H + 2 * MARGIN
    canvas = Image.new("RGB", (W, H), WHITE)
    d = ImageDraw.Draw(canvas)

    x = MARGIN
    for im in ims:
        canvas.paste(im, (x, MARGIN))
        x += im.width + PAD

    f = font(36)
    tw = d.textbbox((0, 0), CAPTION, font=f)[2]
    d.text(((W - tw) / 2, MARGIN + max(i.height for i in ims) + 10), CAPTION, fill=GREY, font=f)

    dst = f"{DIR}/trust_subscales_3panel.png"
    canvas.save(dst)
    print(f"{canvas.size[0]} x {canvas.size[1]}   {dst}")


if __name__ == "__main__":
    main()
