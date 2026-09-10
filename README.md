# Dotfiles Unified

A unified backup repository for my terminal/editor setup.

## Included configs

- `helix/`
- `fish/`
- `zellij/`
- `alacritty/`

## Scripts

### Install into `~/.config`

```sh
bash scripts/install.sh
```

Options:

```sh
bash scripts/install.sh --dry-run
bash scripts/install.sh --no-backup
bash scripts/install.sh --link
```

### Sync current local config back into this repo

```sh
bash scripts/sync-from-config.sh
bash scripts/sync-from-config.sh --dry-run
```

### Validate the repo and local environment

```sh
bash scripts/doctor.sh
```

## Notes

- Existing configs are backed up by default to `~/.local/state/dotfiles-unified/backups/`.
- `--link` is useful if you want this repo to become the live source of truth.
- `helix/` previously had its own Git repository; this unified repo keeps everything in one place.
- Copies are stored here without nested `.git` directories.
