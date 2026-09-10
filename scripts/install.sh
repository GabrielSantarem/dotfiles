#!/usr/bin/env sh
set -eu

REPO_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
CONFIG_DIR=${XDG_CONFIG_HOME:-"$HOME/.config"}
BACKUP_ROOT=${XDG_STATE_HOME:-"$HOME/.local/state"}/dotfiles-unified/backups
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
        --no-backup) DO_BACKUP=0 ;;
        --link) MODE="link" ;;
        -h|--help) usage; exit 0 ;;
        *) printf 'Unknown option: %s\n' "$arg" >&2; usage >&2; exit 1 ;;
    esac
done

for component in $COMPONENTS; do
    if [ ! -e "$REPO_DIR/$component" ]; then
        printf 'Missing repo component: %s\n' "$REPO_DIR/$component" >&2
        exit 1
    fi
done

run "mkdir -p '$CONFIG_DIR'"

if [ "$DO_BACKUP" -eq 1 ]; then
    needs_backup=0
    for component in $COMPONENTS; do
        if [ -e "$CONFIG_DIR/$component" ] || [ -L "$CONFIG_DIR/$component" ]; then
            needs_backup=1
            break
        fi
    done
    if [ "$needs_backup" -eq 1 ]; then
        run "mkdir -p '$BACKUP_DIR'"
        for component in $COMPONENTS; do
            if [ -e "$CONFIG_DIR/$component" ] || [ -L "$CONFIG_DIR/$component" ]; then
                run "cp -a '$CONFIG_DIR/$component' '$BACKUP_DIR/$component'"
            fi
        done
        log "Backup: $BACKUP_DIR"
    fi
fi

for component in $COMPONENTS; do
    target="$CONFIG_DIR/$component"
    source="$REPO_DIR/$component"
    if [ -e "$target" ] || [ -L "$target" ]; then
        run "rm -rf '$target'"
    fi
    if [ "$MODE" = "link" ]; then
        run "ln -s '$source' '$target'"
    else
        run "cp -a '$source' '$target'"
    fi
    log "Installed $component -> $target"
done

log "Done. Mode: $MODE"
