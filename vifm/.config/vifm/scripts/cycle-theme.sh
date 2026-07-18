#!/bin/bash
# Cycle vifm colorscheme: dracula -> gruvbox -> solarized -> dracula

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/vifm"
STATE_FILE="$CACHE_DIR/theme_cycle"
mkdir -p "$CACHE_DIR"

if [ ! -f "$STATE_FILE" ]; then
  CURRENT="gruvbox"
else
  CURRENT=$(cat "$STATE_FILE")
fi

case "$CURRENT" in
  dracula)  NEXT="gruvbox"    ;;
  gruvbox)  NEXT="solarized"  ;;
  solarized) NEXT="dracula"   ;;
  *)        NEXT="dracula"    ;;
esac

printf "%s" "$NEXT"
printf "%s" "$NEXT" > "$STATE_FILE"
