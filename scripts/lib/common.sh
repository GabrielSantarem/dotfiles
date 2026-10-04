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

# Ensure mise finds repository tools even when called outside repo root
if [ -f "$REPO_DIR/mise.toml" ] && [ -z "${MISE_CONFIG_FILE:-}" ]; then
    export MISE_CONFIG_FILE="$REPO_DIR/mise.toml"
fi

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

# Resolve and verify binary version
get_cmd_version() {
    _cmd=$1
    _raw=""
    _ver=""
    case "$_cmd" in
        ffmpeg|ffprobe)
            _raw=$("$_cmd" -version 2>/dev/null) || return 1
            ;;
        gopls)
            _raw=$("$_cmd" version 2>/dev/null) || return 1
            ;;
        goimports)
            if command -v go >/dev/null 2>&1; then
                _raw=$(go version -m "$(command -v goimports)" 2>/dev/null | grep 'mod	' | head -n 1)
            else
                _raw="goimports"
            fi
            ;;
        basedpyright-langserver)
            if command -v basedpyright >/dev/null 2>&1; then
                _raw=$(basedpyright --version 2>/dev/null) || return 1
            else
                printf "installed"
                return 0
            fi
            ;;
        tailwindcss-language-server)
            _bin_path=$(command -v "$_cmd" 2>/dev/null)
            _pkg="$(dirname "$_bin_path")/../lib/node_modules/@tailwindcss/language-server/package.json"
            if [ -f "$_pkg" ]; then
                _ver=$(grep -o '"version": "[^"]*"' "$_pkg" 2>/dev/null | head -n 1 | cut -d'"' -f4)
            fi
            ;;
        vscode-*-language-server)
            _bin_path=$(command -v "$_cmd" 2>/dev/null)
            _pkg="$(dirname "$_bin_path")/../lib/node_modules/vscode-langservers-extracted/package.json"
            if [ -f "$_pkg" ]; then
                _ver=$(grep -o '"version": "[^"]*"' "$_pkg" 2>/dev/null | head -n 1 | cut -d'"' -f4)
            fi
            ;;
        eza)
            _raw=$("$_cmd" -v 2>/dev/null) || return 1
            ;;
        sudo)
            _raw=$("$_cmd" -V 2>/dev/null) || return 1
            ;;
        *)
            _raw=$("$_cmd" --version 2>/dev/null) || return 1
            ;;
    esac

    if [ -z "$_ver" ] && [ -n "$_raw" ]; then
        _ver=$(printf "%s" "$_raw" | grep -oE "[0-9]+\.[0-9]+(\.[0-9]+)?(-[a-zA-Z0-9.]+)*" 2>/dev/null | head -n 1)
    fi

    if [ -n "$_ver" ]; then
        printf "%s" "$_ver"
    elif [ -n "$_raw" ]; then
        printf "%s" "$_raw" | head -n 1 | cut -c 1-25
    else
        return 1
    fi
}
