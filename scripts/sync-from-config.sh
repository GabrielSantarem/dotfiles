#!/usr/bin/env sh
set -eu

REPO_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
CONFIG_DIR=${XDG_CONFIG_HOME:-"$HOME/.config"}
DRY_RUN=0
COMPONENTS="helix fish zellij alacritty"

usage() {
    cat <<USAGE
Usage: $(basename "$0") [options]

Sync current configs from $CONFIG_DIR back into this repo.

Options:
  --dry-run       Show what would happen without changing files
  -h, --help      Show this help
USAGE
}

log() {
    printf '%s\n' "$*"
}

run() {
    if [ "$DRY_RUN" -eq 1 ]; then
        printf '[dry-run] %s\n' "$*"
    else
        sh -c "$*"
    fi
}

for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=1 ;;
        -h|--help) usage; exit 0 ;;
        *) printf 'Unknown option: %s\n' "$arg" >&2; usage >&2; exit 1 ;;
    esac
done

for component in $COMPONENTS; do
    if [ ! -e "$CONFIG_DIR/$component" ] && [ ! -L "$CONFIG_DIR/$component" ]; then
        printf 'Missing config component: %s\n' "$CONFIG_DIR/$component" >&2
        exit 1
    fi
done

for component in $COMPONENTS; do
    source="$CONFIG_DIR/$component"
    target="$REPO_DIR/$component"
    if [ -e "$target" ] || [ -L "$target" ]; then
        run "rm -rf '$target'"
    fi
    run "cp -a '$source' '$target'"
    run "rm -rf '$target/.git'"
    log "Synced $component -> $target"
done

log "Done. Repo updated from $CONFIG_DIR"
