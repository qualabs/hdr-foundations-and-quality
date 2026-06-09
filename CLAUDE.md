# HDR Video & VQ Metrics — Presentation

Slidev presentation on HDR color science and video quality metrics.
Authors: Emil Santurio (Part 1) and Manuel Barrabino (Part 2).

## Project layout

```
slides.md                        # entry point: theme, title, agenda, src includes
pages/
  part1/
    part1-foundations.md         # Part 1 — all content slides (complete)
    skipped.md                   # slides removed from the deck, kept for reference
  part2/
    part2-quality-metrics.md     # Part 2 — complete
public/
  assets/
    part1/                       # imágenes de Part 1
      cie1931_dark_v2.png, banding.jpg
      transfer_gamma.png, transfer_pq.png, transfer_hlg.png, transfer_comparison.png
      out_demo2/                  # demo media: matrix/color section
      out_demo3/                  # demo media: banding/bit-depth section
    part2/                       # imágenes de Part 2
      vq-image.avif, dilution.png, caja-negra-blanca.png
      cvvdp_input.jpeg, cvvdp_output.png
      jod_psychometric_dark.png, jod_linear_range_dark.png, srcc_dark.png
      hdrmax/                     # HDRMAX explainer SVG sequence (hdrmax-1..5.svg)
    cinematic/                   # shared cinematic backgrounds (cinematic-1..10.jpg)
    plane.jpg                    # cover slide asset
    logo qualabs 2019 blanco .png
components/                      # custom Vue components for the deck
snippets/                        # syntax-highlighted code snippets
demos/
  part1-foundations/
    README.md                    # prerequisites + running order for all 3 demos
    01_ffprobe_hdr_inspection.sh # Demo 1 — reads VUI/SEI HDR10 metadata via ffprobe
    02_wrong_matrix_red_shift.py # Demo 2 — visualizes wrong YCbCr matrix shift (Python/Pillow)
    03_bit_depth_banding.sh      # Demo 3 — generates 8-bit vs 10-bit banding comparison
  part2-quality-metrics/
    README.md                    # workshop guide: installation + 5 exercises (ColorVideoVDP)
    jod-to-human-preference.py   # converts JOD scores → human preference probability (Φ formula)
    delta-jod-vs-probability.png # psychometric curve chart referenced in the workshop
    assets/
      ref.mp4                    # reference video (no distortion)
      test-blur-20.mp4           # localized circular blur artifact
      test-flicker-20.mp4        # localized circular flicker artifact
      otros_ejemplos/            # additional aliasing/structure example clips
    install/
      Mac/setup.sh               # Mac: creates venv, installs PyTorch + ColorVideoVDP
      Windows/setup.bat          # Windows: same setup via bat script
    colorvideovdp/               # Git submodule — ColorVideoVDP library (pycvvdp + examples)
```

### Convenciones de paths en los slides

- Todos los assets van bajo `public/assets/` y se referencian con rutas absolutas desde la raíz: `/assets/part1/X`, `/assets/part2/X`, `/assets/cinematic/cinematic-N.jpg`
- Assets del cover en `slides.md`: `/assets/plane.jpg`, `/assets/logo qualabs...`

## Slide conventions

- Theme: `apple-basic` (`@slidev/theme-apple-basic`)
- Section dividers use `layout: section` (for major topic breaks) or `layout: statement` (for numbered sub-sections with a tagline)
- Content-heavy slides carry `class: text-sm` in their frontmatter
- Grids are built with Tailwind utility classes (`grid grid-cols-2`, `grid grid-cols-3`, `gap-4`, etc.)
- Colored callout boxes follow a consistent pattern:
  - Blue `border-blue-500 bg-blue-500 bg-opacity-10` — key concept / insight
  - Orange `border-orange-500 bg-orange-500 bg-opacity-10` — critical nuance or gotcha
  - Red `border-red-500 bg-red-500 bg-opacity-10` — failure mode / warning
  - Green `border-green-500 bg-green-500 bg-opacity-10` — correct approach / solution
  - Gray `border-gray-500` — neutral comparison box

## Prerequisites

The `slidev` Claude Code skill is required to work effectively on this presentation. Install it with:

```bash
npx skills add slidevjs/slidev
```

## Dev workflow

```bash
npm run dev      # hot-reload dev server at http://localhost:3030
npm run build    # static build output
npm run export   # PDF export
```

