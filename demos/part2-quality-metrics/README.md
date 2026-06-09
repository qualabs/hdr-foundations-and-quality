# 🎬 Workshop: Perceptual Video Quality Evaluation with ColorVideoVDP

**Goal:** Learn to use ColorVideoVDP to evaluate video visual quality and understand the advantages of perceptual metrics.

---

## 📦 Part 0 — Installation (do this BEFORE the workshop)

### Clone with submodules

This repo uses Git submodules. Make sure to initialize them when cloning:

```bash
# Fresh clone
git clone --recurse-submodules <repo-url>

# Already cloned without submodules?
git submodule update --init --recursive
```

### Run the installer

Run the installer for your operating system.

### Mac

```bash
bash demos/part2-quality-metrics/install/Mac/setup.sh
```

### Windows

```cmd
demos\part2-quality-metrics\install\Windows\setup.bat
```

> **Prerequisites:** Python 3 and ffmpeg must be installed on your system.
> The script checks that both are present (if either is missing, it tells you how to install it),
> creates a virtual environment (`venv`), and automatically installs PyTorch and ColorVideoVDP.
> When done, it runs a quick test to confirm everything works.

Once installed, activate the virtual environment before starting:

**Mac:**
```bash
source demos/part2-quality-metrics/colorvideovdp/venv/bin/activate
cd demos/part2-quality-metrics/colorvideovdp
```

**Windows:**
```cmd
demos\part2-quality-metrics\colorvideovdp\venv\Scripts\activate.bat
cd demos\part2-quality-metrics\colorvideovdp
```

---

## 🧠 Part 1 — Context (5 min)

### What is ColorVideoVDP?

It is a **full-reference** visual quality metric (it requires a reference video and a distorted video). Unlike PSNR, SSIM, or Delta E, it models human vision including:

- **Spatial sensitivity** — not all frequencies are perceived equally
- **Temporal sensitivity** — artifacts that change over time are noticed differently
- **Chromatic sensitivity** — color channels (red-green, violet-yellow) are processed separately
- **Display model** — accounts for display size, resolution, brightness, and viewing distance

### What does it produce?

| Output | Description |
|---|---|
| **JOD** (0–10) | Single quality score. 10 = identical. Each 1 JOD drop ≈ 75% of observers notice the difference. |
| **Heatmap** | Video/image showing *where* spatially the artifact is visible. |
| **Distogram** | Diagram decomposing distortion by visual channel and frequency band over time. |

---

## ✅ Part 2 — Environment check (5 min)

Verify that `cvvdp` works by listing the available display models:

```bash
cvvdp --display '?'
```

You should see a list including `standard_fhd`, `standard_4k`, `standard_hdr_pq`, among others.

---

## 👀 Part 2.5 — Review the assets (before running commands)

Before running the metric, open the `demos/part2-quality-metrics/assets/` folder and **play the videos** with your preferred player. Get familiar with what you're about to analyze:

| File | Description |
|---|---|
| `ref.mp4` | **Reference** video (no distortion) |
| `test-blur-20.mp4` | Same video but with a **localized circular blur** in one area of the frame |
| `test-flicker-20.mp4` | Same video but with a **localized circular flicker** in one area of the frame |

> 💡 Watch each one and try to notice the differences from the original.
> Can you identify the affected area? Which of the two artifacts feels more annoying?
> Write down your impression before seeing the numerical results.

---

## 🔬 Part 3 — Exercise A: Quality comparison (10 min)

### Premise

Imagine you are evaluating two clips that scored the same VMAF due to different artifacts. Your job: determine which artifact produces the **worst** visual experience and understand **why**.

### The two artifacts

The videos you reviewed in the previous step:

1. **Blur** — `test-blur-20.mp4`
2. **Flicker** — `test-flicker-20.mp4`

### Run each comparison and record the JOD:

```bash
cvvdp --test ./assets/test-blur-20.mp4 \
      --ref ./assets/ref.mp4 \
      --display standard_fhd
```

```bash
cvvdp --test ./assets/test-flicker-20.mp4 \
      --ref ./assets/ref.mp4 \
      --display standard_fhd
```

### 📋 Fill in this table:

| Artifact | JOD (your result) |
|---|---|
| Blur | _____ |
| Flicker | _____ |

**Questions:**
- Which one has worse quality (lower JOD)? You should see that **flicker** has a noticeably lower JOD (~9.41) than **blur** (~9.77). Both artifacts are small and localized, but the human visual system is more sensitive to temporal flickering.
- Does it match your visual impression from the previous step?

### 🧮 Translating JOD to human preference

JOD gives us a quality number, but what does it mean in practice? We use the formula:

> **P(ref ≻ test) = Φ( ΔJOD / (σ√2) )**
>
> Where ΔJOD = 10 − JOD_test

![delta jod vs probability](./delta-jod-vs-probability.png)

This tells us **what percentage of humans would prefer the original clip** over the distorted one.

Run the script with the JODs you obtained (replace the values):

```bash
python ../jod-to-human-preference.py <JOD_blur> <JOD_flicker>
```

Example: if you got JOD 8.5 for blur and 7.2 for flicker:

```bash
python ../jod-to-human-preference.py 8.5 7.2
```

### 📋 Fill in this table with the results:

| Artifact | JOD | % prefer original |
|---|---|---|
| Blur | _____ | _____ |
| Flicker | _____ | _____ |

**Question:** At what JOD threshold would you consider the distortion "acceptable" for production?

---

## 🗺️ Part 4 — Exercise B: Visual analysis with heatmaps and distograms (10 min)

Now generate the visual outputs for both distortions:

```bash
cvvdp --test ./assets/test-blur-20.mp4 \
      --ref ./assets/ref.mp4 \
      --display standard_fhd \
      --heatmap supra-threshold \
      --distogram \
      --output-dir results

cvvdp --test ./assets/test-flicker-20.mp4 \
      --ref ./assets/ref.mp4 \
      --display standard_fhd \
      --heatmap supra-threshold \
      --distogram \
      --output-dir results
```

This generates in the `results/` folder:
- `test-blur-20_heatmap.mp4` — blur heatmap
- `test-flicker-20_heatmap.mp4` — flicker heatmap
- `test-blur-20_distogram.png` — blur distogram
- `test-flicker-20_distogram.png` — flicker distogram

### 🔥 Guide: how to read the heatmap

The heatmap overlays a color layer on the grayscale video. The color indicates **how much a human will notice** the distortion in that area:

- **Dark blue / black** → The file has mathematical differences from the original, but the visual system simulation says **the human is blind to them**. They won't be noticed.
- **Green / yellow** → Moderate distortion. Some observers will notice it, others won't.
- **Bright red / white** → **Maximum alert.** 100% of users will notice an obvious defect in that area.

> 💡 Key takeaway: an all-dark-blue heatmap = perceptually perfect quality, even if the file has pixel-level differences.

### 📊 Guide: how to read the distogram

The distogram decomposes distortion into **human visual system channels** (columns) and **spatial frequency bands** (Y axis), over time (X axis):

**Columns — visual channels:**
| Channel | What it detects |
|---|---|
| `A-sust` | Achromatic sustained — static luminance patterns (detail, texture, edges) |
| `A-trans` | Achromatic transient — temporal changes (flicker, shimmer) |
| `RG` | Chromatic red-green |
| `YV` | Chromatic violet-yellow |

**Y axis — spatial frequency:**
| Band | Meaning |
|---|---|
| `BB` (base, bottom) | Low frequencies — gradual changes, overall uniformity |
| Middle bands | Mid frequencies — textures, patterns |
| High bands (top) | High frequencies — fine edges, sharp detail |

**Cell color:** more yellow/bright = more visible distortion in that channel and frequency.

> 💡 The distogram tells you **why** something looks bad: if the energy is in `A-trans` it's a temporal problem (flicker); if it's in the high bands of `A-sust` it's sharpness loss (blur); if it's in `RG`/`YV` it's a chromatic problem.

---

### 📋 Questions to analyze:

**Heatmaps:**
1. Is the affected circular area clearly visible in each heatmap? In both cases you should see a well-defined circular patch — the rest of the image is dark blue (no perceptible distortion).
2. What colors do you see in each heatmap's patch? The flicker should show warmer colors (more visible) than the blur.

**Distograms:**
1. In the **blur** distogram: which channel holds the energy? You should see stable horizontal bands in `A-sust` (achromatic sustained) and something in `RG`/`YV` at low frequencies. The `A-trans` channel should be **completely dark** — blur does not change between frames.
2. In the **flicker** distogram: which channel lights up? You should see a continuous, bright band in `A-trans` (achromatic transient) at low-to-mid frequencies. Additionally, `A-sust` shows a **checkerboard pattern** — it turns on and off rhythmically because the flicker alternates between the original and the altered frame.
3. Why does flicker have a worse JOD than blur? Look at the distograms: flicker activates `A-trans`, a channel where we are **highly sensitive** to any change. Blur only affects `A-sust` at high bands, where masking and the CSF reduce sensitivity.

> **Key conclusion:** The distogram lets you diagnose the *nature* of the artifact. If the energy is in `A-trans` → temporal problem. If it's in high-band `A-sust` → sharpness loss. If it's in `RG`/`YV` → chromatic problem.

---

## 🖥️ Part 5 — Bonus: Changing the display (5 min)

Repeat the analysis using a 4K display instead of Full HD:

```bash
cvvdp --test ./assets/test-blur-20.mp4 ./assets/test-flicker-20.mp4 \
      --ref ./assets/ref.mp4 \
      --display standard_4k \
      --heatmap supra-threshold \
      --distogram \
      --output-dir results_4k
```

### 📋 Fill in this table:

| Artifact | JOD on FHD | JOD on 4K | Did it go up or down? |
|---|---|---|---|
| Blur | _____ | _____ | _____ |
| Flicker | _____ | _____ | _____ |

### 📋 Questions:

1. The **blur JOD should drop** (worsen) on 4K (~9.77 → ~9.60). Why? Because a 4K display has more pixels per degree (75.4 ppd vs 37.8 ppd) → it can resolve higher spatial frequencies → the *absence* of detail removed by the blur becomes more apparent.
2. The **flicker JOD should remain virtually the same** (~9.41 → ~9.41). Why? Because flicker is a **purely temporal** artifact — temporal frequency does not change with display resolution. The ppd does not affect the `A-trans` channel.
3. Connect this to the distograms: blur lives in `A-sust` (spatial channel, sensitive to ppd) and flicker lives in `A-trans` (temporal channel, independent of ppd). **The distograms already anticipated which artifact would change with the display.**

---


### Quick command reference

```bash
# JOD only
cvvdp --test <test> --ref <ref> --display standard_fhd

# JOD + heatmap + distogram
cvvdp --test <test> --ref <ref> --display standard_fhd \
      --heatmap supra-threshold --distogram

# Save results to CSV
cvvdp --test <test> --ref <ref> --display standard_fhd --result results.csv

# JOD → human preference
python ../jod-to-human-preference.py <jod_1> <jod_2> ...

# Heatmap options: threshold (near threshold), supra-threshold (large differences), raw
# List available displays: cvvdp --display '?'
```
