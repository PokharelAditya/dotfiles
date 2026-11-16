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


def tint_color(base_h, base_s, base_l, source_h, source_s, tint_strength):
    """
    Tint a base color toward the source wallpaper color.

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

    source_h, source_s, _ = metadata["Dominant"]
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
            base_h, base_s, base_l, source_h, source_s, strength
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
