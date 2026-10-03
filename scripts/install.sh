#!/usr/bin/env sh
set -eu

REPO_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
CONFIG_DIR=${XDG_CONFIG_HOME:-"$HOME/.config"}
BACKUP_ROOT=${XDG_STATE_HOME:-"$HOME/.local/state"}/dotfiles/backups
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"
MODE="copy"
DO_BACKUP=1
DRY_RUN=0
COMPONENTS="helix fish zellij alacritty"

usage() {
    cat <<USAGE
Usage: $(basename "$0") [options]

Install configs from this repo into $CONFIG_DIR.

Options:
  --dry-run       Show what would happen without changing files
  --no-backup     Replace existing configs without creating a backup
  --link          Symlink configs instead of copying them
  -h, --help      Show this help
USAGE
}

log() {
    printf '%s\n' "$*"
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --dry-run)
            DRY_RUN=1
            ;;
        --no-backup)
            DO_BACKUP=0
            ;;
        --link)
            MODE="link"
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
    shift
done

create_backup() {
    target=$1
    if [ ! -e "$target" ] && [ ! -L "$target" ]; then
        return 0
    fi

    if [ "$DO_BACKUP" -eq 0 ]; then
        return 0
    fi

    mkdir -p "$BACKUP_DIR"
    rel_path=$(basename "$target")
    log "Backing up $target -> $BACKUP_DIR/$rel_path"
    if [ "$DRY_RUN" -eq 0 ]; then
        cp -a "$target" "$BACKUP_DIR/$rel_path"
    fi
}

install_component() {
    component=$1
    source="$REPO_DIR/$component"
    target="$CONFIG_DIR/$component"

    if [ ! -e "$source" ]; then
        log "Skipping $component (not found in repo)"
        return 0
    fi

    create_backup "$target"

    if [ "$DRY_RUN" -eq 1 ]; then
        log "[dry-run] install $source -> $target ($MODE)"
        return 0
    fi

    rm -rf "$target"
    mkdir -p "$CONFIG_DIR"

    if [ "$MODE" = "link" ]; then
        ln -s "$source" "$target"
        log "Linked $source -> $target"
    else
        cp -a "$source" "$target"
        log "Copied $source -> $target"
    fi
}

log "Installing dotfiles from $REPO_DIR to $CONFIG_DIR (mode: $MODE)"
for component in $COMPONENTS; do
    install_component "$component"
done

log "Install complete."
