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
- easy to validate (`doctor.sh`, `test.sh`)
- easy to install and bootstrap (`install.sh`, `bootstrap.sh`)
- easy to version and back up

## Included configs

- `helix/` — editor settings, themes, and language server definitions
- `fish/` — interactive shell, aliases, prompt, completions, and media helpers
- `zellij/` — multiplexer layouts, discrete UI, and keybinds
- `alacritty/` — GPU-accelerated terminal appearance and fonts
- `scripts/` — bootstrap, installation, diff, sync, and health check scripts
- `mise.toml` — universal tool definitions (userland, system-agnostic)
- `dotfiles` — unified root CLI management script
- `install.sh` — standalone one-liner web installer & distributor

## Component documentation

Each tool has its own focused README:

- [`helix/README.md`](helix/README.md) — editor config, themes, language tooling, Deno LSP, Phpactor, Ruby LSP
- [`fish/README.md`](fish/README.md) — shell behavior, prompt, aliases, functions, media helpers (`vconv`, `vgif`, etc.)
- [`zellij/README.md`](zellij/README.md) — layout, mode flow, keybind strategy, discrete UI
- [`alacritty/README.md`](alacritty/README.md) — terminal appearance, font, padding, and shortcuts
- [`scripts/README.md`](scripts/README.md) — architecture, usage, and standards for all scripts

## Repository layout

```text
.
├── alacritty/
├── dotfiles                # Unified CLI dispatcher (symlinked to ~/.local/bin)
├── fish/
├── helix/
├── install.sh              # Web one-liner installer (curl | sh)
├── mise.toml               # Universal userland tool definitions
├── scripts/
│   ├── README.md
│   ├── bootstrap.sh
│   ├── diff.sh
│   ├── doctor.sh
│   ├── install.sh
│   ├── lib/
│   │   └── common.sh
│   ├── sync-from-config.sh
│   └── test.sh
└── zellij/
```

## Modern TUI Suite (Defined in `mise.toml`)

- **Git & Diffs**: `lazygit` (interactive Git TUI), `delta` (syntax-highlighted diff pager)
- **File Manager**: `yazi` (high-performance async terminal file manager with auto-cd wrapper `y`)
- **System Monitoring**: `bottom` (`btm` — ultra-fast, minimal resource dashboard)
- **Disk Analysis**: `dust` (instant graphical disk usage tree)
- **Search & Replace**: `serpl` (interactive multi-file regex search & replace TUI)
- **API & Networking**: `xh` (modern, friendly, colorized HTTP client)
- **Containers**: `lazydocker` (terminal UI for Docker/Podman containers)

## Quick Start / First-Time Setup

On any new machine (Fedora, Debian/Ubuntu, Arch, macOS):

### Option A: One-Liner Web Installer (Recommended)
No need to install `git` or manually clone beforehand:

```sh
curl -fsSL https://codeberg.org/MrTomate/dotfiles/raw/branch/main/install.sh | sh
```

Or using `wget`:
```sh
wget -qO- https://codeberg.org/MrTomate/dotfiles/raw/branch/main/install.sh | sh
```

### Option B: Manual Git Clone
```sh
git clone ssh://git@codeberg.org/MrTomate/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./dotfiles bootstrap
```

The installer automatically:
1. Clones or unpacks the repository into `~/.dotfiles`.
2. Symlinks the `dotfiles` command to `~/.local/bin/dotfiles` (available anywhere in terminal).
3. Detects or installs `mise` (Universal Tool Manager).
4. Installs OS-level libraries (`alacritty`, `fish`, `ffmpeg`, `imagemagick`).
5. Installs userland tools via `mise` (`helix`, `zellij`, `eza`, `fzf`, `bat`, `fd`, `zoxide`, `deno`, TUI tools, LSPs).
6. Sets up standalone tools like `phpactor`.
7. Links or copies configurations into `~/.config`.
8. Runs a full diagnostic report (`dotfiles doctor`).

## Management CLI (`dotfiles`)

Once installed, the `dotfiles` command is accessible from any terminal directory:

```sh
dotfiles doctor         # Exhaustive 47-point environment health check (fast PATH check)
dotfiles doctor -v      # Live execution & version check for all binaries
dotfiles test           # Smoke & integration tests (syntax, binaries, Fish aliases)
dotfiles diff           # Inspect colorized differences (~/.config ↔ repo)
dotfiles diff --stat    # Compact file difference summary
dotfiles install        # Copy configs to ~/.config (with timestamped backups)
dotfiles install --link # Symlink configs directly to repo
dotfiles sync           # Pull changes from ~/.config back into repo
dotfiles bootstrap      # Full automated machine setup
```

## Workflow

Typical flow:

1. edit configs inside this repository
2. install or link them into `~/.config`
3. validate with `dotfiles doctor` or `dotfiles test`
4. review changes with `dotfiles diff`
5. commit and push changes

## Notes

- Existing configs are backed up by default to `~/.local/state/dotfiles/backups/`.
- `--link` is useful if you want this repository to become the live source of truth.
- The repository is intentionally organized as one place for shell, terminal, multiplexer, and editor configuration.
- Copies stored here should remain free of nested `.git` directories.
