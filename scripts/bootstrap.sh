#!/usr/bin/env sh
set -eu

# Load common library
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/lib/common.sh"

SKIP_OS=0
SKIP_CONFIG=0

usage() {
    cat <<USAGE
Usage: $(basename "$0") [options]

System-agnostic bootstrapper and dependency installer for dotfiles.
Uses 'mise' for 95% of tools (userland, no sudo) and the native OS
package manager only for GUI/Terminal/Media libraries (alacritty, fish, ffmpeg, imagemagick).

Options:
  --check              Only run health check without installing
  --skip-os            Skip OS-level package installation (mise/userland only)
  --no-config          Install dependencies without running scripts/install.sh
  -h, --help           Show this help message
USAGE
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --check)
            exec sh "$REPO_DIR/scripts/doctor.sh"
            ;;
        --skip-os)
            SKIP_OS=1
            ;;
        --no-config)
            SKIP_CONFIG=1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            usage >&2
            exit 1
            ;;
    esac
    shift
done

log_banner "Dotfiles System-Agnostic Bootstrap"

# 1. Install or verify mise
log_step "1. Checking mise (Universal Tool Manager)"
if command -v mise >/dev/null 2>&1; then
    log_success "mise is already installed: $(command -v mise)"
else
    log_info "Installing mise into ~/.local/bin/mise..."
    mkdir -p "$HOME/.local/bin"
    curl -fsSL https://mise.run | sh
    export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"
    log_success "mise installed successfully."
fi

# 2. OS-level native packages
if [ "$SKIP_OS" -eq 0 ]; then
    log_step "2. Checking OS-level packages (alacritty, fish, ffmpeg, imagemagick)"
    pm=$(detect_os_pm)
    case "$pm" in
        dnf)
            log_info "Detected Fedora/RHEL (dnf). Installing system packages..."
            sudo dnf install -y fish alacritty ffmpeg ImageMagick git
            ;;
        apt)
            log_info "Detected Debian/Ubuntu (apt). Installing system packages..."
            sudo apt-get update
            sudo apt-get install -y fish alacritty ffmpeg imagemagick git
            ;;
        pacman)
            log_info "Detected Arch Linux (pacman). Installing system packages..."
            sudo pacman -S --needed --noconfirm fish alacritty ffmpeg imagemagick git
            ;;
        zypper)
            log_info "Detected openSUSE (zypper). Installing system packages..."
            sudo zypper install -y fish alacritty ffmpeg ImageMagick git
            ;;
        brew)
            log_info "Detected Homebrew (brew). Installing system packages..."
            brew install fish alacritty ffmpeg imagemagick git
            ;;
        *)
            log_warn "No recognized OS package manager found. Skipping OS-level install."
            ;;
    esac
else
    log_step "2. Skipping OS-level package installation (--skip-os active)"
fi

# 3. Install userland agnostic tools via mise
log_step "3. Installing agnostic tools & language servers via mise"
cd "$REPO_DIR"
mise install -y
mise reshim

# 4. Install standalone tools (Phpactor)
log_step "4. Checking standalone tools (Phpactor for PHP)"
if command -v phpactor >/dev/null 2>&1; then
    log_success "phpactor is already available: $(command -v phpactor)"
else
    log_info "Downloading phpactor.phar into ~/.local/bin/phpactor..."
    mkdir -p "$HOME/.local/bin"
    curl -fsSL -o "$HOME/.local/bin/phpactor" https://github.com/phpactor/phpactor/releases/latest/download/phpactor.phar
    chmod +x "$HOME/.local/bin/phpactor"
    log_success "phpactor installed successfully."
fi

# 5. Install dotfile configurations
if [ "$SKIP_CONFIG" -eq 0 ]; then
    log_step "5. Installing configurations into ~/.config"
    sh "$REPO_DIR/scripts/install.sh"
else
    log_step "5. Skipping config installation (--no-config active)"
fi

# 6. Final verification report
log_step "6. Running environment health check"
sh "$REPO_DIR/scripts/doctor.sh"

log_step "Bootstrap finished successfully!"
