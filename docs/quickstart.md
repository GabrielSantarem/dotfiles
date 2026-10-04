# Quick Start

Get your complete Terminal Forever environment running on any fresh machine in under 2 minutes.

---

## 1. One-Liner Web Installer (Recommended)

You don't need `git` installed beforehand. Run the following command in any terminal:

```sh
curl -fsSL https://codeberg.org/MrTomate/dotfiles/raw/branch/main/install.sh | sh
```

Or using `wget`:

```sh
wget -qO- https://codeberg.org/MrTomate/dotfiles/raw/branch/main/install.sh | sh
```

### What this command does automatically:
1. Downloads or clones the repository into `~/.dotfiles`.
2. Creates a global symlink `~/.local/bin/dotfiles` so the CLI is accessible anywhere in your shell.
3. Installs `mise` (if not already present).
4. Installs OS native packages (`fish`, `alacritty`, `ffmpeg`, `imagemagick`, `git`).
5. Installs userland binaries via `mise.toml` (Helix, Zellij, eza, fzf, bat, fd, zoxide, TUI tools, LSPs).
6. Copies configurations safely into `~/.config` with timestamped backups.
7. Executes `dotfiles doctor` to verify that all 47 checks are green.

---

## 2. Advanced Options

You can pass arguments to the installer via `sh -s -- [flags]`:

```sh
# Symlink configurations directly to the repository (ideal for development):
curl -fsSL https://codeberg.org/MrTomate/dotfiles/raw/branch/main/install.sh | sh -s -- --link

# Only clone repository and link CLI, skipping bootstrap:
curl -fsSL https://codeberg.org/MrTomate/dotfiles/raw/branch/main/install.sh | sh -s -- --no-bootstrap

# Install into a custom directory:
curl -fsSL https://codeberg.org/MrTomate/dotfiles/raw/branch/main/install.sh | sh -s -- --dir ~/my-dotfiles
```

---

## 3. Manual Clone Alternative

If you already have `git` and prefer manual control:

```sh
git clone ssh://git@codeberg.org/MrTomate/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./dotfiles bootstrap
```

---

## 4. Post-Install Verification

Once the installer finishes, verify your environment by running:

```sh
dotfiles doctor
```

Or run the full smoke test suite:

```sh
dotfiles test
```
