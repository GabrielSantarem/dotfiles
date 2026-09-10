# Dotfiles Unified

A unified backup repository for my terminal/editor setup.

## Included configs

- `helix/`
- `fish/`
- `zellij/`
- `alacritty/`

## Install

```sh
bash scripts/install.sh
```

This will copy the configs into `~/.config`.

## Sync current local config back into this repo

```sh
bash scripts/sync-from-config.sh
```

## Notes

- `helix/` previously had its own Git repository; this unified repo keeps everything in one place.
- copies are plain files here, without nested `.git` directories.
