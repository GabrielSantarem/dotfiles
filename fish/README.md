# Fish Shell Config

![Shell](https://img.shields.io/badge/shell-fish-4CC2A6?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Status](https://img.shields.io/badge/status-customized-42be65?style=for-the-badge)
![Focus](https://img.shields.io/badge/focus-clean%20%26%20practical-0f1115?style=for-the-badge)

Short, modular Fish setup focused on a clean interactive workflow.

## What changed

- cleaned `config.fish`
- moved aliases into `conf.d/aliases.fish`
- added utility functions in `functions/`
- clean `zellij` auto-start with opt-in automation
- disabled `starship` in favor of a native ultra-minimal Fish prompt
- reduced prompt UI to the bare minimum

## Key behavior

### Auto-start Zellij

On interactive local shells, Fish runs:

```fish
zellij --new-session-with-layout default
```

Every terminal starts a **fresh session with a clean shell**. No old context is restored automatically; if a terminal closed by accident, recover its still-live session with `zellij list-sessions` + `zellij attach <name>`.

### Opt-in automation variables

- `ENABLE_AUTO_PROJ=1` (or `AUTO_PROJ=1`): Start Zellij directly with the `proj` project picker layout (`zellij --new-session-with-layout proj`).
- `ENABLE_AUTO_HX=1` (or `AUTO_HX=1`): Automatically launch Helix (`hx .`) when picking a project in `proj`.

### Zellij auto-start bypass

It will **not** auto-start when:

- already inside `zellij`
- running over SSH
- shell is non-interactive
- `TERM=dumb`
- `fish_private_mode` is set
- `DISABLE_AUTO_ZELLIJ=1` is set

## Useful aliases

### Navigation / listing

- `ls` → `eza --icons --group-directories-first`
- `ll` → long listing with git info
- `la`, `lt`, `tree`

### Git

- `g`, `gs`, `ga`, `gc`, `gca`
- `gco`, `gb`, `gl`, `gd`, `gdc`
- `gp`, `gpl`

### Dev tools

- `c`, `cb`, `cbr`, `cc`, `ct`, `cr`, `ccl`
- `ni`, `nr`
- `py`, `venv`

## Prompt

A native Fish prompt is included and intentionally replaces `starship` for a much cleaner interface.

### Visual cues

- green `›` prompt marker
- red `!` only when the previous command failed
- no right prompt
- no mode prompt

Prompt files:

- `fish/functions/fish_prompt.fish`
- `fish/functions/fish_right_prompt.fish`
- `fish/functions/fish_mode_prompt.fish`
- `fish/functions/fish_greeting.fish`

## Useful functions

- `reloadfish` → reload shell config
- `hxconf` → open Helix config
- `fishconf` → open Fish config
- `mkcd` → create dir and enter it
- `ff` → fuzzy file finder with preview
- `fcd` → fuzzy directory jump with preview
- `proj` → pick a project; inside `zellij` opens a new tab in the project folder with a clean shell; outside it `cd`s to it.
  - set `ENABLE_AUTO_HX=1` (or `AUTO_HX=1` or run `proj --hx`) to open the project in a dedicated full-tab `hx .`
- `gitroot` → jump to current git root
- `hxhere` → open current directory in Helix
- `please` → rerun previous command with `sudo`

### Plain Fish without Zellij

To force a plain shell without `zellij` auto-attach, use:

```sh
env DISABLE_AUTO_ZELLIJ=1 fish
```

## Main files

- `fish/config.fish`
- `fish/conf.d/aliases.fish`
- `fish/functions/`

## Install / restore

```sh
mkdir -p ~/.config/fish
cp -r fish/* ~/.config/fish/
```
