# Scripts Architecture & Usage

Modular, strict POSIX-compatible shell scripts designed for automated bootstrapping, installation, diagnostics, integration testing, and synchronization of personal dotfiles.

---

## Directory layout

```text
scripts/
├── lib/
│   └── common.sh         # Shared utilities (paths, colors, logging, version resolution, OS detection)
├── bootstrap.sh          # System-agnostic setup & dependency installer
├── diff.sh               # Live ~/.config ↔ repo comparison
├── doctor.sh             # Comprehensive 47-point environment health check
├── test.sh               # Integration & smoke test suite (syntax, binary execution, Fish aliases)
├── install.sh            # Copies or symlinks configs into ~/.config
└── sync-from-config.sh   # Sinks changes from ~/.config back into repo
```

---

## Engineering Standards

1. **Strict Error Handling**: All scripts start with `set -eu` to fail fast on errors or unset variables.
2. **Centralized Configuration**: All scripts import `scripts/lib/common.sh` for canonical paths, logging functions, shared components, and version extraction.
3. **Smart Terminal Detection**: Colors automatically disable in non-interactive pipes or when `NO_COLOR` / `TERM=dumb` is set.
4. **POSIX Compliance**: Scripts use standard POSIX `sh` for universal portability across any Linux distro or macOS.

---

## Available Commands

### 1. Unified Dispatcher (Root CLI)
You can run any script from the repository root via `./dotfiles`:

```sh
./dotfiles doctor         # Run health check (fast PATH verification)
./dotfiles doctor -v      # Run health check with live binary execution & version queries
./dotfiles test           # Run full integration & smoke test suite (syntax, bins, aliases)
./dotfiles diff           # Inspect differences
./dotfiles install        # Install configs
./dotfiles sync           # Pull changes from ~/.config
./dotfiles bootstrap      # Full automated setup
```

### 2. Standalone Scripts

#### `scripts/doctor.sh`
Performs an exhaustive health check covering:
- Repository integrity
- Core binaries (Helix, Fish, Zellij, Alacritty, Git)
- CLI helpers (eza, fzf, fd, bat, zoxide, sudo)
- Modern TUI suite (lazygit, delta, yazi, bottom, dust, serpl, xh, lazydocker)
- Media processing tools (FFmpeg, FFprobe, ImageMagick)
- Helix Language Servers & Formatters
- Target directories in `~/.config`
- Syntax validation for TOML, KDL, and 22 Fish functions + 7 completions

Options:
- `-v`, `--version`: Executes each binary live, parses its output, and shows the version string (e.g. `(v25.07.1)`). Fails if execution errors.
- Env vars `CHECK_VERSIONS=1` or `DOTFILES_DOCTOR_VERSIONS=1` achieve the same behavior.

```sh
bash scripts/doctor.sh
bash scripts/doctor.sh --version
```

#### `scripts/test.sh`
Comprehensive smoke and integration test runner:
1. **Configuration Syntax**: TOML validation via Python `tomllib`, Fish syntax via `fish -n`, and Zellij config check.
2. **Binary Smoke Tests**: Executes `--version` (or tool-specific version command) on all installed tools to ensure shims and binaries run cleanly without runtime/dynamic library issues.
3. **Fish Aliases & Functions**: Spawns an isolated Fish subshell, loads `fish/conf.d/aliases.fish`, validates all registered aliases against installed binaries, executes direct aliases with `--version`, and ensures all functions in `fish/functions/` load cleanly.

```sh
bash scripts/test.sh
```

#### `scripts/diff.sh`
Compares the files in `~/.config` with the ones in the repository using `git diff --no-index` with full terminal colors.

```sh
bash scripts/diff.sh
bash scripts/diff.sh --stat   # Compact summary only
bash scripts/diff.sh fish     # Compare only fish configs
```

#### `scripts/install.sh`
Installs configs from the repository into `~/.config` with automatic timestamped backups stored in `~/.local/state/dotfiles/backups/`.

```sh
bash scripts/install.sh
bash scripts/install.sh --link       # Symlink instead of copying
bash scripts/install.sh --dry-run    # Preview changes
bash scripts/install.sh --no-backup  # Skip creating backups
```

#### `scripts/sync-from-config.sh`
Pulls modifications made in `~/.config` back into the repository, ensuring nested `.git` folders are stripped.

```sh
bash scripts/sync-from-config.sh
bash scripts/sync-from-config.sh --dry-run
```

#### `scripts/bootstrap.sh`
Automates setup on a virgin machine:
1. Detects or installs `mise` (`mise.toml`).
2. Installs OS-level libraries via distro package manager (`dnf`, `apt`, `pacman`, `zypper`, `brew`).
3. Installs userland tools, TUIs, and LSPs via `mise install`.
4. Installs Phpactor into `~/.local/bin/phpactor`.
5. Installs configurations into `~/.config`.
6. Runs `scripts/doctor.sh` to produce a final report.

```sh
bash scripts/bootstrap.sh
bash scripts/bootstrap.sh --check     # Only run health check
bash scripts/bootstrap.sh --skip-os   # Skip OS packages (mise only)
bash scripts/bootstrap.sh --no-config # Skip installing ~/.config files
```
