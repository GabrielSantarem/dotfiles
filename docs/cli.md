# Dotfiles Management CLI

The `dotfiles` command is a unified, strict POSIX dispatcher located at the repository root and symlinked to `~/.local/bin/dotfiles`. It can be run from **any directory** in your terminal.

---

## Command Reference

```text
Usage: dotfiles <command> [options]

Commands:
  doctor, check     Run environment health check (bins, LSPs, syntax)
                    Options: -v, --version (verify execution & live versions)
  test              Run full integration & smoke test suite (syntax, bins, aliases)
  diff              Show colored differences between ~/.config and repository
  install           Install or update configurations into ~/.config
  sync              Pull live configurations from ~/.config back into repo
  bootstrap         Automated first-time setup and dependency installer
  help, -h, --help  Show usage message
```

---

## 1. `dotfiles doctor` (Health Check)

Validates 47 distinct points across your system:
- Repository components integrity (`helix`, `fish`, `zellij`, `alacritty`)
- Core binaries availability
- CLI helpers and modern TUI suite
- Helix Language Servers (Deno, Python, Go, Rust, Ruby, PHP, Tailwind, HTML, CSS)
- Targets in `~/.config`
- Syntax validation for TOML (`tomllib`), Fish scripts (`fish -n`), and Zellij configs.

```sh
dotfiles doctor
```

### Live Version & Execution Verification (`-v` / `--version`)
By default, `doctor` performs a fast `<100ms` check. Passing `-v` executes each binary with `--version`, extracts the real installed version string, and flags any broken shims or dynamic library missing errors:

```sh
dotfiles doctor -v
```

---

## 2. `dotfiles test` (Integration & Smoke Tests)

Runs an automated 3-stage test suite:
1. **Config Syntax**: Validates all TOML files, `config.fish`, `conf.d/*.fish`, `functions/*.fish`, and `completions/*.fish`.
2. **Binary Smoke Tests**: Invocations of all 26 core tools and language servers.
3. **Fish Aliases & Functions**: Spawns an isolated Fish subshell, verifies that all registered aliases point to active binaries, tests direct aliases with `--version`, and ensures all 22 custom functions load cleanly.

```sh
dotfiles test
```

---

## 3. `dotfiles diff` (Inspecting Changes)

Compares files in `~/.config` against tracked repository files using `git diff --no-index` with full terminal syntax highlighting:

```sh
dotfiles diff          # Full visual diff across all components
dotfiles diff --stat   # Compact summary of changed lines/files
dotfiles diff fish     # Compare only fish configuration
```

---

## 4. `dotfiles install` (Deploying Configs)

Installs repository configurations into `~/.config`:

```sh
dotfiles install               # Copy all components with automatic backups
dotfiles install --link        # Symlink directly to repository (live editing)
dotfiles install --dry-run     # Preview actions without touching the disk
dotfiles install --no-backup   # Overwrite without timestamped backups
```

---

## 5. `dotfiles sync` (Pulling Live Adjustments)

If you made quick adjustments directly inside `~/.config` and want to pull them back into the repository for versioning:

```sh
dotfiles sync           # Pull changes from ~/.config to repository
dotfiles sync --dry-run # Preview what would be synced
```

---

## 6. `dotfiles bootstrap` (Automated Provisioning)

Used during first-time machine setup:
- Detects package manager (`dnf`, `apt`, `pacman`, `zypper`, `brew`).
- Installs `mise` and system dependencies.
- Runs `mise install -y` to provision userland tooling.
- Sets up standalone tools like `phpactor`.
- Deploys configurations to `~/.config` and validates with `doctor`.

```sh
dotfiles bootstrap
dotfiles bootstrap --skip-os   # Skip OS packages (mise & userland only)
dotfiles bootstrap --no-config # Skip writing to ~/.config
```
