# Alacritty Terminal

[Alacritty](https://alacritty.org/) is a fast, GPU-accelerated terminal emulator written in Rust. In TF (Terminal Forever), Alacritty provides the raw rendering engine: crisp typography, ultra-low latency, and a high-contrast dark color palette.

---

## Visual Design

- **Dark High-Contrast Base**: `#0f1115` provides deep black without harshness.
- **Crisp Text Foreground**: `#d7dce2` ensures maximum legibility during long coding sessions.
- **Carbon Green Accents**: `#42be65` for active cursors, text selections, and search match highlights.
- **Tight Geometry**: `6x6` padding maximizes usable character grid space with 100% opacity (`1.0`).

---

## Typography

Configured in `alacritty/alacritty.toml`:
- **Font Family**: `FiraCode Nerd Font` (with fallback to system monospace).
- **Font Size**: `11.0` pt with full ligature rendering enabled.

---

## Key Shortcuts

| Shortcut | Action |
| :--- | :--- |
| `Ctrl-Shift-C` | Copy selection to system clipboard |
| `Ctrl-Shift-V` | Paste from system clipboard |
| `Ctrl-Shift-N` | Spawn a new independent Alacritty window |
| `Ctrl-+` | Increase terminal font size |
| `Ctrl--` | Decrease terminal font size |
| `Ctrl-0` | Reset font size to default |

> **Note**: Alacritty intentionally does not include tabs or pane splits. In TF, all multiplexing, tabs, and workspace sessions are handled by [Zellij](zellij.md).
