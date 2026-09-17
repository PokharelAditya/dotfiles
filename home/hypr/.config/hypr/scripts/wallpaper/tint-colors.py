#!/usr/bin/env python3
"""
Generate wallpaper-tinted ANSI terminal colors.

Takes a source hex color (from wallpaper) and produces 16 ANSI colors
that maintain distinct hues (red looks red, green looks green) but are
tinted toward the wallpaper's dominant color.

Usage: ./tint-colors.py <source_hex> [tint_strength]
  source_hex:    Dominant wallpaper color, e.g. #a994ca
  tint_strength: 0.0 (no tint) to 1.0 (full tint), default 0.25

Output: JSON with color0-color15 hex values
"""

import sys
import json
import colorsys

# Base ANSI hues (HSL) - standard terminal colors with good readability
# Format: (hue 0-360, saturation 0-1, lightness 0-1)
BASE_COLORS = {
    # Normal (slightly muted, medium brightness)
    "color0":  {"h": 0,   "s": 0.00, "l": 0.10},  # black
    "color1":  {"h": 4,   "s": 0.72, "l": 0.62},  # red
    "color2":  {"h": 120, "s": 0.55, "l": 0.55},  # green
    "color3":  {"h": 40,  "s": 0.70, "l": 0.65},  # yellow
    "color4":  {"h": 220, "s": 0.65, "l": 0.60},  # blue
    "color5":  {"h": 280, "s": 0.50, "l": 0.60},  # magenta
    "color6":  {"h": 180, "s": 0.55, "l": 0.55},  # cyan
    "color7":  {"h": 0,   "s": 0.00, "l": 0.80},  # white

    # Bright (more saturated, higher brightness)
    "color8":  {"h": 0,   "s": 0.00, "l": 0.40},  # bright black
    "color9":  {"h": 4,   "s": 0.80, "l": 0.72},  # bright red
    "color10": {"h": 120, "s": 0.65, "l": 0.65},  # bright green
    "color11": {"h": 40,  "s": 0.80, "l": 0.75},  # bright yellow
    "color12": {"h": 220, "s": 0.75, "l": 0.72},  # bright blue
    "color13": {"h": 280, "s": 0.60, "l": 0.72},  # bright magenta
    "color14": {"h": 180, "s": 0.65, "l": 0.65},  # bright cyan
    "color15": {"h": 0,   "s": 0.00, "l": 0.95},  # bright white
}


def hex_to_hsl(hex_color):
    """Convert hex color to HSL."""
    hex_color = hex_color.lstrip("#")
    r, g, b = (int(hex_color[i:i+2], 16) / 255.0 for i in (0, 2, 4))
    h, l, s = colorsys.rgb_to_hls(r, g, b)
    return h * 360, s, l


def hsl_to_hex(h, s, l):
    """Convert HSL to hex color."""
    h = (h % 360) / 360.0
    r, g, b = colorsys.hls_to_rgb(h, l, s)
    return "#{:02x}{:02x}{:02x}".format(
        int(round(r * 255)),
        int(round(g * 255)),
        int(round(b * 255))
    )


def tint_color(base_h, base_s, base_l, source_h, source_s, tint_strength):
    """
    Tint a base ANSI color toward the source wallpaper color.

    - Hue is shifted toward source hue
    - Saturation is blended with source saturation
    - Lightness stays mostly unchanged (readability)
    """
    # Black and white - don't tint hue, just add subtle saturation
    if base_s == 0:
        # Add a tiny bit of the source hue to neutrals
        new_h = source_h
        new_s = source_s * tint_strength * 0.15  # very subtle
        new_l = base_l
        return new_h, new_s, new_l

    # Chromatic colors - shift hue toward source
    # Calculate shortest angular distance
    diff = source_h - base_h
    if diff > 180:
        diff -= 360
    elif diff < -180:
        diff += 360

    new_h = base_h + (diff * tint_strength)

    # Blend saturation slightly toward source
    new_s = base_s + (source_s - base_s) * tint_strength * 0.3

    # Keep lightness for readability
    new_l = base_l

    return new_h, new_s, new_l


def generate_tinted_colors(source_hex, tint_strength=0.25):
    """Generate all 16 tinted ANSI colors."""
    source_h, source_s, source_l = hex_to_hsl(source_hex)

    result = {}
    for name, base in BASE_COLORS.items():
        h, s, l = tint_color(
            base["h"], base["s"], base["l"],
            source_h, source_s,
            tint_strength
        )
        result[name] = hsl_to_hex(h, s, l)

    return result


def main():
    if len(sys.argv) < 2:
        print("Usage: tint-colors.py <source_hex> [tint_strength]", file=sys.stderr)
        print("  source_hex:    e.g. #a994ca", file=sys.stderr)
        print("  tint_strength: 0.0-1.0, default 0.25", file=sys.stderr)
        sys.exit(1)

    source_hex = sys.argv[1]
    tint_strength = float(sys.argv[2]) if len(sys.argv) > 2 else 0.25

    colors = generate_tinted_colors(source_hex, tint_strength)
    print(json.dumps(colors, indent=2))


if __name__ == "__main__":
    main()
