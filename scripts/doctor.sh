#!/usr/bin/env sh
set -eu

# Load common library
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/lib/common.sh"

TOTAL_CHECKED=0
TOTAL_OK=0
TOTAL_OPTIONAL=0
TOTAL_MISSING=0

check_bin() {
    name=$1
    label=${2:-$name}
    optional=${3:-0}
    TOTAL_CHECKED=$((TOTAL_CHECKED + 1))

    if command -v "$name" >/dev/null 2>&1; then
        TOTAL_OK=$((TOTAL_OK + 1))
        printf "  %b[ok]%b   %-30s -> %s\n" "$CLR_GREEN" "$CLR_RESET" "$label" "$(command -v "$name")"
    else
        if [ "$optional" -eq 1 ]; then
            TOTAL_OPTIONAL=$((TOTAL_OPTIONAL + 1))
            printf "  %b[opt]%b  %-30s (optional, not found)\n" "$CLR_YELLOW" "$CLR_RESET" "$label"
        else
            TOTAL_MISSING=$((TOTAL_MISSING + 1))
            printf "  %b[miss]%b %-30s (missing)\n" "$CLR_RED" "$CLR_RESET" "$label"
        fi
    fi
}

log_banner "Dotfiles Environment Health Check"
printf "Repo:       %s\n" "$REPO_DIR"
printf "Config dir: %s\n" "$CONFIG_DIR"

log_step "Core Repository Components"
for dir in $COMPONENTS; do
    TOTAL_CHECKED=$((TOTAL_CHECKED + 1))
    if [ -e "$REPO_DIR/$dir" ]; then
        TOTAL_OK=$((TOTAL_OK + 1))
        printf "  %b[ok]%b   repo/%s\n" "$CLR_GREEN" "$CLR_RESET" "$dir"
    else
        TOTAL_MISSING=$((TOTAL_MISSING + 1))
        printf "  %b[miss]%b repo/%s\n" "$CLR_RED" "$CLR_RESET" "$dir"
    fi
done

log_step "Core Terminal Stack"
check_bin hx "helix (editor)"
check_bin fish "fish (shell)"
check_bin zellij "zellij (multiplexer)"
check_bin alacritty "alacritty (terminal)"
check_bin git "git (vcs)"

log_step "CLI & Navigation Helpers"
check_bin eza "eza (modern ls)"
check_bin fzf "fzf (fuzzy finder)"
check_bin fd "fd (directory search)"
check_bin bat "bat (preview pager)"
check_bin zoxide "zoxide (directory jump)"
check_bin sudo "sudo (privilege elevation)" 1

log_step "Media Tools (Fish Wrappers)"
check_bin ffmpeg "ffmpeg (video processing)"
check_bin ffprobe "ffprobe (media metadata)"
check_bin magick "imagemagick (image convert)"

log_step "Helix Language Servers & Formatters"
check_bin deno "deno (TS/JS LSP & formatter)"
check_bin phpactor "phpactor (PHP LSP)"
check_bin ruby-lsp "ruby-lsp (Ruby LSP)"
check_bin solargraph "solargraph (Ruby fallback)" 1
check_bin rubocop "rubocop (Ruby linter)" 1
check_bin gopls "gopls (Go LSP)" 1
check_bin goimports "goimports (Go formatter)" 1
check_bin rust-analyzer "rust-analyzer (Rust LSP)" 1
check_bin rustfmt "rustfmt (Rust formatter)" 1
check_bin basedpyright-langserver "basedpyright (Python LSP)" 1
check_bin ruff "ruff (Python formatter/LSP)" 1
check_bin lua-language-server "lua-language-server (Lua LSP)" 1
check_bin stylua "stylua (Lua formatter)" 1
check_bin tailwindcss-language-server "tailwindcss-ls (Tailwind)" 1
check_bin vscode-html-language-server "vscode-html-ls (HTML)" 1
check_bin vscode-css-language-server "vscode-css-ls (CSS/SCSS)" 1
check_bin vscode-json-language-server "vscode-json-ls (JSON)" 1

log_step "Config Targets in ~/.config"
for dir in $COMPONENTS; do
    TOTAL_CHECKED=$((TOTAL_CHECKED + 1))
    if [ -e "$CONFIG_DIR/$dir" ] || [ -L "$CONFIG_DIR/$dir" ]; then
        TOTAL_OK=$((TOTAL_OK + 1))
        printf "  %b[ok]%b   %s/%s\n" "$CLR_GREEN" "$CLR_RESET" "$CONFIG_DIR" "$dir"
    else
        TOTAL_MISSING=$((TOTAL_MISSING + 1))
        printf "  %b[miss]%b %s/%s\n" "$CLR_RED" "$CLR_RESET" "$CONFIG_DIR" "$dir"
    fi
done

log_step "Configuration Syntax Validation"
if command -v python3 >/dev/null 2>&1; then
    python3 - <<PY
import pathlib, tomllib
repo = pathlib.Path(r'''$REPO_DIR''')
files = [
    repo / 'helix' / 'config.toml',
    repo / 'helix' / 'languages.toml',
    repo / 'alacritty' / 'alacritty.toml',
]
for path in files:
    tomllib.loads(path.read_text())
    print(f'  \033[38;2;66;190;101m[ok]\033[0m   toml {path.relative_to(repo)}')
PY
fi

if command -v fish >/dev/null 2>&1; then
    fish -n "$REPO_DIR/fish/config.fish"
    printf "  %b[ok]%b   fish syntax (config.fish)\n" "$CLR_GREEN" "$CLR_RESET"
    for f in "$REPO_DIR/fish/functions"/*.fish; do
        fish -n "$f"
    done
    printf "  %b[ok]%b   fish syntax (%d functions)\n" "$CLR_GREEN" "$CLR_RESET" "$(find "$REPO_DIR/fish/functions" -name '*.fish' | wc -l)"
    for c in "$REPO_DIR/fish/completions"/*.fish; do
        fish -n "$c"
    done
    printf "  %b[ok]%b   fish syntax (%d completions)\n" "$CLR_GREEN" "$CLR_RESET" "$(find "$REPO_DIR/fish/completions" -name '*.fish' | wc -l)"
fi

if command -v zellij >/dev/null 2>&1; then
    ZELLIJ_CONFIG_DIR="$REPO_DIR/zellij" zellij setup --check >/dev/null
    printf "  %b[ok]%b   zellij config\n" "$CLR_GREEN" "$CLR_RESET"
fi

printf "\n%b==================================================%b\n" "$CLR_GRAY" "$CLR_RESET"
printf "Summary: %d checked | %d ok | %d missing | %d optional\n" \
    "$TOTAL_CHECKED" "$TOTAL_OK" "$TOTAL_MISSING" "$TOTAL_OPTIONAL"
printf "%b==================================================%b\n" "$CLR_GRAY" "$CLR_RESET"

if [ "$TOTAL_MISSING" -gt 0 ]; then
    log_warn "Some required dependencies are missing. Run 'bash scripts/bootstrap.sh' to install them."
    exit 1
fi
