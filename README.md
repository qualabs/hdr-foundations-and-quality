# HDR Video & VQ Metrics

A [Slidev](https://sli.dev/) presentation covering HDR color science fundamentals and video quality metrics.

**Authors:** Emil Santurio · Manuel Barrabino

---

## Running the presentation

```bash
npm install
npm run dev      # dev server with hot-reload at http://localhost:3030
npm run build    # static build
npm run export   # export to PDF
```

---

## Structure

The deck is split across two complete parts.

### Part I — Foundations

Six sections covering the technical substrate of HDR:

| # | Section | Key topics |
|---|---------|-----------|
| 1 | **Color Vocabulary** | Gamut vs. model vs. space; CIE 1931 chromaticity diagram; BT.709 / DCI-P3 / BT.2020 primaries |
| 2 | **Signal Plumbing** | YCbCr matrix coefficients (BT.709 vs. BT.2020); bit depth and the Barten model; narrow vs. full range; HEVC VUI signaling (`colour_primaries`, `transfer_characteristics`, `matrix_coefficients`) |
| 3 | **The Transfer Function** | OETF vs. EOTF; why linear encoding wastes bits; SDR ceiling at ~100 nits |
| 4 | **Why HDR Exists** | Luminance range (SDR ~10 stops vs. real world ~20 stops); wider gamut; perceptual precision |
| 5 | **How HDR Solves It** | PQ (ST 2084) — absolute, display-referred, up to 10,000 nits; HLG — scene-referred, broadcast-compatible; static metadata (ST 2086 + CTA-861.3 MaxCLL/MaxFALL); dynamic metadata (HDR10+ / Dolby Vision); HDR format landscape |
| 6 | **Recap & Handoff** | Consolidated summary; hand-off to Part 2 |

### Part II — HDR Video Quality Metrics

Four sections on HDR-aware perceptual quality metrics:

| # | Section | Key topics |
|---|---------|-----------|
| 1 | **Limitations of Traditional Metrics** | VMAF's SDR-centric design; EOTF and color space mismatch (PQ/BT.2020 vs. Gamma/BT.709) |
| 2 | **HDRMAX** | Non-linear tone-mapping patch on top of VMAF; tradeoffs |
| 3 | **ColorVideoVDP** | Perceptual model; inputs/outputs; JOD scoring; SRCC results vs. LIVE-HDR dataset |
| 4 | **Hands-on** | Practical demo and metrics comparison |

---

## Live Demos (Part I)

Three runnable scripts in [`demos/part1-foundations/`](demos/part1-foundations/) designed to be executed alongside the slides. Full prerequisites and running instructions in the [demo README](demos/part1-foundations/README.md).

| # | Script | Ties to slide | What it shows |
|---|--------|--------------|---------------|
| 1 | `01_ffprobe_hdr_inspection.sh` | HEVC VUI signaling | Reads `colour_primaries`, `transfer_characteristics`, `matrix_coefficients` + ST 2086 / MaxCLL / MaxFALL from a real HDR10 file |
| 2 | `02_wrong_matrix_red_shift.py` | YCbCr matrix coefficients | Reproduces the slide's numerical example; generates a side-by-side PNG showing the color shift from using the wrong matrix |
| 3 | `03_bit_depth_banding.sh` | Bit depth / Barten model | Produces a static 8-bit vs 10-bit gradient comparison + fully signaled SDR and HDR10 playback files |

**Suggested order during the talk:** Demo 1 after the VUI signaling slide → Demo 2 after the wrong-matrix numerical example → Demo 3 after the bit-depth slide.

---

## Live Demos (Part II)

Workshop-style hands-on session in [`demos/part2-quality-metrics/`](demos/part2-quality-metrics/), designed to be run alongside the **Hands-on** section of Part II. Full installation instructions and running order in the [demo README](demos/part2-quality-metrics/README.md).

The workshop uses [ColorVideoVDP](demos/part2-quality-metrics/colorvideovdp/) (included as a Git submodule) and a set of curated video assets. Install first with the platform-specific script, then activate the virtual environment before the talk.

| # | Exercise | Ties to slide | What it shows |
|---|----------|--------------|---------------|
| 0 | Installation (`install/Mac/setup.sh` · `install/Windows/setup.bat`) | Prerequisites | Creates a venv, installs PyTorch + ColorVideoVDP, runs a sanity check |
| 1 | JOD comparison — blur vs. flicker | ColorVideoVDP outputs | Runs `cvvdp` on `test-blur-20.mp4` and `test-flicker-20.mp4` against `ref.mp4`; participants fill in the JOD table |
| 2 | JOD → human preference (`jod-to-human-preference.py`) | Psychometric curve (ΔP formula) | Converts raw JOD scores to percentage of observers who would prefer the original |
| 3 | Heatmap + distogram generation | A-sust / A-trans / RG / YV channels | Produces visual artifacts maps; participants diagnose *why* flicker is worse than blur |
| 4 | Bonus — display swap (`standard_fhd` → `standard_4k`) | Display model & ppd | Shows how blur JOD degrades on 4K while flicker JOD stays flat, validating the spatial vs. temporal channel split |

**Suggested order during the talk:** Exercise 0 must run before the session → Exercise 1 after the HDRMAX limitations slide → Exercises 2–3 after the ColorVideoVDP inputs/outputs slide → Exercise 4 as a wrap-up bonus.
