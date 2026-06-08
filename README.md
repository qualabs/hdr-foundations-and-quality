# HDR Video & VQ Metrics

A [Slidev](https://sli.dev/) presentation covering HDR color science fundamentals and video quality metrics.

**Authors:** Emil Santurio · Manuel Barrabino

---

## Running the presentation

```bash
pnpm install        # or npm install
pnpm dev            # starts dev server with hot-reload at http://localhost:3030
pnpm build          # static build
pnpm export         # export to PDF
```

---

## Structure

The deck is split across two parts.

### Part I — Foundations *(Emil)*

Six sections covering the technical substrate of HDR:

| # | Section | Key topics |
|---|---------|-----------|
| 1 | **Color Vocabulary** | Gamut vs. model vs. space; CIE 1931 chromaticity diagram; BT.709 / DCI-P3 / BT.2020 primaries |
| 2 | **Signal Plumbing** | YCbCr matrix coefficients (BT.709 vs. BT.2020); bit depth and the Barten model; narrow vs. full range; HEVC VUI signaling (`colour_primaries`, `transfer_characteristics`, `matrix_coefficients`) |
| 3 | **The Transfer Function** | OETF vs. EOTF; why linear encoding wastes bits; SDR ceiling at ~100 nits |
| 4 | **Why HDR Exists** | Luminance range (SDR ~10 stops vs. real world ~20 stops); wider gamut; perceptual precision |
| 5 | **How HDR Solves It** | PQ (ST 2084) — absolute, display-referred, up to 10,000 nits; HLG — scene-referred, broadcast-compatible; static metadata (ST 2086 + CTA-861.3 MaxCLL/MaxFALL); dynamic metadata (HDR10+ / Dolby Vision); HDR format landscape |
| 6 | **Recap & Handoff** | Consolidated summary; hand-off to Manu for Part 2 |

### Part II — HDR Video Quality Metrics *(Manu)*

Work in progress. Placeholder sections are in place for Manu to fill in.

---

## Source files

```
slides.md                   # entry point (agenda + src includes)
src/
  part1-foundations.md      # Part I slides
  part2-quality-metrics.md  # Part II slides (WIP)
images/                     # image assets
components/                 # Vue components
snippets/                   # code snippets
pages/                      # extra pages
```

---