# HDR Video & VQ Metrics — Presentation

Slidev presentation on HDR color science and video quality metrics.
Authors: Emil Santurio (Part 1) and Manuel Barrabino (Part 2).

## Project layout

```
slides.md                        # entry point: theme, title, agenda, src includes
parts/                           # slide partials importados via src: (NO usar pages/)
  part1/
    part1-foundations.md         # Part 1 — all content slides (complete)
    skipped.md                   # slides removed from the deck, kept for reference
    assets/                      # imágenes de Part 1, co-ubicadas con el .md
      colorful.jpg, cie1931_dark_v2.png, banding.jpg, window.jpg
      transfer_gamma.png, transfer_pq.png, transfer_hlg.png, transfer_comparison.png
      out_demo2/                  # demo media: matrix/color section
      out_demo3/                  # demo media: banding/bit-depth section
  part2/
    part2-quality-metrics.md     # Part 2 — WIP (Manu's section)
    assets/                      # imágenes de Part 2, co-ubicadas
      vq-image.avif, dilution.png, caja-negra-blanca.png
      cvvdp_input.jpeg, cvvdp_output.png
      jod_psychometric_dark.png, jod_linear_range_dark.png, srcc_dark.png
      hdrmax/                     # HDRMAX explainer SVG sequence (hdrmax-1..5.svg)
cinematic/                       # shared cinematic backgrounds (biblioteca compartida)
  cinematic-1.jpg … cinematic-10.jpg
plane.jpg                        # cover slide asset (raíz = base para slides.md)
logo qualabs 2019 blanco .png    # brand asset
components/                      # custom Vue components for the deck
snippets/                        # syntax-highlighted code snippets
public/                          # vacío — reservado para assets no-bundleables (fuentes, favicon)
```

### Convenciones de paths en los slides

- Imágenes propias de cada parte: rutas relativas `./assets/X`
- Cinematic (compartidas): `../../cinematic/cinematic-N.jpg` desde `parts/partN/`
- Assets del cover en `slides.md`: `./plane.jpg`, `./logo qualabs...`
- **No usar rutas absolutas** (`/path`): en Slidev v52 el plugin `slide-import-guard` las rechaza al no resolverlas desde el project root.
- **No usar el directorio `pages/`** para partials: Slidev lo reserva para presentaciones adicionales con routing propio, lo que rompe la navegación del deck principal.

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

## Dev workflow

```bash
npm run dev      # hot-reload dev server at http://localhost:3030
npm build    # static build output
npm export   # PDF export
```

## Part 2 status

`pages/part2/part2-quality-metrics.md` is WIP — Manu owns this section.
No restructurar ni completar contenido sin su input.

