# Zellij Multiplexer

[Zellij](https://zellij.dev/) is a modern terminal workspace multiplexer written in Rust. In TF (Terminal Forever), Zellij orchestrates multiple terminal sessions, workspace tabs, and floating scratchpads without colliding with editor keybindings.

---

## Highlights

- **App-First Workflow (`locked` mode default)**: Starts in `locked` mode so all keystrokes pass directly to Helix and terminal applications. Entering Zellij control requires `Ctrl-g`.
- **Maximized Screen Real Estate**: Pane frames are disabled (`pane_frames false`) to avoid wasting character rows on borders.
- **Instant Floating Terminal**: Press `Alt-f` anywhere to toggle a floating terminal popup over your code, run quick commands, and dismiss it with `Alt-f` or `Esc`.
- **Carbon Green High-Contrast Theme**: Matches Alacritty's `#0f1115` base and `#42be65` green accents with flat `simplified_ui` blocks (no bulky Powerline arrows).
- **Synchronized Tab Mode**: Broadcast keyboard input across all panes in a tab simultaneously with `Ctrl-g` → `t` → `s`.

---

## Core Keybindings

### Global (Locked Mode)

| Keybinding | Action |
| :--- | :--- |
| `Ctrl-g` | Unlock Zellij control mode (`normal`) |
| `Alt-f` | Toggle floating terminal popup |
| `Ctrl-s` | Enter scrollback / search mode directly |

### Control Mode (`Ctrl-g`)

Once in normal mode:

| Key | Mode / Action |
| :--- | :--- |
| `p` | Enter **Pane Mode** (split, focus, close, fullscreen) |
| `t` | Enter **Tab Mode** (new tab, switch tabs, sync panes) |
| `s` | Enter **Scroll Mode** (search, scrollback inspection) |
| `r` | Enter **Resize Mode** (expand/shrink panes) |
| `n` | Create a new pane |
| `f` | Toggle fullscreen on current pane |
| `Ctrl-g` / `Enter` / `Esc` | Return to locked mode |

### Pane Management (`Ctrl-g` → `p`)

| Key | Action |
| :--- | :--- |
| `h` / `j` / `k` / `l` | Move focus left / down / up / right |
| `d` | Split pane vertically (down) |
| `r` | Split pane horizontally (right) |
| `f` | Fullscreen focused pane |
| `x` | Close focused pane |

### Tab Management (`Ctrl-g` → `t`)

| Key | Action |
| :--- | :--- |
| `n` | Create new tab |
| `h` / `l` | Switch to previous / next tab |
| `1` .. `9` | Jump directly to tab number |
| `s` | Toggle pane input synchronization (Sync Tab) |
| `x` | Close active tab |

---

## Project Workflow (`proj`)

When using the `proj` function:
- **Default**: Opens a fresh tab in the project directory with your default shell.
- **Auto-Helix**: Set `export ENABLE_AUTO_HX=1` (or run `proj --hx`) to open the project directly inside a full-tab Helix session (`hx .`). Exiting Helix automatically closes the tab.
