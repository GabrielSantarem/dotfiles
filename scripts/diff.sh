#!/usr/bin/env sh
set -eu

# Load common library
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/lib/common.sh"

DIFF_TOOL="diff"
if command -v git >/dev/null 2>&1; then
    DIFF_TOOL="git"
fi

DIFF_COUNT=0

usage() {
    cat <<USAGE
Usage: $(basename "$0") [options] [component...]

Compare live configurations in $CONFIG_DIR with repository files.

Options:
  --stat          Show compact file difference statistics
  -h, --help      Show this help message

Components:
  helix fish zellij alacritty (default: all)
USAGE
}

STAT_ONLY=0
SELECTED_COMPONENTS=""

while [ "$#" -gt 0 ]; do
    case "$1" in
        --stat)
            STAT_ONLY=1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -*)
            log_error "Unknown option: $1"
            usage >&2
            exit 1
            ;;
        *)
            SELECTED_COMPONENTS="$SELECTED_COMPONENTS $1"
            ;;
    esac
    shift
done

if [ -z "$SELECTED_COMPONENTS" ]; then
    TARGET_COMPONENTS="$COMPONENTS"
else
    TARGET_COMPONENTS="$SELECTED_COMPONENTS"
fi

log_banner "Dotfiles Diff (Live ~/.config ↔ Repo)"

for comp in $TARGET_COMPONENTS; do
    repo_target="$REPO_DIR/$comp"
    live_target="$CONFIG_DIR/$comp"

    if [ ! -e "$repo_target" ]; then
        log_warn "Skipping '$comp': not present in repository ($repo_target)"
        continue
    fi

    if [ ! -e "$live_target" ]; then
        log_warn "Skipping '$comp': not installed in config ($live_target)"
        continue
    fi

    if [ -L "$live_target" ]; then
        target_link=$(readlink "$live_target" || true)
        if [ "$target_link" = "$repo_target" ]; then
            log_info "$comp: Symlinked directly to repo (always in sync)"
            continue
        fi
    fi

    log_step "Checking diff: $comp (~/.config/$comp ↔ repo/$comp)"

    if [ "$DIFF_TOOL" = "git" ]; then
        if [ "$STAT_ONLY" -eq 1 ]; then
            if ! git diff --no-index --stat "$repo_target" "$live_target"; then
                DIFF_COUNT=$((DIFF_COUNT + 1))
            else
                log_success "$comp: In sync (no differences)"
            fi
        else
            if git diff --no-index --quiet "$repo_target" "$live_target" 2>/dev/null; then
                log_success "$comp: In sync (no differences)"
            else
                DIFF_COUNT=$((DIFF_COUNT + 1))
                git diff --no-index --color=always "$repo_target" "$live_target" || true
            fi
        fi
    else
        if diff -rq "$repo_target" "$live_target" >/dev/null 2>&1; then
            log_success "$comp: In sync (no differences)"
        else
            DIFF_COUNT=$((DIFF_COUNT + 1))
            diff -u -r "$repo_target" "$live_target" || true
        fi
    fi
done

printf '\n'
if [ "$DIFF_COUNT" -eq 0 ]; then
    log_success "All checked components are completely in sync!"
else
    log_warn "Found differences in $DIFF_COUNT component(s)."
    log_info "To sync changes into repo:  bash scripts/sync-from-config.sh"
    log_info "To install repo to config:  bash scripts/install.sh"
fi
