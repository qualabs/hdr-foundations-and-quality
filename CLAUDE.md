# HDR Video & VQ Metrics — Presentation

Slidev presentation on HDR color science and video quality metrics.
Authors: Emil Santurio (Part 1) and Manuel Barrabino (Part 2).

## Project layout

```
slides.md                   # entry point: theme, title, agenda, src includes
src/
  part1-foundations.md      # Part 1 — all content slides (complete)
  part2-quality-metrics.md  # Part 2 — placeholder, WIP (Manu's section)
images/                     # local image assets referenced in slides
components/                 # custom Vue components for the deck
snippets/                   # syntax-highlighted code snippets
pages/                      # additional routed pages
```

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
pnpm dev      # hot-reload dev server at http://localhost:3030
pnpm build    # static build output
pnpm export   # PDF export
```

## Part 2 status

`src/part2-quality-metrics.md` is a placeholder. The agenda items (1, 2, 3) are unfilled.
Manu owns this section. Do not restructure or fill in content without his input.

