#!/bin/bash
# Reload GTK 4 theme after colors change
# This ensures running GTK 4 apps pick up the new colors

# Force GTK 4 apps to reload CSS
# Note: Most GTK 4 apps need restart to fully apply, but this helps
pkill -HUP -f "gtk4" 2>/dev/null

echo "GTK 4 theme reload triggered"
