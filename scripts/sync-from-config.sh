#!/usr/bin/env sh
set -eu

# Load common library
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/lib/common.sh"

DRY_RUN=0

usage() {
    cat <<USAGE
Usage: $(basename "$0") [options]

Sync current live configs from $CONFIG_DIR back into this repo.

Options:
  --dry-run       Show what would happen without changing files
  -h, --help      Show this help message
USAGE
}

for arg in "$@"; do
    case "$arg" in
        --dry-run)
            DRY_RUN=1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            log_error "Unknown option: $arg"
            usage >&2
            exit 1
            ;;
    esac
done

log_banner "Syncing live configs from $CONFIG_DIR -> $REPO_DIR"

for component in $COMPONENTS; do
    if [ ! -e "$CONFIG_DIR/$component" ] && [ ! -L "$CONFIG_DIR/$component" ]; then
        log_error "Missing config component: $CONFIG_DIR/$component"
        exit 1
    fi
done

for component in $COMPONENTS; do
    source="$CONFIG_DIR/$component"
    target="$REPO_DIR/$component"

    if [ "$DRY_RUN" -eq 1 ]; then
        log_info "[dry-run] Sync $source -> $target"
    else
        rm -rf "$target"
        cp -a "$source" "$target"
        rm -rf "$target/.git"
        log_success "Synced $component -> $target"
    fi
done

log_step "Done. Repo updated from $CONFIG_DIR!"
