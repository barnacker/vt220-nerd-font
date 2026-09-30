# Upstream

- Author: **Viacheslav Slavinsky** (svofski)
- Original font: [Glass TTY VT220](https://github.com/svofski/glasstty)
  (public domain / Unlicense, see `LICENSE`)
- Web page: <https://caglrc.cc/glasstty>
- Released: 2009

## What this fork does

- Passes the original TTF through the
  [Nerd Fonts font-patcher](https://github.com/ryanoasis/nerd-fonts)
  (`--complete --makegroups 1 -s`) to add the full Nerd icon set
  (single-cell / mono variant).
- Sets `OS/2.sCapHeight=700 sXHeight=500` (measured from the original A–Z)
  so the patcher's mono icon-height calculation does not scale icons to
  zero (fontforge 2023 drops these fields on export of pre-FFTM-era fonts).
- No changes to the original glyph outlines; link line-height and hint
  tables are only touched by the font-patcher. All original codepoints are
  retained.

## Nerd Fonts license note

The Nerd Fonts project (ryanoasis/nerd-fonts) is MIT-licensed *code*; the
glyph sources it merges in are OFL-1.1 (nerd-fonts root `LICENSE`). This fork
ships *only* a patched TTF output plus a build script — no Nerd Fonts source
code, no icon-font binaries. If you'd like the output treated as a
contribution back to the main repo, open an issue over there; this fork
exists so the build is stable and self-contained.

## License of this fork

See `LICENSE` (Unlicense) — mirrors the upstream base font so that
redistribution of the patched object does not require reading two
different licenses.
