#!/usr/bin/env sh
set -eu

REPO_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
CONFIG_DIR="$HOME/.config"

rm -rf "$REPO_DIR/helix" "$REPO_DIR/fish" "$REPO_DIR/zellij" "$REPO_DIR/alacritty"

cp -a "$CONFIG_DIR/helix" "$REPO_DIR/helix"
cp -a "$CONFIG_DIR/fish" "$REPO_DIR/fish"
cp -a "$CONFIG_DIR/zellij" "$REPO_DIR/zellij"
cp -a "$CONFIG_DIR/alacritty" "$REPO_DIR/alacritty"

rm -rf "$REPO_DIR/helix/.git" "$REPO_DIR/fish/.git" "$REPO_DIR/zellij/.git" "$REPO_DIR/alacritty/.git"

printf 'Synced configs from %s into %s\n' "$CONFIG_DIR" "$REPO_DIR"
