#!/usr/bin/env python3
"""
JOD → Human Preference Calculator

Converts a JOD score (quality of a distorted clip vs. a perfect reference)
into the percentage of humans that would prefer the original (reference)
over the distorted clip.

Formula:
    P(ref ≻ test) = Φ( ΔJOD / (σ√2) )

Where:
    ΔJOD  = JOD_ref − JOD_test  = 10 − JOD_test
    Φ     = CDF of the standard normal distribution
    σ     ≈ 1.4826  (maps 1 JOD → 75 % preference)
"""

import argparse
import math


SIGMA = 1.4826  # observer model std-dev


def phi(x: float) -> float:
    """Standard normal CDF (no scipy needed)."""
    return 0.5 * (1.0 + math.erf(x / math.sqrt(2.0)))


def jod_to_preference(jod_test: float) -> float:
    """Return P(ref ≻ test) as a percentage [0-100]. Reference is always 10."""
    delta = 10.0 - jod_test
    return phi(delta / (SIGMA * math.sqrt(2.0))) * 100.0


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Convert JOD score(s) to human preference percentage (reference = 10)."
    )
    parser.add_argument(
        "jod",
        type=float,
        nargs="+",
        help="One or more JOD scores of distorted clips.",
    )
    args = parser.parse_args()

    print(f"{'JOD':>8}  {'ΔJOD':>8}  {'P(ref ≻ test)':>15}")
    print("-" * 35)
    for jod in args.jod:
        delta = 10.0 - jod
        pref = jod_to_preference(jod)
        print(f"{jod:8.2f}  {delta:8.2f}  {pref:14.1f}%")


if __name__ == "__main__":
    main()
