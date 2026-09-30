#!/usr/bin/env bash
# Reproduce VT220 Nerd Font (Mono) with the official Nerd Fonts font-patcher.
#
# Prerequisites:
#   1) fontforge with Python bindings   (Debian 12: apt install fontforge python3-fontforge)
#   2) A checkout of ryanoasis/nerd-fonts (>= v3.5.1) passed as $1
#      (unpatched repo, must include src/glyphs/ with the icon subset fonts)
#   3) Optional: uv on PATH, only needed if the source TTF is missing OS/2.sCapHeight
#      (the one checked in under build/ already has it fixed)
#
# Usage:  bash patches/build.sh /path/to/nerd-fonts-checkout
# Output: build/VT220NerdFontMono-Regular.ttf

set -euo pipefail
: "${1:?Usage: bash patches/build.sh /path/to/nerd-fonts-checkout}"

HERE="$(cd "$(dirname "$0")/.." && pwd)"
NF="$1"

[ -f "$NF/font-patcher" ] || { echo "no font-patcher at $NF"; exit 1; }
[ -d "$NF/src/glyphs" ]    || { echo "no src/glyphs at $NF (expected in nerd-fonts repo)"; exit 1; }
command -v fontforge >/dev/null || { echo "fontforge not found in PATH"; exit 1; }

WORK="$HERE/work/Glass_TTY_VT220.ttf"
mkdir -p "$(dirname "$WORK")" "$HERE/build"
cp -f "$HERE/build/Glass_TTY_VT220_original.ttf" "$WORK"

# The mono/propo icon path in the patcher sizes icons relative to the source
# font's sCapHeight. A 2009 fontforge-era TTF may not carry that field, in
# which case every icon glyph collapses to zero height and gets silently
# dropped. Backfill from the measured value (700 = A-Z yMax, 500 = x set)
# when fontTools is reachable.
if command -v uv >/dev/null 2>&1; then
    uv run --quiet --with fonttools python - "$WORK" <<'PYEOF'
import sys
from fontTools.ttLib import TTFont
p = sys.argv[1]
f = TTFont(p)
o = f['OS/2']
had_cap = getattr(o, 'sCapHeight', None)
if not had_cap:
    if o.version < 1:
        o.version = 1
        o.panose = [2, 0, 5, 0, 0, 0, 0, 0, 0, 0]
    o.sCapHeight = 700
    o.sxHeight   = 500
    f.save(p)
    print('OS/2 caps fixed (sCapHeight=700, sxHeight=500)')
else:
    print('OS/2 caps already present')
PYEOF
else
    echo "uv not found; patching without the OS/2 backfill"
fi

# --complete: all icon sets
# --makegroups 1: family = <base> Nerd Font <variant>
# -q: quiet
# -s: single cell width (the Mono variant)
# -c: reproducible (no randomness)
fontforge -quiet -script "$NF/font-patcher" --debug 1 --complete --no-progressbars \
    --makegroups 1 \
    "$WORK" -q -s -c \
    --outputdir "$HERE/build" 2>/dev/null

ls -l "$HERE/build/VT220NerdFontMono-Regular.ttf"
echo "done."
