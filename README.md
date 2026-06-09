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

## Source files

```
slides.md                        # entry point (theme, cover, agenda, src includes)
pages/
  part1/
    part1-foundations.md         # Part I slides
    skipped.md                   # slides removed from the deck, kept for reference
  part2/
    part2-quality-metrics.md     # Part II slides
public/
  assets/
    part1/                       # Part I image assets
    part2/                       # Part II image assets
    cinematic/                   # shared cinematic backgrounds (cinematic-1..10.jpg)
    plane.jpg                    # cover slide asset
    logo qualabs 2019 blanco .png
components/                      # custom Vue components
snippets/                        # syntax-highlighted code snippets
```

---