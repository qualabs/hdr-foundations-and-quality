#!/usr/bin/env bash
#
# Demo 3 — 8-bit vs 10-bit: making banding visible
#
# Ties to slide: "Bit depth: why HDR needs ≥ 10 bits"
#
# Two artifacts:
#
# A. Static PNG comparison (sidebyside.png)
#    Full black-to-white horizontal gradient at 8-bit vs 10-bit precision.
#    With dithering disabled and explicit per-pixel painting (geq filter),
#    the 8-bit version shows 256 discrete vertical bands ≈ 7.5 px wide;
#    the 10-bit version is smooth.
#
# B. Two separate playback clips:
#       gradient_sdr_8bit.mp4   — SDR pipeline: BT.709 + gamma, 8-bit
#       gradient_hdr10.mp4      — HDR10 pipeline: BT.2020 + PQ, 10-bit
#                                 with ST 2086 mastering display + MaxCLL/MaxFALL
#
#    Each file is signaled as its OWN format. We deliberately do NOT
#    stack them in a single HDR container — doing so would force the
#    player to tone-map the SDR clip into HDR, hiding the banding and
#    making the comparison dishonest. Play them in two separate windows
#    (or one after the other) on an HDR-capable display.
#
# Outputs:
#   sidebyside.png             — A. static PNG comparison
#   gradient_sdr_8bit.mp4      — fully signaled SDR BT.709 gradient (8-bit)
#   gradient_hdr10.mp4         — fully signaled HDR10 PQ gradient (10-bit)
#   gradient_8bit.mp4          — 8-bit SDR control (lossless, no transfer differences)
#   gradient_10bit.mp4         — 10-bit SDR control (lossless, no transfer differences)

set -euo pipefail

OUTDIR="$(dirname "$0")/out_demo3"
mkdir -p "$OUTDIR"

W=1920
H=400

############################################################
# A. Static PNG side-by-side
############################################################

echo "── A.1 Build the 8-bit gradient (full black → white) ───────────────"
# Sweep luma 0..255 across W columns, floor() to integer steps.
# 256 steps over 1920 px → ~7.5 px per band.
ffmpeg -y -hide_banner -loglevel error \
  -f lavfi -i "color=c=black:s=${W}x${H}:d=1,format=gray" \
  -vf "geq=lum='floor(255 * X / ${W})':interpolation=nearest,format=yuv420p,format=yuv420p" \
  -frames:v 1 -sws_dither none "$OUTDIR/gradient_8bit.png"

echo "── A.2 Build the 10-bit gradient (full black → white) ──────────────"
# Sweep 0..1023 across W columns → ~1.9 px per step, visually smooth.
ffmpeg -y -hide_banner -loglevel error \
  -f lavfi -i "color=c=black:s=${W}x${H}:d=1,format=gray16le" \
  -vf "geq=lum='floor(1023 * X / ${W}) * 64':interpolation=nearest,format=yuv420p10le" \
  -frames:v 1 -sws_dither none "$OUTDIR/gradient_10bit.png"

echo "── A.3 Static side-by-side PNG ─────────────────────────────────────"
ffmpeg -y -hide_banner -loglevel error \
  -i "$OUTDIR/gradient_8bit.png" -i "$OUTDIR/gradient_10bit.png" \
  -filter_complex "\
    [0:v]drawtext=text='8-bit  (256 steps across 0..255 — banding)':x=20:y=20:fontsize=28:fontcolor=white:box=1:boxcolor=black@0.7[a];\
    [1:v]drawtext=text='10-bit (1024 steps across the same range — smooth)':x=20:y=20:fontsize=28:fontcolor=white:box=1:boxcolor=black@0.7[b];\
    [a][b]vstack=inputs=2" \
  -sws_dither none \
  "$OUTDIR/sidebyside.png"

############################################################
# B. Two SEPARATE playback files
############################################################

echo "── B.1 SDR 8-bit pipeline (BT.709 + gamma) ─────────────────────────"
# Plain SDR: H.264, yuv420p, BT.709 primaries, BT.709 transfer (gamma).
# Black-to-white gradient.
ffmpeg -y -hide_banner -loglevel error \
  -f lavfi -i "color=c=black:s=${W}x${H}:d=5,format=gray" \
  -vf "geq=lum='floor(255 * X / ${W})':interpolation=nearest,format=yuv420p" \
  -c:v libx264 -preset veryslow -qp 0 -pix_fmt yuv420p \
  -color_primaries bt709 -color_trc bt709 -colorspace bt709 -color_range tv \
  "$OUTDIR/gradient_sdr_8bit.mp4"

echo "── B.2 HDR10 10-bit pipeline (BT.2020 + PQ + ST 2086 + CLL) ────────"
# Fully signaled HDR10. Same conceptual gradient, but 1024 steps.
ffmpeg -y -hide_banner -loglevel error \
  -f lavfi -i "color=c=black:s=${W}x${H}:d=5,format=gray16le" \
  -vf "geq=lum='floor(1023 * X / ${W}) * 64':interpolation=nearest,format=yuv420p10le" \
  -c:v libx265 \
  -x265-params "colorprim=bt2020:transfer=smpte2084:colormatrix=bt2020nc:range=limited:hdr-opt=1:repeat-headers=1:master-display=G(13250,34500)B(7500,3000)R(34000,16000)WP(15635,16450)L(10000000,1):max-cll=1000,400" \
  -pix_fmt yuv420p10le \
  "$OUTDIR/gradient_hdr10.mp4"

echo "── B.3 Control: SDR 8-bit vs SDR 10-bit (no transfer-function diff) ─"
# Both BT.709, only bit depth changes. Useful to isolate the bit-depth axis.
ffmpeg -y -hide_banner -loglevel error \
  -f lavfi -i "color=c=black:s=${W}x${H}:d=5,format=gray" \
  -vf "geq=lum='floor(255 * X / ${W})':interpolation=nearest,format=yuv420p" \
  -c:v libx264 -preset veryslow -qp 0 -pix_fmt yuv420p \
  -color_primaries bt709 -color_trc bt709 -colorspace bt709 -color_range tv \
  "$OUTDIR/gradient_8bit.mp4"

ffmpeg -y -hide_banner -loglevel error \
  -f lavfi -i "color=c=black:s=${W}x${H}:d=5,format=gray16le" \
  -vf "geq=lum='floor(1023 * X / ${W}) * 64':interpolation=nearest,format=yuv420p10le" \
  -c:v libx265 -x265-params "lossless=1" -pix_fmt yuv420p10le \
  -color_primaries bt709 -color_trc bt709 -colorspace bt709 -color_range tv \
  "$OUTDIR/gradient_10bit.mp4"

echo
echo "── Done ────────────────────────────────────────────────────────────"
echo "  Static PNG comparison:"
echo "    $OUTDIR/sidebyside.png"
echo
echo "  Honest playback comparison (open the two files SIDE BY SIDE,"
echo "  or play one after the other so the display switches modes):"
echo "    $OUTDIR/gradient_sdr_8bit.mp4   — SDR pipeline (BT.709 + gamma, 8-bit)"
echo "    $OUTDIR/gradient_hdr10.mp4      — HDR10 pipeline (BT.2020 + PQ, 10-bit)"
echo
echo "  Bit-depth control (same transfer function on both, only bit depth differs):"
echo "    $OUTDIR/gradient_8bit.mp4       — SDR BT.709, 8-bit"
echo "    $OUTDIR/gradient_10bit.mp4      — SDR BT.709, 10-bit"
echo
echo "── Talking points ──────────────────────────────────────────────────"
echo "  Full black-to-white sweep across 1920 pixels:"
echo "    • 8-bit:  256 discrete steps → bands ≈ 7.5 px wide"
echo "    • 10-bit: 1024 discrete steps → ≈ 1.9 px per step → smooth"
echo
echo "  Why not stack them in one HDR container?"
echo "    If we vstack an SDR clip and an HDR10 clip into one HDR10 file,"
echo "    the player tone-maps the SDR half into the HDR luminance range —"
echo "    which softens / hides the banding and makes the comparison"
echo "    dishonest. Two separate files, each tagged with its own format,"
echo "    is the only way the display engages the correct pipeline for"
echo "    each one."
echo
echo "  On an HDR-capable TV:"
echo "    • Play gradient_sdr_8bit.mp4 first → TV stays in SDR mode → banding"
echo "    • Play gradient_hdr10.mp4 next    → TV switches to HDR10 → smooth"
echo
echo "  PQ stretches 1024 code values across 10,000 nits — 8-bit applied"
echo "  to that range would produce ~40 nits per step in shadows, far above"
echo "  the Barten JND threshold → guaranteed banding."
