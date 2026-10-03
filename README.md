# Dotfiles

![Repo](https://img.shields.io/badge/repo-dotfiles-0f1115?style=for-the-badge)
![Editor](https://img.shields.io/badge/editor-helix-5e81ac?style=for-the-badge)
![Shell](https://img.shields.io/badge/shell-fish-4cc2a6?style=for-the-badge)
![Multiplexer](https://img.shields.io/badge/multiplexer-zellij-84a0c6?style=for-the-badge)
![Terminal](https://img.shields.io/badge/terminal-alacritty-f2cdcd?style=for-the-badge)
![Style](https://img.shields.io/badge/style-minimal%20%26%20portable-1f2428?style=for-the-badge)

Personal dotfiles repository for a clean terminal-centric workflow built around `Helix`, `Fish`, `Zellij`, and `Alacritty`.

The goal is to keep everything:

- minimal
- portable
- easy to validate
- easy to install
- easy to version and back up

## Included configs

- `helix/`
- `fish/`
- `zellij/`
- `alacritty/`
- `scripts/`

## Component documentation

Each tool has its own focused README:

- [`helix/README.md`](helix/README.md) — editor config, themes, language tooling, keymaps
- [`fish/README.md`](fish/README.md) — shell behavior, prompt, aliases, functions, auto-attach notes
- [`zellij/README.md`](zellij/README.md) — layout, mode flow, keybind strategy, minimal UI choices
- [`alacritty/README.md`](alacritty/README.md) — terminal appearance, font, padding, and shortcuts

## Repository layout

```text
.
├── alacritty/
├── fish/
├── helix/
├── scripts/
└── zellij/
```

## Scripts

### Install into `~/.config`

```sh
bash scripts/install.sh
```

Useful options:

```sh
bash scripts/install.sh --dry-run
bash scripts/install.sh --no-backup
bash scripts/install.sh --link
```

### Sync local config back into the repo

```sh
bash scripts/sync-from-config.sh
bash scripts/sync-from-config.sh --dry-run
```

### Validate the repo and local environment

```sh
bash scripts/doctor.sh
```

## Workflow

Typical flow:

1. edit configs inside this repository
2. install or link them into `~/.config`
3. validate with `bash scripts/doctor.sh`
4. commit and push changes

## Notes

- Existing configs are backed up by default to `~/.local/state/dotfiles/backups/`.
- `--link` is useful if you want this repository to become the live source of truth.
- The repository is intentionally organized as one place for shell, terminal, multiplexer, and editor configuration.
- Copies stored here should remain free of nested `.git` directories.

## Next ideas

Possible future improvements:

- `scripts/diff.sh` for repo ↔ local config comparisons
- `scripts/bootstrap.sh` for dependency checks and first-time setup
- per-component install flags like `--only fish` or `--only helix`
- screenshots or GIF previews for themes and UI choices
