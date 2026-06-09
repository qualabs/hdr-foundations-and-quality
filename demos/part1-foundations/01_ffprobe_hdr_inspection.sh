#!/usr/bin/env bash
#
# Demo 1 — Inspect an HDR10 file with ffprobe
#
# Ties to slide: "HEVC VUI signaling — three independent axes"
#
# Shows two things on screen:
#   (a) the three VUI integers (primaries, transfer, matrix) + range
#   (b) the SEI metadata: ST 2086 mastering display + CTA-861.3 MaxCLL/MaxFALL
#
# Usage:
#   ./01_ffprobe_hdr_inspection.sh <input.mp4>
#
# If no file is passed, the script downloads a small public-domain HDR10 sample.
# You can also point it at any HDR10 / Dolby Vision / HLG file you already have.

set -euo pipefail

INPUT="${1:-}"

# ---------- 0. ensure we have a sample to work with ----------------------
if [[ -z "$INPUT" ]]; then
  echo ">> No input provided."
  echo "   Recommended samples (download manually, then re-run with the path):"
  echo "     - https://4kmedia.org   (LG, Sony, Samsung HDR10 / Dolby Vision demos)"
  echo "     - https://jell.yfish.us (HDR test patterns)"
  echo "     - DemoWorld / The World in HDR (YouTube → yt-dlp in HEVC)"
  echo
  echo "   Example:"
  echo "     yt-dlp -f 'bestvideo[vcodec*=hev1]' <youtube-url> -o sample_hdr10.mp4"
  exit 1
fi

if [[ ! -f "$INPUT" ]]; then
  echo "!! File not found: $INPUT" >&2
  exit 1
fi

echo "============================================================"
echo " File: $INPUT"
echo "============================================================"

# ---------- 1. The three VUI integers ------------------------------------
echo
echo "── (a) VUI: the three independent axes ────────────────────"
echo "    color_primaries        → which gamut triangle"
echo "    color_transfer         → which EOTF / transfer function"
echo "    color_space (in ffprobe) → which YCbCr matrix"
echo "    color_range            → narrow ('tv') or full ('pc')"
echo

ffprobe -v error \
  -select_streams v:0 \
  -show_entries stream=codec_name,profile,pix_fmt,color_primaries,color_transfer,color_space,color_range \
  -of default=noprint_wrappers=1 \
  "$INPUT"

# ---------- 2. SEI metadata: mastering display + content light level -----
echo
echo "── (b) SEI metadata: ST 2086 + CTA-861.3 (HDR10 static) ───"
echo "    Mastering Display Colour Volume → ST 2086"
echo "    MaxCLL / MaxFALL                → CTA-861.3"
echo

# read just the first 5 frames so it doesn't take forever on long files
ffprobe -v error \
  -select_streams v:0 \
  -read_intervals "%+#5" \
  -show_frames \
  -show_entries frame=pkt_pts_time:frame_side_data_list \
  -of default=noprint_wrappers=1 \
  "$INPUT" 2>/dev/null | grep -E "side_data_type|red_x|red_y|green_x|green_y|blue_x|blue_y|white_point|min_luminance|max_luminance|max_content|max_average" \
  || echo "  (no HDR side data found — file may be SDR)"

# ---------- 3. Dolby Vision configuration record, if present -------------
echo
echo "── (c) Container-level signaling ──────────────────────────"
echo "    Looking for the DOVI configuration box (dvvC / dvcC) …"
echo

if command -v MP4Box >/dev/null 2>&1; then
  MP4Box -info "$INPUT" 2>&1 | grep -iE "dvvC|dvcC|DolbyVision|dvh1|dvhe|hvc1|hev1" || \
    echo "  (no Dolby Vision configuration box found)"
else
  # fallback: grep the box atoms directly
  if command -v xxd >/dev/null 2>&1; then
    head -c 200000 "$INPUT" | xxd | grep -iE "dvvc|dvcc|dvh1|dvhe" \
      || echo "  (no Dolby Vision configuration box found in first 200KB)"
  fi
  echo "  (tip: install gpac / MP4Box for a clean readout)"
fi

echo
echo "── Talking points ─────────────────────────────────────────"
echo " • colour_primaries=9, transfer=16, matrix=9 → HDR10 (BT.2020 + PQ + BT.2020 NCL)"
echo " • transfer=18 → HLG"
echo " • Static metadata: same values on every frame (mid-stream tune-in safe)"
echo " • Dolby Vision: same base values + RPU NAL units per frame (not shown by ffprobe)"
