# Modern TUI Suite

The Modern TUI (Terminal User Interface) suite in TF replaces heavy graphical applications with lightweight, keyboard-driven alternatives written in Rust and Go.

---

## Tool Overview

| Category | Tool | Binary | Alias | Description |
| :--- | :--- | :--- | :--- | :--- |
| **Git Client** | [lazygit](git.md) | `lazygit` | `lg` | Full terminal Git interface with visual hunk staging |
| **Diff Pager** | [delta](git.md) | `delta` | - | Syntax-highlighted side-by-side git diffs |
| **File Manager** | [yazi](files.md) | `yazi` | `y` | High-speed async file manager with auto-cd wrapper |
| **Disk Analyzer** | [dust](files.md) | `dust` | `du` | Visual tree of disk utilization |
| **System Monitor**| [bottom](utils.md) | `btm` | - | Minimalist real-time resource monitor |
| **Search & Replace**| [serpl](utils.md) | `serpl` | `sr` | Interactive regex search & replace across codebase |
| **HTTP Client** | [xh](utils.md) | `xh` | - | Ergonomic, colorized curl replacement |
| **Containers** | [lazydocker](utils.md) | `lazydocker` | `ld` | Docker and Podman container management |

All tools are declared in [`mise.toml`](../../mise.toml) and verified via `dotfiles doctor`.
