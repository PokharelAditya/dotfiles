#!/bin/bash

# Wallpaper switcher script for mpvpaper with automatic theme generation
# Usage: ./apply.sh /path/to/wallpaper.mp4

if [ $# -eq 0 ]; then
    echo "Usage: $0 <path-to-wallpaper>"
    echo "Example: $0 ~/wallpapers/Videos/GTR-Silver.mp4"
    exit 1
fi

WALLPAPER="$1"
WALLPAPER_CACHE="$HOME/.config/hypr/.current_wallpaper"
FRAME_OUTPUT="/tmp/current_wallpaper.png"
TINTED_COLORS="/tmp/tinted_colors.json"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
NEEDS_REGEN=false

# Check if file exists
if [ ! -f "$WALLPAPER" ]; then
    echo "Error: File '$WALLPAPER' not found"
    notify-send -u critical --replace-id=5002 -a "Wallpaper" "Error" "Wallpaper file not found"
    exit 1
fi

# Check if wallpaper changed since last time
if [ -f "$WALLPAPER_CACHE" ]; then
    CACHED_WALLPAPER=$(cat "$WALLPAPER_CACHE")
    if [ "$CACHED_WALLPAPER" != "$WALLPAPER" ]; then
        NEEDS_REGEN=true
    fi
else
    NEEDS_REGEN=true
fi

# Extract frame and generate colors only if wallpaper changed
if [ "$NEEDS_REGEN" = true ]; then
    echo "New wallpaper detected, extracting frame..."
    ffmpeg -i "$WALLPAPER" -vframes 1 -q:v 2 "$FRAME_OUTPUT" -y 2>/dev/null
    
    if [ $? -ne 0 ]; then
        echo "Warning: Failed to extract frame, trying to copy as-is..."
        if ! cp "$WALLPAPER" "$FRAME_OUTPUT" 2>/dev/null; then
            notify-send -u critical --replace-id=5002 -a "Wallpaper" "Error" "Failed to process wallpaper file"
            exit 1
        fi
    fi
    
    # Generate colors with matugen
    if [ -f "$FRAME_OUTPUT" ]; then
        echo "Generating color theme..."

        # Get source color from matugen
        SOURCE_COLOR=$(matugen image "$FRAME_OUTPUT" --mode dark --source-color-index=0 --type scheme-expressive --json hex --dry-run 2>/dev/null \
            | python3 -c "import json,sys; print(json.load(sys.stdin)['colors']['source_color']['default']['color'])" 2>/dev/null)

        if [ -n "$SOURCE_COLOR" ]; then
            # Generate tinted ANSI colors
            echo "Tinting ANSI colors with source: $SOURCE_COLOR"
            python3 "$SCRIPT_DIR/tint-colors.py" "$SOURCE_COLOR" 0.32 > "$TINTED_COLORS"

            # Run matugen with tinted colors imported
            if ! matugen image "$FRAME_OUTPUT" --mode dark --source-color-index=0 --type scheme-expressive \
                --import-json "$TINTED_COLORS" 2>/dev/null; then
                notify-send -u critical --replace-id=5002 -a "Wallpaper" "Error" "Theme generation failed"
            fi
        else
            # Fallback: run matugen without tinting
            if ! matugen image "$FRAME_OUTPUT" --mode dark --source-color-index=0 --type scheme-expressive 2>/dev/null; then
                notify-send -u critical --replace-id=5002 -a "Wallpaper" "Error" "Theme generation failed"
            fi
        fi
    fi
    
    # Save current wallpaper path
    echo "$WALLPAPER" > "$WALLPAPER_CACHE"
else
    echo "Wallpaper unchanged, skipping theme regeneration"
fi

# Kill existing mpvpaper instances
killall mpvpaper 2>/dev/null

# Set wallpaper on all monitors
mpvpaper -o "no-audio loop-file=inf panscan=1.0 hwdec=auto input-ipc-server=/tmp/mpv-socket" all "$WALLPAPER" &

echo "Wallpaper set to: $WALLPAPER"
