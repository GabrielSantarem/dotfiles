#!/usr/bin/env sh
set -eu

REPO_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
CONFIG_DIR="$HOME/.config"

mkdir -p "$CONFIG_DIR/helix" "$CONFIG_DIR/fish" "$CONFIG_DIR/zellij" "$CONFIG_DIR/alacritty"

rm -rf "$CONFIG_DIR/helix"
rm -rf "$CONFIG_DIR/fish"
rm -rf "$CONFIG_DIR/zellij"
rm -rf "$CONFIG_DIR/alacritty"

cp -a "$REPO_DIR/helix" "$CONFIG_DIR/helix"
cp -a "$REPO_DIR/fish" "$CONFIG_DIR/fish"
cp -a "$REPO_DIR/zellij" "$CONFIG_DIR/zellij"
cp -a "$REPO_DIR/alacritty" "$CONFIG_DIR/alacritty"

printf 'Installed configs into %s\n' "$CONFIG_DIR"
