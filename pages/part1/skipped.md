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

<div class="mt-4 pt-4 p-3 rounded border border-orange-500 bg-orange-500 bg-opacity-10">

🔑 <strong>Critical nuance:</strong> BT.2020 on its own is a <em>wide-gamut SDR</em> spec.
BT.2100 is what defines HDR — it inherits BT.2020 primaries and replaces the transfer function with PQ or HLG.

When people say "HDR10 uses BT.2020," they really mean:
<em>BT.2020 primaries + PQ transfer function, as defined in BT.2100.</em>

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