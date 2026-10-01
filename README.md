# vt220-nerd-font

**VT220 Nerd Font** — a Nerd Fonts–patched build of
[Glass TTY VT220](https://github.com/svofski/glasstty) by Viacheslav Slavinsky,
rebuilt from the DEC VT220 ROM bitmap with the original CRT scanline/phosphor
render baked into every glyph.

This is the **Mono** variant: every text glyph is exactly one 500-unit cell
wide (strict grid licensing). Icons are scaled to **cap-height 650** (matching
A–Z) and left-anchored at 1-cell advance for clean icon-column alignment.

## Installation

Install **`build/VT220_NFM.ttf`** (the shipping artifact):

- **macOS**: double-click the TTF in `build/`, Font Book installs it.
- **Windows**: right-click the TTF → *Install for all users* (or copy to
  `C:\Windows\Fonts`).
- **Linux**: copy the TTF to `~/.local/share/fonts/` and run `fc-cache -fv`.

The family is **VT220 Nerd Font Mono** (PostScript `VT220NFM`). In most
apps:

- Terminal font pickers: select `VT220 Nerd Font Mono`.
- VS Code / JetBrains / Neovim: `VT220 Nerd Font Mono`.
- Recommended size on a 4K display: **~20 px** (the font was designed at
  a 10×20 bitmap grid with a 1/500 em-unit cell).

## What's patched in

Built with the official [Nerd Fonts font-patcher](https://github.com/ryanoasis/nerd-fonts)
v3.5.1, `--complete --makegroups 1` (full icon set:
Seti/nerd, Devicons, Box Drawing (160/160), Braille (256/256), Progress,
Powerline, Powerline Extra, Pomicons, Font Awesome, Power Symbols,
Codicons, Octicons, Material Design, Weather). The original 329 characters
(Cyrillic included) are present **with byte-identical outlines** — the scanline
effect is a property of the original glyph outlines and is untouched by the
patch.

*Icon post-processing*: after the patcher, Nerd glyphs (0xE000–0xF1AF) are
uniformly scaled to cap-height 650 and re-anchored to the baseline (y=50),
then left-anchored with a 1-cell (500) advance. This is what makes the
"strict mono" promise hold across both text and icons.

## Licensing

- **Base font**: public domain / [Unlicense](https://unlicense.org) —
  see `build/LICENSE`.
- **Icon subsets**: OFL 1.1 (NERD FONTS standard), glyph sources listed
  in `patches/`.

Both licenses permit modification, redistribution, and derivative works
with the usual attribution. Neither license requires you to fork or
upstream this portion in particular; this repository is a *fork* for
convenience and stability. A direct unlicensed build would also work
fine — you'd just be producing the same object twice.

## Reproducing

Two prerequisites (see `patches/build.sh`):

1. `fontforge` **with the Python bindings** (Debian:
   `apt install fontforge python3-fontforge`, v20230101+ tested).
2. A checkout of [`ryanoasis/nerd-fonts`](https://github.com/ryanoasis/nerd-fonts)
   at `v3.5.1` (provides the icon font + the `--complete` glyph inventory).

```sh
# inside a checkout of this repo
bash patches/build.sh
```

The script writes `build/VT220NerdFontMono-Regular.ttf`. Verified
(2026-09-30): 11,369 codepoints (0 lost from the original), all icon
advance widths = exactly 500, no zero-advance glyphs.

## Recommended downstream

If you want this in your terminal **as a thing** (Powerline, battery,
segment colors etc.), use a terminal that respects `NFM` advance
discipline and sets an icon font family — many editors default the
*primary* font to a propo that clips icons. If you are handy with the
`[font]` section of your `~/.config/`-shaped config, set **two** families
there: one for text, one for icons (both `VT220 Nerd Font` will work
directly), and you'll get the full matrix.
