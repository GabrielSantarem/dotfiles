# Fish Shell

The interactive shell in TF (Terminal Forever) is [Fish](https://fishshell.com/). Configured for zero-friction interaction, it provides instant auto-suggestions, smart history matching, lightweight modular aliases, and custom helper functions.

---

## Highlights

- **Ultra-Minimal Native Prompt**: Replaced heavy external prompts (like Starship) with an instantaneous native Fish prompt featuring a green `›` prompt marker and a red `!` only on failure.
- **Zellij Auto-Launch**: Starting an interactive local shell automatically launches a fresh Zellij session with clean layout isolation.
- **Smart Directory Traversal**: Integrated `y.fish` wrapper for Yazi that auto-changes your shell directory upon exiting.
- **Pre-generated Autocompletions**: Saved completions for `bat`, `deno`, `gh`, `rustup`, `zellij`, and `caddy`.

---

## Everyday Aliases

Defined in `fish/conf.d/aliases.fish`, active only when the underlying binary is installed:

### Navigation & Listing (`eza`)

| Alias | Command | Purpose |
| :--- | :--- | :--- |
| `ls` | `eza --icons --group-directories-first` | Clean directory listing |
| `ll` | `eza -la --icons --git --group-directories-first` | Full list with git status & permissions |
| `lt` | `eza --tree --level=2 --icons` | 2-level directory tree |
| `tree`| `eza --tree --icons` | Full recursive tree |

### Modern TUIs

| Alias | Command | Purpose |
| :--- | :--- | :--- |
| `y` | `yazi` (via `y.fish`) | File manager with auto-cd on exit |
| `lg` | `lazygit` | Interactive Git client |
| `du` | `dust` | Graphical disk space tree |
| `ld` | `lazydocker` | Container management TUI |
| `sr` | `serpl` | Search and replace TUI |

### Git Ergonomics

| Alias | Command | Purpose |
| :--- | :--- | :--- |
| `g` | `git` | Git shorthand |
| `gs` | `git status -sb` | Short status with branch info |
| `ga` | `git add` | Stage files |
| `gc` | `git commit` | Commit staged files |
| `gca`| `git commit --amend` | Amend last commit |
| `gl` | `git log --oneline --graph -20` | Compact log graph |
| `gd` | `git diff` | Diff changes |
| `gp` | `git push` | Push to remote |
| `gpl`| `git pull` | Pull from remote |

---

## Custom Shell Functions

Located in `fish/functions/`:

- **`y`**: Launches Yazi file manager. Captures current path upon quitting (`q`) so your shell `cd`s directly to where you navigated.
- **`mkcd <dir>`**: Creates directory and enters it immediately.
- **`ff`**: Fuzzy file search using `fzf` and `bat` preview.
- **`fcd`**: Fuzzy directory finder with auto-jump.
- **`proj`**: Project picker. Inside Zellij, opens a new workspace tab; outside, `cd`s to it.
- **`gitroot`**: Jumps straight to the root of the current Git repository.
- **`hxhere`**: Opens current directory in Helix editor.
- **`please`**: Re-runs the previous shell command with `sudo`.
- **`reloadfish`**: Instantly reloads all Fish configurations and functions.
