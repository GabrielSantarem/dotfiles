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
- system-agnostic (powered by `mise`)
- portable
- easy to validate (`doctor.sh`)
- easy to install and bootstrap (`bootstrap.sh`, `install.sh`)
- easy to version and back up

## Included configs

- `helix/` — editor settings, themes, and language server definitions
- `fish/` — interactive shell, aliases, prompt, and media manipulation helpers
- `zellij/` — multiplexer layouts, discrete UI, and keybinds
- `alacritty/` — GPU-accelerated terminal appearance and fonts
- `scripts/` — bootstrap, installation, sync, and health check scripts
- `mise.toml` — universal tool definitions (userland, system-agnostic)

## Component documentation

Each tool has its own focused README:

- [`helix/README.md`](helix/README.md) — editor config, themes, language tooling, Deno LSP, Phpactor, Ruby LSP
- [`fish/README.md`](fish/README.md) — shell behavior, prompt, aliases, functions, media helpers (`vconv`, `vgif`, etc.)
- [`zellij/README.md`](zellij/README.md) — layout, mode flow, keybind strategy, discrete UI
- [`alacritty/README.md`](alacritty/README.md) — terminal appearance, font, padding, and shortcuts

## Repository layout

```text
.
├── alacritty/
├── fish/
├── helix/
├── mise.toml
├── scripts/
│   ├── bootstrap.sh
│   ├── doctor.sh
│   ├── install.sh
│   └── sync-from-config.sh
└── zellij/
```

## Quick Start / First-Time Setup

On any new machine (Fedora, Debian/Ubuntu, Arch, macOS):

```sh
# Clone and run the system-agnostic bootstrapper
git clone ssh://git@codeberg.org/MrTomate/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash scripts/bootstrap.sh
```

The bootstrapper automatically:
1. Detects or installs `mise` (Universal Tool Manager).
2. Installs OS-level libraries (`alacritty`, `fish`, `ffmpeg`, `imagemagick`).
3. Installs userland tools via `mise` (`helix`, `zellij`, `eza`, `fzf`, `bat`, `fd`, `zoxide`, `deno`, LSPs).
4. Sets up standalone tools like `phpactor`.
5. Links or copies configurations into `~/.config`.
6. Runs a full diagnostic report (`doctor.sh`).

## Scripts

### Bootstrap and dependency installer

```sh
bash scripts/bootstrap.sh             # Full automated bootstrap
bash scripts/bootstrap.sh --check     # Run health check without installing
bash scripts/bootstrap.sh --skip-os   # Only install mise/userland tools
bash scripts/bootstrap.sh --no-config # Install dependencies without touching ~/.config
```

### Validate environment health

```sh
bash scripts/doctor.sh
```

Performs a comprehensive check across 39 inspection points:
- Core repository folders
- Core terminal stack binaries
- CLI & navigation helpers
- Media tools (FFmpeg & ImageMagick)
- Helix language servers and formatters
- Config targets in `~/.config`
- Syntax validation for all TOML, KDL, and Fish files

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
