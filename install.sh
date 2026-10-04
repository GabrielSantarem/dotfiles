#!/usr/bin/env sh
# install.sh - Web installer and system bootstrapper for personal dotfiles
#
# Usage:
#   curl -fsSL https://codeberg.org/MrTomate/dotfiles/raw/branch/main/install.sh | sh
#   wget -qO- https://codeberg.org/MrTomate/dotfiles/raw/branch/main/install.sh | sh
#
# Options:
#   sh install.sh --dir ~/.dotfiles    # Install into custom directory
#   sh install.sh --link              # Symlink configs into ~/.config
#   sh install.sh --no-bootstrap      # Only clone/download, skip bootstrap
#   sh install.sh --skip-os           # Skip OS package installation

set -eu

REPO_URL="https://codeberg.org/MrTomate/dotfiles.git"
TARBALL_URL="https://codeberg.org/MrTomate/dotfiles/archive/main.tar.gz"

DOTFILES_DIR="${DOTFILES_DIR:-"$HOME/.dotfiles"}"
BIN_DIR="${XDG_BIN_HOME:-"$HOME/.local/bin"}"
DO_BOOTSTRAP=1
INSTALL_MODE="copy"
SKIP_OS=0

# Colors (raw escape bytes to prevent literal \033 escaping in subshells/pipes)
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ] && [ "${TERM:-dumb}" != "dumb" ]; then
    CLR_RESET=$(printf '\033[0m')
    CLR_BOLD=$(printf '\033[1m')
    CLR_GREEN=$(printf '\033[32m')
    CLR_RED=$(printf '\033[31m')
    CLR_YELLOW=$(printf '\033[33m')
    CLR_BLUE=$(printf '\033[36m')
else
    CLR_RESET=''
    CLR_BOLD=''
    CLR_GREEN=''
    CLR_RED=''
    CLR_YELLOW=''
    CLR_BLUE=''
fi

log_title() {
    printf "%s==> %s%s\n" "$CLR_BOLD" "$1" "$CLR_RESET"
}

log_info() {
    printf "info: %s\n" "$1"
}

log_warn() {
    printf "%swarn: %s%s\n" "$CLR_YELLOW" "$1" "$CLR_RESET"
}

log_error() {
    printf "%serror: %s%s\n" "$CLR_RED" "$1" "$CLR_RESET" >&2
}

log_success() {
    printf "%sok:   %s%s\n" "$CLR_GREEN" "$1" "$CLR_RESET"
}

# Parse CLI arguments
while [ "$#" -gt 0 ]; do
    case "$1" in
        --dir)
            if [ -n "${2:-}" ]; then
                DOTFILES_DIR="$2"
                shift
            else
                log_error "--dir requires a path argument"
                exit 1
            fi
            ;;
        --link)
            INSTALL_MODE="link"
            ;;
        --no-bootstrap)
            DO_BOOTSTRAP=0
            ;;
        --skip-os)
            SKIP_OS=1
            ;;
        -h|--help)
            cat <<EOF
Dotfiles Web Installer

Usage: curl -fsSL <url>/install.sh | sh -s -- [options]

Options:
  --dir <path>     Target clone directory (default: ~/.dotfiles)
  --link           Symlink configs directly to ~/.config
  --no-bootstrap   Fetch repo and link CLI only, skip running bootstrap
  --skip-os        Skip OS package installation (run mise only)
  -h, --help       Show this help message
EOF
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            exit 1
            ;;
    esac
    shift
done

log_title "Dotfiles Installer"
printf "Target: %s\n" "$DOTFILES_DIR"

# 1. Fetch Repository
if [ -d "$DOTFILES_DIR/.git" ]; then
    log_info "Existing repository detected in $DOTFILES_DIR"
    if command -v git >/dev/null 2>&1; then
        log_info "Updating repository via git pull..."
        git -C "$DOTFILES_DIR" pull --ff-only || log_warn "git pull failed, using current local version"
    fi
elif [ -d "$DOTFILES_DIR" ]; then
    log_info "Target directory $DOTFILES_DIR exists, keeping existing files"
else
    if command -v git >/dev/null 2>&1; then
        log_info "Cloning repository via git..."
        git clone --depth 1 "$REPO_URL" "$DOTFILES_DIR"
    else
        log_warn "git not found. Downloading repository tarball..."
        tmpdir=$(mktemp -d)
        if command -v curl >/dev/null 2>&1; then
            curl -fsSL "$TARBALL_URL" | tar -xz -C "$tmpdir"
        elif command -v wget >/dev/null 2>&1; then
            wget -qO- "$TARBALL_URL" | tar -xz -C "$tmpdir"
        else
            log_error "Neither curl, wget, nor git was found. Cannot download dotfiles."
            exit 1
        fi

        extracted_dir=$(find "$tmpdir" -mindepth 1 -maxdepth 1 -type d | head -n 1)
        if [ -n "$extracted_dir" ] && [ -d "$extracted_dir" ]; then
            mkdir -p "$(dirname "$DOTFILES_DIR")"
            mv "$extracted_dir" "$DOTFILES_DIR"
        else
            log_error "Failed to extract repository archive."
            rm -rf "$tmpdir"
            exit 1
        fi
        rm -rf "$tmpdir"
    fi
fi

# Ensure scripts have execute permissions
chmod +x "$DOTFILES_DIR/dotfiles" "$DOTFILES_DIR/scripts"/*.sh 2>/dev/null || true

# 2. Setup CLI command in ~/.local/bin
mkdir -p "$BIN_DIR"
cli_symlink="$BIN_DIR/dotfiles"
rm -f "$cli_symlink"
ln -s "$DOTFILES_DIR/dotfiles" "$cli_symlink"
log_success "Linked CLI executable to $cli_symlink"

# 3. Check PATH
case ":$PATH:" in
    *":$BIN_DIR:"*) ;;
    *)
        log_warn "$BIN_DIR is not currently in your \$PATH."
        log_warn "Add this line to your shell profile to run 'dotfiles' directly:"
        printf "  export PATH=\"\$HOME/.local/bin:\$PATH\"\n\n"
        ;;
esac

# 4. Run Bootstrap
if [ "$DO_BOOTSTRAP" -eq 1 ]; then
    bootstrap_args=""
    if [ "$INSTALL_MODE" = "link" ]; then
        sh "$DOTFILES_DIR/scripts/install.sh" --link
    fi
    if [ "$SKIP_OS" -eq 1 ]; then
        bootstrap_args="--skip-os"
    fi

    # Invoke bootstrap via root CLI
    sh "$DOTFILES_DIR/dotfiles" bootstrap $bootstrap_args
else
    log_info "Skipping bootstrap (--no-bootstrap was specified)"
fi

log_title "Installation finished"
printf "Repository: %s\n" "$DOTFILES_DIR"
printf "CLI tool:   %s\n" "$cli_symlink"
printf "Run 'dotfiles help' or 'dotfiles doctor' anytime.\n"
