#!/usr/bin/env sh
# scripts/lib/common.sh - Shared utilities and standards for dotfiles scripts
#
# Design principles:
# 1. POSIX shell compatible (works on dash, bash, zsh, ksh, ash).
# 2. Strict error handling (set -eu).
# 3. Clean colored logging with automatic non-interactive/NO_COLOR detection.
# 4. Centralized single source of truth for paths and components.

# Prevent double inclusion
if [ "${_DOTFILES_COMMON_LOADED:-0}" -eq 1 ]; then
    return 0 2>/dev/null || exit 0
fi
_DOTFILES_COMMON_LOADED=1

# Canonical Paths
_CALLER_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
case "$_CALLER_DIR" in
    */scripts/lib) REPO_DIR=$(CDPATH= cd -- "$_CALLER_DIR/../.." && pwd) ;;
    */scripts)     REPO_DIR=$(CDPATH= cd -- "$_CALLER_DIR/.." && pwd) ;;
    *)             REPO_DIR=$(git rev-parse --show-toplevel 2>/dev/null || pwd) ;;
esac

CONFIG_DIR=${XDG_CONFIG_HOME:-"$HOME/.config"}
STATE_DIR=${XDG_STATE_HOME:-"$HOME/.local/state"}
BACKUP_ROOT="$STATE_DIR/dotfiles/backups"

# Shared Components
COMPONENTS="helix fish zellij alacritty"

# Color support detection (respects NO_COLOR and dumb terminals)
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ] && [ "${TERM:-dumb}" != "dumb" ]; then
    CLR_RESET='\033[0m'
    CLR_BOLD='\033[1m'
    CLR_GREEN='\033[38;2;66;190;101m'   # #42be65 (Carbon Green accent)
    CLR_RED='\033[38;2;255;123;114m'    # Coral red
    CLR_YELLOW='\033[38;2;242;204;96m'  # Warm yellow
    CLR_BLUE='\033[38;2;120;219;169m'   # Mint blue
    CLR_GRAY='\033[38;2;110;118;129m'   # Muted gray
else
    CLR_RESET=''
    CLR_BOLD=''
    CLR_GREEN=''
    CLR_RED=''
    CLR_YELLOW=''
    CLR_BLUE=''
    CLR_GRAY=''
fi

# Logging functions
log() {
    printf '%s\n' "$*"
}

log_info() {
    printf "%b[info]%b  %s\n" "$CLR_BLUE" "$CLR_RESET" "$*"
}

log_success() {
    printf "%b[ok]%b    %s\n" "$CLR_GREEN" "$CLR_RESET" "$*"
}

log_warn() {
    printf "%b[warn]%b  %s\n" "$CLR_YELLOW" "$CLR_RESET" "$*"
}

log_error() {
    printf "%b[error]%b %s\n" "$CLR_RED" "$CLR_RESET" "$*" >&2
}

log_step() {
    printf "\n%b==>%b %b%s%b\n" "$CLR_GREEN" "$CLR_RESET" "$CLR_BOLD" "$1" "$CLR_RESET"
}

log_banner() {
    printf "%b==================================================%b\n" "$CLR_GRAY" "$CLR_RESET"
    printf "  %b%s%b\n" "$CLR_BOLD" "$1" "$CLR_RESET"
    printf "%b==================================================%b\n" "$CLR_GRAY" "$CLR_RESET"
}

# Distro Package Manager Detection
detect_os_pm() {
    if command -v dnf >/dev/null 2>&1; then
        echo "dnf"
    elif command -v apt-get >/dev/null 2>&1; then
        echo "apt"
    elif command -v pacman >/dev/null 2>&1; then
        echo "pacman"
    elif command -v zypper >/dev/null 2>&1; then
        echo "zypper"
    elif command -v brew >/dev/null 2>&1; then
        echo "brew"
    else
        echo "unknown"
    fi
}
