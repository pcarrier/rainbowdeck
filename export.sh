#!/bin/bash
set -ex

for f in "$@"; do
  inkscape --export-png="$(basename "$f" .svg).thumb.png" "$f" --export-dpi=10
  inkscape --export-png="$(basename "$f" .svg).png" "$f"
done
