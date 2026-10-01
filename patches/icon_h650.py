"""Final NFM build — icons at cap-height 650, strict 1-cell (500) advance.
Replaces the repo build/VT220NerdFontMono-Regular.ttf with VT220_NFM.ttf.

Usage:
  python3 icon_h650.py <patcher-MonOSets-VT220NerdFontMono-Regular.ttf> <out_ttf>
"""
import sys
from fontTools.ttLib import TTFont
from fontTools.ttLib.tables._g_l_y_f import GlyphCoordinates

CELL = 500
TARGET_H = 650.0
BAND_LO, BAND_HI = 0xE000, 0xF1AFF
IN, OUT = sys.argv[1], sys.argv[2]

f = TTFont(IN); cmap = f.getBestCmap(); glyf = f["glyf"]; hmtx = f["hmtx"]
one = 0
for cp, gn in cmap.items():
    if not (BAND_LO <= cp <= BAND_HI): continue
    g = glyf[gn]
    if g.numberOfContours == 0 or g.isComposite(): continue
    coords = list(g.coordinates)
    if not coords: continue
    xs = [p[0] for p in coords]; ys = [p[1] for p in coords]
    x0, x1, y0, y1 = min(xs), max(xs), min(ys), max(ys)
    w = x1 - x0; h = y1 - y0
    if h <= 0 or w <= 0: continue
    s = min(TARGET_H / h, CELL / w)
    g.coordinates = GlyphCoordinates([(round((x - x0) * s), round((y - y0) * s + 50.0)) for (x, y) in coords])
    neww = w * s
    lsb = max(0, round((CELL - neww) / 2))
    hmtx.metrics[gn] = (CELL, lsb)
    one += 1

# Update the internal family name to VT220 NFM
name = f["name"]
for rec in name.names:
    if rec.nameID in (1, 2, 4, 6):
        pass  # keep existing family style — family already reads "VT220 Nerd Font Mono"
f.recalcBBoxes = True
f.save(OUT)
print({"built": f"{one} icons at cap-height 650, 1-cell 500 advance", "out": OUT})
