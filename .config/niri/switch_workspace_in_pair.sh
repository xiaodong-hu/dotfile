#!/usr/bin/env bash

set -euo pipefail

num="${1:-}"

case "$num" in
  1) main_ws="one"    ; ext_ws="eleven"    ;;
  2) main_ws="two"    ; ext_ws="twelve"    ;;
  3) main_ws="three"  ; ext_ws="thirteen"  ;;
  4) main_ws="four"   ; ext_ws="fourteen"  ;;
  5) main_ws="five"   ; ext_ws="fifteen"   ;;
  6) main_ws="six"    ; ext_ws="sixteen"   ;;
  7) main_ws="seven"  ; ext_ws="seventeen" ;;
  8) main_ws="eight"  ; ext_ws="eighteen"  ;;
  9) main_ws="nine"   ; ext_ws="nineteen"  ;;
  0) main_ws="ten"    ; ext_ws="twenty"    ;;
  *) exit 1 ;;
esac

main_output="eDP-1"

ext_output="$(
  niri msg outputs \
    | grep -oP 'Output .* \(\K[^\)]+' \
    | grep -vFx "$main_output" \
    | head -n 1
)"

# Always ensure the laptop workspace lives on eDP-1.
niri msg action move-workspace-to-monitor --reference "$main_ws" "$main_output" >/dev/null 2>&1 || true

# If an external monitor exists, ensure the paired workspace lives there.
if [[ -n "$ext_output" ]]; then
  niri msg action move-workspace-to-monitor --reference "$ext_ws" "$ext_output" >/dev/null 2>&1 || true

  # Show the laptop paired workspace, and leave final focus on laptop.
  niri msg action focus-workspace "$main_ws" >/dev/null 2>&1 || true
  # Show the external paired workspace.
  niri msg action focus-workspace "$ext_ws" >/dev/null 2>&1 || true
fi

# niri msg action focus-workspace "$main_ws" >/dev/null 2>&1 || true
