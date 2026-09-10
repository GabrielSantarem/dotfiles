# Fish Shell Config

![Shell](https://img.shields.io/badge/shell-fish-4CC2A6?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Status](https://img.shields.io/badge/status-customized-42be65?style=for-the-badge)
![Focus](https://img.shields.io/badge/focus-clean%20%26%20practical-0f1115?style=for-the-badge)

Short, modular Fish setup focused on a clean interactive workflow.

## What changed

- cleaned `config.fish`
- moved aliases into `conf.d/aliases.fish`
- added utility functions in `functions/`
- added safe `zellij` auto-attach
- disabled `starship` in favor of a native ultra-minimal Fish prompt
- reduced prompt UI to the bare minimum

## Key behavior

### Auto-start Zellij

On interactive local shells, Fish will run:

```fish
zellij attach -c main
```

It will **not** auto-attach when:

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
- `proj` → pick a project and open it in `hx .`
- `gitroot` → jump to current git root
- `hxhere` → open current directory in Helix
- `please` → rerun previous command with `sudo`

### Plain Fish without Zellij

```sh
env DISABLE_AUTO_ZELLIJ=1 fish
```

To force a plain shell without `zellij` auto-attach, use:

## Main files

- `fish/config.fish`
- `fish/conf.d/aliases.fish`
- `fish/functions/`

## Install / restore

```sh
mkdir -p ~/.config/fish
cp -r fish/* ~/.config/fish/
```
