---
layout: intro-image-right
image: '/assets/part2/vq-image.avif'
---

# HDR Video
## Part II — HDR Video Quality Metrics

---
layout: statement-cover
image: '/assets/cinematic/cinematic-8.jpg'
---

# 1. The Limitations of Traditional Metrics

---

# Current Standard: VMAF

Key differences for VQ vs SDR:
- VMAF was originally trained and designed under the SDR 100-nit paradigm.
- Different EOTF (Electro-Optical Transfer Function):
    - HDR → PQ
    - SDR → Gamma
- Different color spaces where the same coordinates map to different colors:
    - HDR → BT.2020
    - SDR → BT.709

<div v-click class="mt-4 pt-4 p-3 rounded border border-orange-500 bg-orange-500 bg-opacity-10 text-center fw-700">
What are the consequences of these differences?
</div>

---

# Current Standard: Why Isn't It Enough?

- **Luma Encoding Error:** In HDR, a difference in luma value carries a fundamentally different physical meaning than in SDR.

- **Luminance Masking:** An extremely bright region (e.g. 1,000 nits) masks and hides compression noise in that area.

- **Color Blindness:** In HDR, the jump to the vast BT.2020 gamut makes color deviations caused by compression far more aggressive and perceptible.

- **The "Dilution" Problem:** Because most pixels in a video are midtones, a severe error in a bright highlight or deep black gets averaged with the rest of the frame and the error is "diluted" (also an SDR problem).

---
layout: center
---

# The Dilution Problem

<div class="flex items-center justify-center">

<img src="/assets/part2/dilution.png" />

</div>

---
layout: statement-cover
image: '/assets/cinematic/cinematic-9.jpg'
---

# 2. HDRMAX = 🩹 + VMAF

---
layout: image
image: '/assets/part2/hdrmax/hdrmax-1.svg'
---
---
layout: image
image: '/assets/part2/hdrmax/hdrmax-2.svg'
---
---
layout: image
image: '/assets/part2/hdrmax/hdrmax-3.svg'
---
---
layout: image
image: '/assets/part2/hdrmax/hdrmax-4.svg'
---
---
class: text-md
---

# Path A: Non-Linear Transformation

<div class="grid grid-cols-3 gap-4 pt-3">

<div class="p-3 rounded border border-gray-500">

### 1. Normalization

Each luma value (0 to 1024) is normalized to a range of [-1, 1].

</div>

<div class="p-3 rounded border border-gray-500">

### 2. Midtone Compression

Compresses the intermediate ranges that landed close to zero.

</div>

<div class="p-3 rounded border border-gray-500">

### 3. Extreme Expansion

While crushing the midrange, the curve simultaneously expands the brightness ranges at the extremes.

</div>

</div>

<div class="mt-4 pt-4 p-3 rounded border border-blue-500 bg-blue-500 bg-opacity-10">

### Consequence

The extremes are isolated at the cost of suppressing the midrange.

This forces VMAF to pay attention to visual artifacts in the brightest highlights and deepest blacks — because those are the only numerically large values that survived the transformation.


</div>

---
layout: image
image: '/assets/part2/hdrmax/hdrmax-5.svg'
---
---
layout: statement-cover
image: '/assets/cinematic/cinematic-10.jpg'
---

# 3. ColorVideoVDP

---
---
# ColorVideoVDP
<img src="/assets/part2/caja-negra-blanca.png" />

---
layout: image-right
image: '/assets/part2/cvvdp_input.jpeg'
---
# ColorVideoVDP
## Inputs

- Reference video
- Distorted video
- Display specs:
    - Screen resolution
    - Peak luminance
    - Black level
    - Viewing distance
    - Screen reflectivity
    - Ambient light

---
class: text-md
---

# ColorVideoVDP Steps

<div class="grid grid-cols-2 gap-4 pt-3">

<div v-click class="p-3 rounded border border-gray-500">

### 1. Light Physics

Performs a physical simulation that calculates the photons that will hit the viewer's eye, based on the display specs.

</div>

<div v-click class="p-3 rounded border border-gray-500">

### 2. Opponent Channels

Splits the image simulating the optic nerve: one signal for brightness (Luma) and two independent color signals derived from the physical simulation.

</div>

<div v-click class="p-3 rounded border border-gray-500">

### 3. Biological Filters

Applies spatiotemporal visual models to discard any error that occurs at speeds or sizes invisible to the human eye.

</div>

<div v-click class="p-3 rounded border border-gray-500">

### 4. Neural Network Model

A neural network reads the biological error maps and is trained to predict the score in JODs.

</div>
</div>

---
layout: center
---

# ColorVideoVDP
## Outputs
<img src="/assets/part2/cvvdp_output.png" width="700px" />

---
class: text-md
---

# The Score Is Not MOS — It's JOD
## Just Objectionable Difference

<div class="grid grid-cols-3 gap-12">

<div class="pt-2">

- A difference of exactly 1.0 JOD between Video A and Video B means **75% of humans will prefer Video A** because they find B visually worse.


- It is not an abstract mathematical unit — it is a unit of human probability.


- A perfect score is 10 (identical to the original).


</div>

<div class="flex items-center justify-center col-span-2">

<img src="/assets/part2/jod_psychometric_dark.png" />


</div>

</div>

---
layout: center
---
# The Score Is Not MOS — It's JOD

<div class="flex items-center justify-center">

<img src="/assets/part2/jod_linear_range_dark.png" width="80%" />

</div>


---
class: text-md
---

# SRCC Results
## Against the LIVE-HDR Dataset

<div class="grid grid-cols-3 gap-6">

<div class="pt-2">

SRCC measures whether the algorithm ranks videos (best to worst) exactly as a group of humans would; it rewards correct ranking, where 1.0 is perfect.


</div>

<div class="flex items-center justify-center col-span-2">

<img src="/assets/part2/srcc_dark.png" />


</div>

</div>

---
class: text-md
---
# Metrics Comparison

| Model | HDR Support | Shows Causality | Computational Complexity | Score Type | Per Frame Score |
|----------|-------------------|----------|----------|-------------------|----------|
| VMAF | ❌ | ❌ | Low | MOS | ✅ |
| HDRMAX | ✅ | ❌ | Medium | MOS | ❌ |
| ColorVideoVDP | ✅ | ✅ | High | JOD | ✅ |

---
layout: statement-cover
image: '/assets/cinematic/cinematic-6.jpg'
---

# 4. Hands-on

---
layout: end
---

# Thanks

Questions?
