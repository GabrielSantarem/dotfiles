#!/usr/bin/env sh
set -eu

# Load common library
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/lib/common.sh"

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR="$BACKUP_ROOT/$TIMESTAMP"
MODE="copy"
DO_BACKUP=1
DRY_RUN=0

usage() {
    cat <<USAGE
Usage: $(basename "$0") [options]

Install configs from this repo into $CONFIG_DIR.

Options:
  --dry-run       Show what would happen without changing files
  --no-backup     Replace existing configs without creating a backup
  --link          Symlink configs instead of copying them
  -h, --help      Show this help message
USAGE
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
            log_error "Unknown option: $1"
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

    rel_path=$(basename "$target")
    if [ "$DRY_RUN" -eq 1 ]; then
        log_info "[dry-run] Backing up $target -> $BACKUP_DIR/$rel_path"
    else
        mkdir -p "$BACKUP_DIR"
        cp -a "$target" "$BACKUP_DIR/$rel_path"
        log_info "Backed up $target -> $BACKUP_DIR/$rel_path"
    fi
}

install_component() {
    component=$1
    source="$REPO_DIR/$component"
    target="$CONFIG_DIR/$component"

    if [ ! -e "$source" ]; then
        log_warn "Skipping $component (not found in repo)"
        return 0
    fi

    create_backup "$target"

    if [ "$DRY_RUN" -eq 1 ]; then
        log_info "[dry-run] install $source -> $target ($MODE)"
        return 0
    fi

    rm -rf "$target"
    mkdir -p "$CONFIG_DIR"

    if [ "$MODE" = "link" ]; then
        ln -s "$source" "$target"
        log_success "Linked $source -> $target"
    else
        cp -a "$source" "$target"
        log_success "Copied $source -> $target"
    fi
}

log_banner "Installing Dotfiles to $CONFIG_DIR (mode: $MODE)"
for component in $COMPONENTS; do
    install_component "$component"
done

log_step "Install complete!"
