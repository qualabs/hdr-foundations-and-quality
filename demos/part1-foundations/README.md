# HDR Demos

Three short, repeatable demos to run alongside the slides.

## Prerequisites

- **ffmpeg / ffprobe** with `libx265` and `libx264` enabled (any recent build, 5.x or 6.x).
- **bash** (any 4.x+).
- Optional, for richer output on Demo 1: **gpac** (`MP4Box`).
- Optional, to grab a real HDR10 sample for Demo 1: **yt-dlp** or a local file.

On macOS: `brew install ffmpeg gpac yt-dlp`
On Ubuntu: `apt install ffmpeg gpac yt-dlp`

Make all scripts executable once:

```bash
chmod +x *.sh
```

## Demo 1 — `01_ffprobe_hdr_inspection.sh`

**Ties to slide:** *HEVC VUI signaling — three independent axes*

Runs `ffprobe` on an HDR10 file and prints:

1. The three VUI integers — `color_primaries`, `color_transfer`, `color_space` (matrix), plus `color_range`.
2. SEI side-data — ST 2086 mastering display + CTA-861.3 MaxCLL / MaxFALL.
3. Container-level DOVI box, if present.

**Run:**

```bash
./01_ffprobe_hdr_inspection.sh path/to/sample_hdr10.mp4
```

**What to point at on screen:** `color_primaries=9, transfer=16, color_space=bt2020nc` → exactly the HDR10 values from the slide. Then scroll down to the side-data block and read off the mastering display primaries and MaxCLL.

**Where to get an HDR10 sample:** `https://4kmedia.org`, `https://jell.yfish.us`, or pull a YouTube HDR clip with `yt-dlp -f 'bestvideo[vcodec*=hev1]' <url>`.

**Quick alternative:** Demo 3 produces a small, fully signaled HDR10 file you can feed to Demo 1:

```bash
./03_bit_depth_banding.sh
./01_ffprobe_hdr_inspection.sh out_demo3/gradient_hdr10.mp4
```

It will show BT.2020 primaries, PQ transfer, BT.2020 NCL matrix, the full ST 2086 mastering display block, and MaxCLL/MaxFALL = 1000/400.

---

## Demo 2 — `02_wrong_matrix_red_shift.py`

**Ties to slides:** *YCbCr matrix coefficients* + *What happens if you use the wrong matrix*

Reproduces the slide's numerical example **exactly**, in Python, with no ffmpeg in the loop. We apply only the YCbCr matrix (no gamut conversion, no transfer function) — which is exactly what the slide does and what really happens inside a decoder when `matrix_coefficients` is wrong: the YCbCr bytes don't change, only the matrix that maps them back to RGB does.

**Why Python and not ffmpeg:** ffmpeg's `colorspace` filter cannot apply *only* the YCbCr matrix — it insists on also converting primaries. That forces a gamut roundtrip (BT.709 → BT.2020 → BT.709) that shifts the reference color into orange before we even start, polluting the comparison. Python lets us apply the matrix in isolation.

**Requires:** `pip install numpy pillow`

**Run:**

```bash
python3 02_wrong_matrix_red_shift.py
open out_demo2/out_sidebyside.png
```

**What you'll see:**

- Terminal prints the slide's exact numerical example: encode (0.9, 0.1, 0.1) with BT.2020, decode both ways, show the +43.8% jump in green.
- `out_correct.png` is **pure saturated red** (`#E61919`) — the original.
- `out_wrong.png` is the same image decoded with the BT.709 matrix → a **warmer, slightly orange-shifted red** (`#F0251A`).
- The side-by-side puts them next to each other for the audience.

**Bonus angle:** edit the script and change `rgb_original` to `[0.5, 0.5, 0.5]` (neutral gray). Re-run and notice the wrong/correct outputs are nearly identical — exactly because the matrix differences cancel out when R'≈G'≈B'.

---

## Demo 3 — `03_bit_depth_banding.sh`

**Ties to slide:** *Bit depth: why HDR needs ≥ 10 bits*

Two artifacts:

1. **Static PNG comparison** (`sidebyside.png`) — full black-to-white gradient at 8-bit vs 10-bit precision. With dithering disabled the 8-bit version shows 256 discrete vertical bands; the 10-bit version is smooth.
2. **Two separate playback files**:
   - `gradient_sdr_8bit.mp4` — fully signaled SDR (H.264, BT.709 + gamma, 8-bit)
   - `gradient_hdr10.mp4` — fully signaled HDR10 (HEVC, BT.2020 + PQ + ST 2086 + MaxCLL/MaxFALL, 10-bit)

   They are **NOT** stacked into one container on purpose: if you put an SDR clip inside an HDR10 container the player tone-maps the SDR half up into HDR's range, which softens the banding and makes the comparison dishonest. Each file carries its own signaling so the display engages the correct pipeline.

**Run:**

```bash
./03_bit_depth_banding.sh
open out_demo3/sidebyside.png
# Then on the HDR TV, play these two files one after the other:
open out_demo3/gradient_sdr_8bit.mp4   # TV stays in SDR mode → banding visible
open out_demo3/gradient_hdr10.mp4      # TV switches to HDR10  → smooth
```

**What to point at on screen:**

- `sidebyside.png` works on any monitor — the 8-bit gradient shows 256 hard vertical bands across the full range; the 10-bit half is visibly smoother.
- On the **HDR TV**: play the SDR file first → screen stays SDR → banding. Then play the HDR10 file → screen switches mode → smooth gradient across the full luminance range. The mode switch itself is part of the demo.
- On an **SDR monitor** both files look 8-bit because the display itself is the bottleneck — useful discussion point: HDR demands a 10-bit pipeline **end-to-end**.
- You can re-run **Demo 1** on `gradient_hdr10.mp4` to see all the HDR10 signaling (BT.2020 / PQ / BT.2020 NCL + mastering display + MaxCLL/MaxFALL) on a file you generated yourself.

---

## Suggested running order during the talk

1. After the **VUI signaling slide**, run **Demo 1** on a real HDR10 file → real-world confirmation of the three axes + static SEI metadata.
2. After the **"wrong matrix"** numerical example, run **Demo 2** → visualize the 44% green-channel jump as the orange shift.
3. After the **bit-depth slide**, run **Demo 3** → if you have a 10-bit display, the banding lands hard. If not, use it to talk about end-to-end pipeline requirements.

## Cleaning up

```bash
rm -rf out_demo2 out_demo3
```
