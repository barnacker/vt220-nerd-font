#!/bin/bash
# Rebuilds VT220_NFM.ttf — the final deliverable: Nerd Fonts-patched Glass TTY VT220,
# icon band scaled to cap-height 650, strict 1-cell advance, left-anchored.
#
# Inputs:  Glass_TTY_VT220_original.ttf  (in this directory, public domain)
# Output:  VT220_NFM.ttf
#
# Usage:  bash icon_h650.sh <patcher_out_dir> /root/.hermes/cache/scratch/glass-nerd/build/MONOSets
#         (run the patcher first — see README)

set -e
PATCH_OUT_DIR="${1:?need the patcher output directory}"
OUT=VT220_NFM.ttf
ICON_H=650.0
CELL=500

python3 "icon_h${ICON_H/./}.py" "$PATCH_OUT_DIR/VT220NerdFontMono-Regular.ttf" "$OUT"

# Rename to canonical VT220NFM
echo "Built: $OUT"
