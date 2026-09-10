# Alacritty Config

![Terminal](https://img.shields.io/badge/terminal-alacritty-e05f2c?style=for-the-badge&logo=alacritty&logoColor=white)
![Theme](https://img.shields.io/badge/theme-dark%20green-42be65?style=for-the-badge)
![Style](https://img.shields.io/badge/style-clean%20%26%20sharp-0f1115?style=for-the-badge)

Alacritty theme and UX tuned to match the Helix + Zellij setup.

## What changed

- darker background and stronger contrast
- green accents for cursor, selection and search
- less pastel ANSI palette
- tighter padding and fully opaque window
- clipboard and font-size shortcuts enabled

## Main file

- `alacritty/alacritty.toml`

## Visual choices

- background: `#0f1115`
- foreground: `#d7dce2`
- green accents: `#42be65` / `#78dba9`
- opacity: `1.0`
- padding: `6x6`

## Font

Configured font family:

- `FiraCode Nerd Font`

If this exact font name is not available on your system, replace it in `alacritty.toml` with the installed family name.

## Key shortcuts

- `Ctrl-Shift-C` → copy
- `Ctrl-Shift-V` → paste
- `Ctrl-Shift-N` → new window
- `Ctrl-+` → increase font size
- `Ctrl--` → decrease font size
- `Ctrl-0` → reset font size

## Notes

- Alacritty does **not** provide native tabs.
- For tabs/splits/sessions, use `zellij`.

## Install / restore

```sh
mkdir -p ~/.config/alacritty
cp alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
```
