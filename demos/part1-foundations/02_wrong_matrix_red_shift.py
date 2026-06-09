#!/usr/bin/env python3
"""
Demo 2 — The orange-shifted red: what happens if the YCbCr matrix is wrong.

Ties to slides: "YCbCr matrix coefficients" + "What happens if you use the wrong matrix"

This script reproduces the slide's numerical example exactly:

  Start with a saturated red:        R'=0.9, G'=0.1, B'=0.1
  Encode with BT.2020 NCL matrix  →  Y=0.3101, Cb=-0.1117, Cr=0.3998
  Decode with BT.2020 NCL matrix  →  R'=0.900, G'=0.100, B'=0.100   (correct)
  Decode with BT.709 matrix       →  R'=0.940, G'=0.144, B'=0.103   (wrong)

We apply ONLY the YCbCr matrix — no gamut conversion, no transfer function.
That is exactly what the slide does and what really happens inside a decoder
when matrix_coefficients signaling is wrong: the YCbCr bytes don't change,
only the matrix that maps them back to RGB does.

Output:
    out_demo2/out_correct.png      saturated red (the original)
    out_demo2/out_wrong.png        orange-shifted red
    out_demo2/out_sidebyside.png   labeled comparison
    Prints the exact numerical values to the terminal.

Requires: numpy, Pillow
    pip install numpy pillow
"""

import os
from pathlib import Path
import numpy as np
from PIL import Image, ImageDraw, ImageFont

OUTDIR = Path(__file__).parent / "out_demo2"
OUTDIR.mkdir(exist_ok=True)

W, H = 960, 540


# ---------------------------------------------------------------------------
# Matrix coefficients (BT.2020 NCL and BT.709), non-constant luminance.
# ---------------------------------------------------------------------------

def ycbcr_matrices(Kr: float, Kg: float, Kb: float):
    """Return (RGB→YCbCr, YCbCr→RGB) matrices for the given luma weights."""
    # Forward: Y = Kr*R + Kg*G + Kb*B
    #          Cb = (B - Y) / (2 * (1 - Kb))
    #          Cr = (R - Y) / (2 * (1 - Kr))
    M_fwd = np.array([
        [Kr,                  Kg,                  Kb                ],
        [-Kr/(2*(1-Kb)),     -Kg/(2*(1-Kb)),       0.5               ],
        [0.5,                -Kg/(2*(1-Kr)),      -Kb/(2*(1-Kr))     ],
    ])
    M_inv = np.linalg.inv(M_fwd)
    return M_fwd, M_inv

BT2020_FWD, BT2020_INV = ycbcr_matrices(Kr=0.2627, Kg=0.6780, Kb=0.0593)
BT709_FWD,  BT709_INV  = ycbcr_matrices(Kr=0.2126, Kg=0.7152, Kb=0.0722)


# ---------------------------------------------------------------------------
# Reproduce the slide's example exactly.
# ---------------------------------------------------------------------------

rgb_original = np.array([0.9, 0.1, 0.1])   # saturated red, normalized
print("── Slide example reproduction ─────────────────────────────────────")
print(f"  Input RGB (normalized): R'={rgb_original[0]:.4f}  "
      f"G'={rgb_original[1]:.4f}  B'={rgb_original[2]:.4f}")

# Encode with BT.2020 NCL
ycbcr = BT2020_FWD @ rgb_original
print(f"  Encoded with BT.2020:   Y ={ycbcr[0]:.4f}  "
      f"Cb={ycbcr[1]:.4f}  Cr={ycbcr[2]:.4f}")

# Decode correctly (BT.2020 NCL)
rgb_correct = BT2020_INV @ ycbcr
print(f"  Decoded with BT.2020:   R'={rgb_correct[0]:.4f}  "
      f"G'={rgb_correct[1]:.4f}  B'={rgb_correct[2]:.4f}   (correct)")

# Decode WRONG (BT.709)
rgb_wrong = BT709_INV @ ycbcr
print(f"  Decoded with BT.709:    R'={rgb_wrong[0]:.4f}  "
      f"G'={rgb_wrong[1]:.4f}  B'={rgb_wrong[2]:.4f}   (wrong)")

# How big is the per-channel error?
delta = rgb_wrong - rgb_correct
rel = 100 * delta / np.where(rgb_correct == 0, 1, rgb_correct)
print(f"  Per-channel error:      ΔR={delta[0]:+.4f} ({rel[0]:+.1f}%)  "
      f"ΔG={delta[1]:+.4f} ({rel[1]:+.1f}%)  "
      f"ΔB={delta[2]:+.4f} ({rel[2]:+.1f}%)")
print()


# ---------------------------------------------------------------------------
# Render the two RGB values as flat PNGs.
# ---------------------------------------------------------------------------

def to_8bit(rgb_norm):
    """Clip to [0,1] and convert to 8-bit sRGB-ish bytes for display."""
    arr = np.clip(rgb_norm, 0.0, 1.0)
    return (arr * 255 + 0.5).astype(np.uint8)

correct_rgb8 = to_8bit(rgb_correct)
wrong_rgb8   = to_8bit(rgb_wrong)
print(f"  8-bit display RGB:")
print(f"    Correct: {tuple(int(c) for c in correct_rgb8)}  "
      f"= #{''.join(f'{c:02X}' for c in correct_rgb8)}")
print(f"    Wrong:   {tuple(int(c) for c in wrong_rgb8)}  "
      f"= #{''.join(f'{c:02X}' for c in wrong_rgb8)}")

def flat_png(path, rgb8, label):
    img = Image.new("RGB", (W, H), tuple(int(c) for c in rgb8))
    draw = ImageDraw.Draw(img)
    # Try to grab a default TrueType font; fall back to bitmap default.
    try:
        font = ImageFont.truetype(
            "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 28)
    except OSError:
        font = ImageFont.load_default()
    pad = 12
    bbox = draw.textbbox((0, 0), label, font=font)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    draw.rectangle((10, 10, 10 + tw + 2*pad, 10 + th + 2*pad),
                   fill=(0, 0, 0, 180))
    draw.text((10 + pad, 10 + pad), label, fill="white", font=font)
    img.save(path)

flat_png(OUTDIR / "out_correct.png", correct_rgb8,
         "Correct (decoded with BT.2020 matrix)")
flat_png(OUTDIR / "out_wrong.png",   wrong_rgb8,
         "Wrong   (decoded with BT.709 matrix)")

# Side-by-side
side = Image.new("RGB", (W * 2, H))
side.paste(Image.open(OUTDIR / "out_correct.png"), (0, 0))
side.paste(Image.open(OUTDIR / "out_wrong.png"),  (W, 0))
side.save(OUTDIR / "out_sidebyside.png")

print()
print("── Done ───────────────────────────────────────────────────────────")
print(f"  {OUTDIR / 'out_correct.png'}")
print(f"  {OUTDIR / 'out_wrong.png'}")
print(f"  {OUTDIR / 'out_sidebyside.png'}")
