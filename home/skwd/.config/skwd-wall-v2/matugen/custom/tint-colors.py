#!/usr/bin/env python3
"""
Tint selected colors in an annotated theme file.

Theme annotations:
  #Dominant #76d7c7
  #TintBy 0.32
  #Tint color1 #cc0403

#Dominant sets the wallpaper source color; #TintBy sets strength from 0 to 1.
#Tint marks a setting to uncomment and tint.

Usage: ./tint-colors.py Matugen.conf [output.conf]
  Default output: Matugen.tinted.conf, alongside the input file.
  Only #Tint settings are changed; other lines and metadata are preserved.
  The input file is never overwritten.
"""

import argparse
import colorsys
import math
import re
from pathlib import Path

HEX_COLOR_RE = re.compile(r"#?[0-9a-fA-F]{6}")
METADATA_RE = re.compile(r"[ \t]*#(Dominant|TintBy)\b[ \t]*(.*)")
TINT_MARKER_RE = re.compile(r"[ \t]*#Tint\b")
TINT_SETTING_RE = re.compile(
    r"(?P<indent>[ \t]*)#Tint[ \t]+"
    r"(?P<setting>[^ \t#]+)(?P<spacing>[ \t]+)"
    r"(?P<color>#[0-9a-fA-F]{6})(?P<suffix>[ \t]*(?:#.*)?)"
)


def hex_to_hsl(hex_color):
    """Convert hex color to HSL."""
    if not HEX_COLOR_RE.fullmatch(hex_color):
        raise ValueError("expected a six-digit hex color, e.g. #a994ca")
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


def _rgb_to_oklab(rgb):
    """Convert sRGB to perceptual lightness and color axes."""
    r, g, b = (
        c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4
        for c in rgb
    )
    l = (0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b) ** (1 / 3)
    m = (0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b) ** (1 / 3)
    s = (0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b) ** (1 / 3)
    return (
        0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s,
        1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s,
        0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s,
    )


def _oklab_to_linear_rgb(lightness, a, b):
    """Convert OKLab to linear RGB, which may be outside the display gamut."""
    l = (lightness + 0.3963377774 * a + 0.2158037573 * b) ** 3
    m = (lightness - 0.1055613458 * a - 0.0638541728 * b) ** 3
    s = (lightness - 0.0894841775 * a - 1.2914855480 * b) ** 3
    return (
        4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
        -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
        -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s,
    )


def _oklab_to_hsl(lightness, a, b):
    """Fit a perceptual color into sRGB without clipping its hue or brightness."""
    rgb = _oklab_to_linear_rgb(lightness, a, b)
    if not all(0.0 <= c <= 1.0 for c in rgb):
        # Reduce only color intensity until the color fits the display gamut.
        low, high = 0.0, 1.0
        for _ in range(24):
            scale = (low + high) / 2
            candidate = _oklab_to_linear_rgb(lightness, a * scale, b * scale)
            if all(0.0 <= c <= 1.0 for c in candidate):
                low = scale
            else:
                high = scale
        rgb = _oklab_to_linear_rgb(lightness, a * low, b * low)

    rgb = tuple(
        12.92 * max(0.0, c)
        if c <= 0.0031308
        else min(1.0, 1.055 * c ** (1 / 2.4) - 0.055)
        for c in rgb
    )
    h, l, s = colorsys.rgb_to_hls(*rgb)
    return h * 360, s, l


def tint_color(base_h, base_s, base_l, source_h, source_s, source_l, tint_strength):
    """Blend colors toward the wallpaper while keeping ANSI hues distinguishable."""
    if tint_strength == 0 or base_l in (0, 1):
        return base_h, base_s, base_l

    amount = tint_strength * (2 - tint_strength)
    lightness, a, b = _rgb_to_oklab(
        colorsys.hls_to_rgb((base_h % 360) / 360, base_l, base_s)
    )
    source_lightness, source_a, source_b = _rgb_to_oklab(
        colorsys.hls_to_rgb((source_h % 360) / 360, source_l, source_s)
    )
    chroma = math.hypot(a, b)
    source_chroma = math.hypot(source_a, source_b)
    source_hue = math.atan2(source_b, source_a)

    if chroma < 0.02:
        target_chroma = min(0.018, source_chroma * 0.2)
        a = a * (1 - amount) + math.cos(source_hue) * target_chroma * amount
        b = b * (1 - amount) + math.sin(source_hue) * target_chroma * amount
    else:
        hue = math.atan2(b, a)
        diff = (source_hue - hue + math.pi) % (2 * math.pi) - math.pi
        # Allow enough rotation so colors genuinely lean toward the wallpaper,
        # but cap it so the six ANSI hues never collapse into one.
        limit = math.radians(40)
        influence = min(1.0, source_chroma / 0.04)
        hue += max(-limit, min(limit, diff * 0.6)) * amount * influence

        # Blend chroma toward the wallpaper's own intensity.
        target_chroma = source_chroma * 0.7 + chroma * 0.3
        target_chroma = min(target_chroma, 0.16)
        chroma += (target_chroma - chroma) * amount * 0.6

        # Pull lightness gently toward the wallpaper's neighbourhood.
        target_lightness = source_lightness * 0.35 + 0.65 * min(
            0.82, 0.70 + (lightness - 0.70) * 0.5
        )
        lightness += (target_lightness - lightness) * amount * 0.5
        a, b = math.cos(hue) * chroma, math.sin(hue) * chroma

    return _oklab_to_hsl(lightness, a, b)


def parse_tint_strength(value):
    """Require a finite tint strength between zero and one, inclusive."""
    try:
        strength = float(value)
    except ValueError:
        raise ValueError("tint strength must be a number between 0 and 1") from None
    if not 0.0 <= strength <= 1.0:
        raise ValueError("tint strength must be a number between 0 and 1")
    return strength


def tint_theme(text):
    """Replace #Tint settings using the theme's #Dominant and #TintBy."""
    lines = text.splitlines(keepends=True)
    metadata = {}

    # Read directives first so they can appear anywhere in the file.
    for number, line in enumerate(lines, start=1):
        match = METADATA_RE.fullmatch(line.rstrip("\r\n"))
        if not match:
            continue
        name, value = match.groups()
        if name in metadata:
            raise ValueError(f"line {number}: duplicate #{name} directive")
        try:
            if name == "Dominant":
                metadata[name] = hex_to_hsl(value.strip())
            else:
                metadata[name] = parse_tint_strength(value.strip())
        except ValueError as error:
            raise ValueError(f"line {number}: #{name}: {error}") from error

    missing = [f"#{name}" for name in ("Dominant", "TintBy") if name not in metadata]
    if missing:
        raise ValueError("missing required directives: " + ", ".join(missing))

    source_h, source_s, source_l = metadata["Dominant"]
    strength = metadata["TintBy"]
    result = []
    for number, line in enumerate(lines, start=1):
        content = line.rstrip("\r\n")
        if not TINT_MARKER_RE.match(content):
            result.append(line)
            continue

        match = TINT_SETTING_RE.fullmatch(content)
        if not match:
            raise ValueError(f"line {number}: expected '#Tint <setting> #RRGGBB'")

        base_h, base_s, base_l = hex_to_hsl(match["color"])
        tinted = hsl_to_hex(*tint_color(
            base_h, base_s, base_l, source_h, source_s, source_l, strength
        ))
        ending = line[len(content):]
        result.append(
            match["indent"] + match["setting"] + match["spacing"]
            + tinted + match["suffix"] + ending
        )

    return "".join(result)


def tint_theme_file(input_path, output_path):
    """Validate and tint a theme before writing a separate output file."""
    if input_path.resolve() == output_path.resolve() or (
        output_path.exists() and input_path.samefile(output_path)
    ):
        raise ValueError("input and output must be different files")

    with input_path.open(encoding="utf-8", newline="") as source:
        result = tint_theme(source.read())
    with output_path.open("w", encoding="utf-8", newline="") as output:
        output.write(result)


def main():
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("input", type=Path, help="annotated theme file")
    parser.add_argument(
        "output", type=Path, nargs="?",
        help="output file (default: add .tinted before the input file's extension)",
    )
    args = parser.parse_args()

    try:
        input_path = args.input.expanduser()
        if args.output is None:
            output_path = input_path.with_name(
                f"{input_path.stem}.tinted{input_path.suffix}"
            )
        else:
            output_path = args.output.expanduser()
        tint_theme_file(input_path, output_path)
        print(f"Wrote {output_path}")
    except (OSError, ValueError) as error:
        parser.error(str(error))


if __name__ == "__main__":
    main()
