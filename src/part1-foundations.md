---
layout: intro-image-right
image: '/images/colorful.jpg'
---

# HDR Color Spaces
## Part I — Foundations

---
layout: statement
---

# 1. Color Vocabulary

### Why we need a precise one before talking about HDR?

---
class: text-sm
---

# Three words people mix up

<div class="grid grid-cols-3 gap-4 pt-4">

<div class="p-3 rounded border border-gray-500">

### Color Gamut

The **range** of colors a system can reproduce.

A triangle on a chromaticity diagram.

</div>

<div class="p-3 rounded border border-gray-500">

### Color Model

The **structure** of numerical components (RGB, YCbCr, ICtCp).

How you arrange the numbers.

</div>

<div class="p-3 rounded border border-gray-500">

### Color Space

A **complete coordinate system**:
primaries + white point + transfer function.

</div>

</div>

<div class="pt-6 text-center opacity-70">
Confusing them is the root cause of half the HDR mistakes you'll see in the wild.
</div>

---
class: text-sm
---

# CIE 1931 Chromaticity Diagram
<div class="grid grid-cols-2 gap-6">

<div class="pt-2">

The **universal reference frame** for defining color gamuts.

- Built from color matching experiments (CIE, 1931).
- Three color matching functions $\bar{x}(\lambda), \bar{y}(\lambda), \bar{z}(\lambda)$ define the CIE XYZ space.
- **Chromaticity** = projection of XYZ to 2D:

$$x = \frac{X}{X+Y+Z} \quad y = \frac{Y}{X+Y+Z}$$

- **Horseshoe boundary** = purest spectral colors.
- **Interior** = mixtures of wavelengths.

</div>

<div class="flex items-center justify-center">

<img src="/images/cie1931_dark_v2.png" />


</div>

</div>

---
class: text-sm
---

# Reading the diagram

<div class="grid grid-cols-2 gap-6 pt-2">

<div>

### What it tells you

- **Position of each gamut** as a triangle
- **Primaries** = vertices
- **White point** = neutral anchor (usually D65)
- **Bigger triangle = wider gamut**

</div>

<div>

### Two big caveats

- **Not perceptually uniform** — equal distances ≠ equal perceived color differences
  - (later CIE spaces — CIELUV, CIELAB — fix this)
- **No luminance** — only hue + saturation
  - same xy at 1 nit and 1,000 nits → same point

</div>

</div>

<div class="pt-4 p-3 rounded border border-blue-500 bg-blue-500 bg-opacity-10">
This is why a color space needs <strong>more than a gamut</strong>:
the diagram tells you the boundary, but a <strong>transfer function</strong> tells you how light levels are encoded inside it.
</div>

---
class: text-sm
---

# Color Gamut

<div class="grid grid-cols-2 gap-6">

<div class="pt-2">

A **range of reproducible colors**, defined by:

1. Three **primaries** (R, G, B chromaticity coordinates)
2. A **white point**

The primaries form a triangle on the CIE diagram.

| Standard | Red primary (x,y) | Coverage |
|----------|-------------------|----------|
| BT.709   | (0.640, 0.330)    | HD/SDR baseline |
| DCI-P3   | (0.680, 0.320)    | Digital cinema |
| BT.2020  | (0.708, 0.292)    | UHD wide gamut |

</div>

<div class="pt-2">

### White point: what "neutral" means

- All broadcast standards: **D65** (x=0.3127, y=0.3290)
- DCI-P3 uses a slightly different white point (cinema convention)

### What a gamut does NOT tell you

- How colors **inside** the triangle are organized
- How **light levels** are encoded
- Which **math** converts between RGB and YCbCr

A gamut is just the boundary.

</div>

</div>

---
class: text-sm
---

# Color Model

A color model is the **structure of the numerical components** — without specifying which real-world colors those numbers map to.

<div class="grid grid-cols-3 gap-4 pt-3">

<div class="p-3 rounded border border-gray-500">

## RGB

Three channels: red, green, blue.

Purely abstract — works with **any** set of primaries.

</div>

<div class="p-3 rounded border border-gray-500">

## YCbCr

One luma (Y) + two chroma-difference channels (Cb, Cr).

Weights **depend on the primaries**.

</div>

<div class="p-3 rounded border border-gray-500">

## ICtCp

Intensity + blue-yellow (Ct) + red-green (Cp).

Perceptually uniform. Used in Dolby Vision.

</div>

</div>

<div class="pt-4 p-3 rounded border border-yellow-500 bg-yellow-500 bg-opacity-10">

⚠️ <strong>Same numbers, different colors.</strong>
<code>(255, 0, 0)</code> in BT.709, BT.2020, and Display P3 are <em>three different visible reds</em>.

</div>

<div class="pt-2 text-xs opacity-70">
Note: YCbCr and ICtCp are technically "families" — each tied to a specific color space because their matrices are derived from the primaries. RGB has no such dependency.
</div>

---
class: text-sm
---

# Color Space

A complete coordinate system that combines **three** components:

<div class="grid grid-cols-3 gap-4 pt-3">

<div class="p-3 rounded border border-gray-500">

### 1. Primaries

Chromaticity coordinates of R, G, B.

→ Defines the **gamut triangle**.

</div>

<div class="p-3 rounded border border-gray-500">

### 2. White point

Reference neutral.

→ Typically **D65**.

</div>

<div class="p-3 rounded border border-blue-500 bg-blue-500 bg-opacity-10">

### 3. Transfer function

Math that maps **code values ↔ light levels**.

→ This is where HDR happens.

</div>

</div>

<div class="pt-4 p-3 rounded border border-gray-500">

### Same gamut, different color space

HDR10 and HLG **both use BT.2020 primaries**.

But HDR10 uses **PQ** as its transfer function, HLG uses **Hybrid Log-Gamma**.

→ Fundamentally different color spaces, despite sharing the gamut.

</div>

---
class: text-sm
---

# Broadcast Recommendations (ITU-R)

Not just color spaces — full **system specifications**: gamut + transfer function + YCbCr matrix + quantization + bit depths.

<div class="pt-3">

| Recommendation | Gamut | Transfer Function | Typical Use |
|----------------|-------|-------------------|-------------|
| **BT.601**     | NTSC/PAL primaries | Gamma (~2.2) | SD television |
| **BT.709**     | BT.709 primaries | Gamma (~2.2) | HD television |
| **BT.2020**    | BT.2020 (wide) | SDR gamma curve | UHD **wide-gamut SDR** |
| **BT.2100**    | BT.2020 (inherited) | **PQ** or **HLG** | **HDR television** |

</div>

<div class="pt-4 p-3 rounded border border-orange-500 bg-orange-500 bg-opacity-10">

🔑 <strong>Critical nuance:</strong> BT.2020 on its own is a <em>wide-gamut SDR</em> spec.
BT.2100 is what defines HDR — it inherits BT.2020 primaries and replaces the transfer function with PQ or HLG.

When people say "HDR10 uses BT.2020," they really mean:
<em>BT.2020 primaries + PQ transfer function, as defined in BT.2100.</em>

</div>

---
layout: statement
---

# 2. Signal Plumbing

### Bit depth, matrices, signaling — the mechanics that make the signal decodable

---
class: text-sm
---

# YCbCr matrix coefficients

Luma is a weighted sum of R', G', B' components (primes = after transfer function):

$$Y = K_r R' + K_g G' + K_b B'$$

<div class="grid grid-cols-2 gap-6 pt-3">

<div>

| Standard | Kr | Kg | Kb |
|----------|------|------|------|
| **BT.709**     | 0.2126 | 0.7152 | 0.0722 |
| **BT.2020 NCL** | 0.2627 | 0.6780 | 0.0593 |

<div class="pt-3 text-xs opacity-70">
NCL = Non-Constant Luminance (used almost universally in practice).
</div>

</div>

<div>

### Why it matters

The differences look small. They're not.

Mix up the matrix at decode time → **saturated colors shift visibly**.

</div>

</div>

---
class: text-sm
---

# What happens if you use the wrong matrix

Saturated red pixel: <code>R'=0.9, G'=0.1, B'=0.1</code> — encoded with **BT.2020** matrix:

```
Y  = 0.2627·0.9 + 0.6780·0.1 + 0.0593·0.1 = 0.3101
Cb = (0.1 − 0.3101) / (2·0.9407) = −0.1117
Cr = (0.9 − 0.3101) / (2·0.7373) =  0.3998
```

Decoded with the wrong matrix (**BT.709**):

```
R' = 0.940   (expected 0.900 — +4%)
G' = 0.144   (expected 0.100 — +44%)
B' = 0.103   (expected 0.100 — +3%)
```

<div class="pt-3 p-3 rounded border border-red-500 bg-red-500 bg-opacity-10">

**Result on screen:** a deep saturated red becomes a noticeably warmer, **orange-shifted red**.
Worst on saturated tones; nearly invisible on neutral grays (where R'≈G'≈B').

</div>

<div class="pt-2 text-xs opacity-70">
This is why HEVC signals colour_primaries, transfer_characteristics, and matrix_coefficients <em>independently</em>.
</div>

---
class: text-sm
---

# Bit depth: why HDR needs ≥ 10 bits

<div class="grid grid-cols-2 gap-6 pt-3">

<div>

PQ maps code values across a luminance range of **0 → 10,000 nits**.

The PQ curve is tuned against the **Barten model** of human contrast sensitivity, so each quantization step is roughly **one just-noticeable difference (JND)** in luminance.

- **10 bits** (1,024 steps) → step size sits just below the visibility threshold across most of the curve.
- **8 bits** (256 steps) → steps in **dark regions** become visibly coarse → **banding**.

</div>

<div>

<div class="p-3 rounded border border-blue-500 bg-blue-500 bg-opacity-10">

### Key takeaway

10-bit is **not a preference** for HDR.

It's a **mathematical necessity** imposed by the luminance range and the Barten threshold.

</div>

<div class="pt-3 text-xs opacity-70">

12-bit (Dolby Vision) adds further headroom.

Going 10→12 bit is harmless math; going 12→10 or full→narrow is irreversibly lossy.

</div>

</div>

</div>

<div class="pt-2 text-xs opacity-50 text-center">
[ image placeholder: 8-bit vs 10-bit dark-gradient comparison showing banding ]
</div>

---
class: text-sm
---

# Narrow vs Full Range

<div class="grid grid-cols-2 gap-6 pt-3">

<div class="p-3 rounded border border-gray-500">

### Narrow range
"Limited range" / "TV range"

For 10-bit:
- **Luma**: 64 → 940
- **Chroma**: 64 → 960

Headroom and footroom for signal-processing overshoot/undershoot.

**Used by all professional broadcast & HDR10.**

</div>

<div class="p-3 rounded border border-gray-500">

### Full range
"PC range"

For 10-bit:
- **All channels**: 0 → 1023

No headroom — uses the entire code space.

Used in some closed pipelines (e.g. Dolby Vision Profile 5).

</div>

</div>

<div class="pt-4">

SDI interfaces (e.g. SMPTE 292M) <em>require</em> narrow range — code values 0–3 and 1020–1023 are reserved for timing references.

HDR10 in the wild is **virtually always narrow range**. Signaled via <code>video_full_range_flag</code> in the VUI.

</div>

---
class: text-sm
---

# HEVC VUI signaling — three independent axes

In every HEVC bitstream, the **VUI** (Video Usability Information) inside the SPS carries three integers:

<div class="pt-3">

| VUI parameter | What it specifies | HDR10 value |
|---------------|-------------------|-------------|
| `colour_primaries` | The **gamut triangle** | **9** (BT.2020) |
| `transfer_characteristics` | The **EOTF / transfer function** | **16** (PQ / ST 2084) |
| `matrix_coefficients` | The **YCbCr derivation math** | **9** (BT.2020 NCL) |

</div>

<div class="pt-4 p-3 rounded border border-orange-500 bg-orange-500 bg-opacity-10">

These are **three independent axes** with no redundancy. All three are needed to correctly decode the signal.

</div>

<div class="pt-2 text-xs opacity-70">

⚠️ <code>ffprobe</code> labels <code>matrix_coefficients</code> as <code>color_space</code> (e.g. <code>bt2020nc</code>) — misleading: it's just the YCbCr matrix, not the full color space.

</div>

---
layout: statement
---

# 3. The Transfer Function

### The piece that turns "wide-gamut SDR" into HDR

---
class: text-sm
---

# What is a transfer function?

<div class="grid grid-cols-2 gap-6 pt-3">

<div>

A mathematical function that maps between **encoded code values** and **actual light levels**.

- **OETF** (Opto-Electronic): scene light → code value (capture side)
- **EOTF** (Electro-Optical): code value → display light (display side)

Why we need it:
- The human visual system is **not linear** — we're far more sensitive to changes in shadows than in highlights.
- Encoding linearly would waste bits on highlights and starve shadows.

A transfer function **redistributes precision** to match perception.

</div>

<div class="flex items-center justify-center">

Comparativa Transfer Functions

</div>

</div>

---
class: text-sm
---

# SDR baseline — and its ceiling

<div class="grid grid-cols-2 gap-6 pt-3">

<div>

### Traditional SDR (BT.1886)

- Gamma curve ~**2.4**
- Assumes a **reference display peak ≈ 100 nits**
- Designed for CRTs originally; carried forward to LCD/OLED

That 100-nit assumption is the **ceiling of the SDR world**.

</div>

<div>

### What's outside the SDR ceiling?

| Scene | Real luminance |
|-------|----------------|
| Starlit night | ~0.001 nits |
| Indoor lighting | ~100 nits |
| Overcast sky | ~2,000 nits |
| Direct sunlight | ~100,000+ nits |
| Specular highlights | up to 10,000+ nits |

SDR's 100 nits captures a tiny slice of what the real world contains.

</div>

</div>

<div class="pt-2 text-xs opacity-50 text-center">
[ image placeholder: SDR vs HDR — same scene, clipped highlights vs preserved detail ]
</div>

---
layout: statement
---

# 4. Why HDR exists

### The problem and the three-ingredient solution

---
class: text-sm
---

# What HDR solves

<div class="grid grid-cols-3 gap-4 pt-4">

<div class="p-3 rounded border border-gray-500">

### More luminance range

SDR: ~0.1 → 100 nits (~10 stops)

Real world: ~0.001 → 100,000+ nits (~20 stops)

HDR: up to 10,000 nits (~17 stops)

</div>

<div class="p-3 rounded border border-gray-500">

### Wider color gamut

BT.709: ~36% of CIE 1931

DCI-P3: ~54%

BT.2020: ~76%

</div>

<div class="p-3 rounded border border-gray-500">

### More perceptual precision

Bit depth + perceptual encoding (PQ) → no visible banding even across a 10,000-nit range.

</div>

</div>

<div class="pt-4 text-center opacity-80">
HDR isn't <em>just</em> "brighter pictures."
It's a coordinated jump in <strong>range</strong>, <strong>gamut</strong>, and <strong>precision</strong>.
</div>

<div class="pt-2 text-xs opacity-50 text-center">
[ image placeholder: real-world high dynamic range scene — interior with bright window ]
</div>

---
class: text-sm
---

# The three ingredients of HDR

<div class="grid grid-cols-3 gap-4 pt-4">

<div class="p-3 rounded border border-blue-500 bg-blue-500 bg-opacity-10">

### 1. Transfer function

Defines the **representable luminance range**.

- BT.1886 (SDR): ~100 nits
- **PQ (ST 2084)**: absolute, up to 10,000 nits
- **HLG**: scene-referred, display-adaptive

The jump from SDR to HDR is fundamentally a change in transfer function.

</div>

<div class="p-3 rounded border border-blue-500 bg-blue-500 bg-opacity-10">

### 2. Bit depth

At least **10 bits**, required to avoid banding across PQ's range.

Dolby Vision can extend internally to **12 bits**.

</div>

<div class="p-3 rounded border border-blue-500 bg-blue-500 bg-opacity-10">

### 3. Metadata

Context for **intelligent display adaptation**.

Without it, a display only knows the theoretical max (10,000 nits) — and must guess how to map to its real capabilities.

</div>

</div>

<div class="pt-6 text-center opacity-80">
Take any one of these out and you don't have HDR — you have a broken pipeline.
</div>

---
layout: statement
---

# 5. How HDR solves it

### Transfer functions, bit depth, and metadata in detail

---
class: text-sm
---

# PQ — Perceptual Quantizer (ST 2084)

<div class="grid grid-cols-2 gap-6 pt-3">

<div>

### Display-referred, absolute

Code value N → **always M nits**, regardless of the display.

- Maps **0 → 10,000 nits**
- Designed against the **Barten model** of human contrast sensitivity
- Each 10-bit step ≈ one **JND** (just-noticeable difference)
- Defined in **SMPTE ST 2084** and incorporated into **BT.2100**

Used by **HDR10**, **HDR10+**, and **Dolby Vision** (most profiles).

</div>

<div class="flex items-center justify-center">

PQ Curve

</div>

</div>

---
class: text-sm
---

# HLG — Hybrid Log-Gamma

<div class="grid grid-cols-2 gap-6 pt-3">

<div>

### Scene-referred, display-adaptive

Code values map to **relative scene light**, not absolute nits.

The display renders at runtime based on its own peak brightness.

- Defined in **ARIB STD-B67** + **BT.2100**
- **Hybrid curve**: gamma (sqrt) in the lower range, log in the upper range
- **No metadata required**
- **Backward compatible** with SDR — an SDR display interpreting HLG as gamma produces a watchable image

</div>

<div>

### Why broadcasters love it

- One signal feeds **SDR and HDR receivers** simultaneously
- No mastering display metadata to track
- Fits the **live broadcast** chain (camera → switcher → uplink) without major changes
- Widely adopted in **UK, Japan**, parts of Europe

### Trade-off

- No absolute luminance control
- No per-scene tone mapping
- Rarely used for premium streaming or cinema

</div>

</div>

---
class: text-sm
---

# Why 10-bit (revisited, with the PQ curve)

<div class="grid grid-cols-2 gap-6 pt-3">

<div>

PQ stretches code values across a range **100× wider** than SDR.

If you tried to do that with 8 bits:
- 256 steps spread over 10,000 nits
- Step size in shadows would be **well above** the Barten JND threshold
- → **visible banding**, especially in dark regions

With 10 bits:
- 1,024 steps, each ≈ one JND
- Banding stays **just below visibility**

Dolby Vision internally targets 12 bits for additional headroom.

</div>

<div>

<div class="p-3 rounded border border-blue-500 bg-blue-500 bg-opacity-10">

### So:

**Wider luminance range** + **perceptual encoding** + **finer quantization**

are three faces of the same problem.

You can't get HDR with just one of them.

</div>

</div>

</div>

---
class: text-sm
---

# The metadata problem

The VUI tells you how to **decode** the signal — every pixel maps to a precise nit value. But then what?

<div class="grid grid-cols-2 gap-6 pt-3">

<div class="p-3 rounded border border-red-500 bg-red-500 bg-opacity-10">

### Without metadata

PQ can represent up to **10,000 nits**.
Your TV peaks at, say, **600 nits**.

The display has to decide:

- **Clip** everything above 600 nits? → destroys highlight detail
- **Compress** the entire range? → wastes contrast if content never reaches 10,000

It has to **guess**.

</div>

<div class="p-3 rounded border border-green-500 bg-green-500 bg-opacity-10">

### With metadata

The display knows:

- The **mastering display** the content was graded on (peak / min nits, primaries)
- The **content's actual brightness** (max pixel, max average frame)
- Optionally, **per-scene** light levels

Now it can tone-map intelligently from "what's actually there" → "what I can show."

</div>

</div>

---
class: text-sm
---

# Static metadata

<div class="grid grid-cols-2 gap-6 pt-3">

<div>

### SMPTE ST 2086 — Mastering Display Colour Volume

Describes the **display the content was graded on**:

- Peak luminance
- Minimum luminance
- Color primaries

→ A TV that knows content was mastered at 4,000 nits can tone-map from 4,000 down (not from 10,000 down).

</div>

<div>

### CTA-861.3 — Content Light Level

Describes the **content itself**:

- **MaxCLL** — brightest pixel in the entire stream
- **MaxFALL** — brightest average frame

⚠️ MaxFALL should be calculated over the **active image area only** — including letterbox bars artificially lowers it and causes over-aggressive highlight compression.

</div>

</div>

<div class="pt-4 p-3 rounded border border-orange-500 bg-orange-500 bg-opacity-10">

🔑 <strong>Limitation:</strong> one set of values for the entire stream.
A dark dialogue scene and a bright exterior receive the <em>same</em> tone-mapping guidance.

</div>

---
class: text-sm
---

# Dynamic metadata (the next step)

Static metadata forces a **single compromise** across the whole movie. Dynamic metadata changes the guidance **per scene** — or even **per frame**.

<div class="grid grid-cols-2 gap-6 pt-3">

<div class="p-3 rounded border border-gray-500">

### HDR10+

Royalty-free. SMPTE ST 2094-40.
Percentile-based luminance + Bezier curve anchors.

</div>

<div class="p-3 rounded border border-gray-500">

### Dolby Vision

Proprietary. RPU metadata per frame.
Polynomial mapping curves + per-scene color volume.

</div>

</div>

<div class="pt-4 p-3 rounded border border-blue-500 bg-blue-500 bg-opacity-10">

Both ride on top of an HDR10-compatible base layer.
A device that doesn't understand them falls back to standard HDR10.

We'll touch on these briefly in the next section — and Manu picks up the deeper analysis in Part 2.

</div>

---
class: text-sm
---

# HDR landscape — what to remember

<div class="pt-3">

| Format | Transfer | Gamut | Metadata | License |
|--------|----------|-------|----------|---------|
| **HDR10**       | PQ  | BT.2020 | Static (ST 2086 + CLL) | Open / royalty-free |
| **HDR10+**      | PQ  | BT.2020 | Dynamic (ST 2094-40) | Royalty-free* |
| **Dolby Vision**| PQ  | BT.2020 | Dynamic (RPU) | Licensed |
| **HLG**         | HLG | BT.2020 | None (scene-referred) | Open |

</div>

<div class="pt-4 grid grid-cols-2 gap-6">

<div>

### Common ground

- All use **BT.2020 primaries**
- All require **≥ 10 bits**
- All are defined under **BT.2100** (except HDR10 metadata add-ons)

</div>

<div>

### Where they diverge

- **Transfer function** (PQ vs HLG)
- **Metadata model** (none / static / dynamic)
- **Licensing & ecosystem** (broadcast vs streaming vs cinema)

</div>

</div>

<div class="pt-3 text-xs opacity-60">
* HDR10+ Technologies, LLC licensing program — no per-unit royalty.
</div>

---
layout: section
---

# 6. Recap & Handoff

---
class: text-sm
---

# Recap

<div class="grid grid-cols-2 gap-6 pt-3">

<div>

### Vocabulary

- **Gamut** = triangle of primaries on the CIE diagram
- **Model** = structure of the numbers (RGB / YCbCr / ICtCp)
- **Space** = primaries + white point + **transfer function**

### Signal plumbing

- HEVC VUI signals **3 independent axes**: primaries, transfer, matrix
- 10-bit is a mathematical floor, not a preference
- Narrow range is the broadcast default

</div>

<div>

### HDR = transfer + bit depth + metadata

- **Transfer function** redefines the luminance range
- **Bit depth** keeps the encoding visually smooth
- **Metadata** lets the display adapt to its real capabilities

### The format landscape

- **HDR10** — open baseline, static metadata
- **HDR10+ / Dolby Vision** — dynamic metadata on top
- **HLG** — scene-referred, broadcast-friendly

</div>

</div>
