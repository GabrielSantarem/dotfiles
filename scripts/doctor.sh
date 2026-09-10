#!/usr/bin/env sh
set -eu

REPO_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
CONFIG_DIR=${XDG_CONFIG_HOME:-"$HOME/.config"}

check_bin() {
    name=$1
    if command -v "$name" >/dev/null 2>&1; then
        printf '[ok]   %s -> %s\n' "$name" "$(command -v "$name")"
    else
        printf '[miss] %s\n' "$name"
    fi
}

printf 'Repo: %s\n' "$REPO_DIR"
printf 'Config dir: %s\n\n' "$CONFIG_DIR"

for dir in helix fish zellij alacritty; do
    if [ -e "$REPO_DIR/$dir" ]; then
        printf '[ok]   repo/%s\n' "$dir"
    else
        printf '[miss] repo/%s\n' "$dir"
    fi
done

printf '\nBinaries\n'
check_bin hx
check_bin fish
check_bin zellij
check_bin alacritty
check_bin git
check_bin python3

printf '\nConfig targets\n'
for dir in helix fish zellij alacritty; do
    if [ -e "$CONFIG_DIR/$dir" ] || [ -L "$CONFIG_DIR/$dir" ]; then
        printf '[ok]   %s/%s\n' "$CONFIG_DIR" "$dir"
    else
        printf '[miss] %s/%s\n' "$CONFIG_DIR" "$dir"
    fi
done

printf '\nValidation\n'
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
    print(f'[ok]   toml {path.relative_to(repo)}')
PY
fi

if command -v fish >/dev/null 2>&1; then
    fish -n "$REPO_DIR/fish/config.fish"
    printf '[ok]   fish syntax\n'
fi

if command -v zellij >/dev/null 2>&1; then
    ZELLIJ_CONFIG_DIR="$REPO_DIR/zellij" zellij setup --check >/dev/null
    printf '[ok]   zellij config\n'
fi
