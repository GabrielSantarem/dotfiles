# Helix IDE Config

[![Helix](https://img.shields.io/badge/Helix-25.07+-6a9fb5?style=for-the-badge)](https://helix-editor.com/)
[![Theme](https://img.shields.io/badge/Theme-carbon--green-42be65?style=for-the-badge)](#theme)
[![LSP](https://img.shields.io/badge/LSP-enabled-78dba9?style=for-the-badge)](#language-support)
[![Format%20on%20Save](https://img.shields.io/badge/Format%20on%20Save-enabled-3cb371?style=for-the-badge)](#editor-features)
[![Status](https://img.shields.io/badge/Backup-ready-blue?style=for-the-badge)](#installation)

A personal Helix configuration backup focused on turning Helix into a fast, clean, lightweight IDE with better UX, LSP support, formatting, and language-specific tooling.

---

## Preview

This setup includes:

- a custom `carbon-green` theme inheriting from `carbon`
- additional Catppuccin-based custom themes with soft yellow and blue accents
- stronger editor UX defaults
- autosave and auto-format
- LSP hints, diagnostics, signature help, and completion
- language setup for Go, Rust, Python, JavaScript/TypeScript, and Lua
- practical keybindings for daily editing

---

## Repository structure

```text
.
├── README.md
├── config.toml
├── languages.toml
└── themes/
    ├── carbon-green.toml
    ├── catppuccin-soft-blue.toml
    └── catppuccin-soft-yellow.toml
```

---

## Included files

| File | Purpose |
| --- | --- |
| `config.toml` | Core editor UI, UX, keybindings, autosave, LSP behavior |
| `languages.toml` | Language servers, formatters, and per-language setup |
| `themes/carbon-green.toml` | Custom theme inheriting from `carbon` with green accents |
| `themes/catppuccin-soft-yellow.toml` | Catppuccin Mocha variant with soft yellow accents |
| `themes/catppuccin-soft-blue.toml` | Catppuccin Mocha variant with soft blue accents |

---

## Editor features

### UX and interface

- Relative line numbers
- Mouse support enabled
- System clipboard as the default yank register (`+`)
- Cursor line highlight
- Buffer line for multiple open buffers
- True color enabled
- End-of-line diagnostics as hints
- Custom statusline layout
- Visible indent guides
- Visible tabs and non-breaking spaces

### Editing behavior

- Auto-save on focus loss
- Auto-save after a short delay
- Auto-format on save
- Fast auto-completion popup
- Path completion enabled
- Completion preview while navigating suggestions
- Completion trigger from a single character

### LSP behavior

- LSP enabled globally
- Signature help enabled
- Inlay hints enabled
- LSP progress/messages enabled
- Snippet support enabled
- Inline diagnostics on cursor line

---

## Theme

The default active theme is `carbon-green`.

Additional bundled themes:

- `catppuccin-soft-yellow`
- `catppuccin-soft-blue`

`carbon-green` inherits from the built-in `carbon` theme and overrides a few visual details with green accents instead of replacing the entire palette.

The Catppuccin variants inherit from `catppuccin_mocha` and keep the same dark base while shifting interface accents toward softer yellow or blue tones.

### Customized theme details

- current line highlight
- selection color
- active line number
- statusline colors by mode
- active bufferline entry
- popup and help background
- selected menu item
- focused text color
- inlay hints
- hint diagnostics
- `diff.plus`
- selected syntax scopes such as:
  - `keyword`
  - `attribute`
  - `tag`
  - `constructor`

---

## Keybindings

### Normal mode

| Key | Action |
| --- | --- |
| `Ctrl-s` | Save file |
| `Ctrl-q` | Quit current view |
| `Ctrl-Shift-q` | Force quit all |
| `Ctrl-r` | Reload Helix config |
| `Ctrl-Space` | Trigger completion |
| `Ctrl-h` | Move to left split |
| `Ctrl-j` | Move to split below |
| `Ctrl-k` | Move to split above |
| `Ctrl-l` | Move to right split |
| `Alt-j` | Move current line down |
| `Alt-k` | Move current line up |
| `Ctrl-,` | Previous buffer |
| `Ctrl-.` | Next buffer |

### Space menu

| Key | Action |
| --- | --- |
| `Space w` | Save |
| `Space q` | Quit |
| `Space b` | Close buffer |
| `Space r` | Reload config |

### Insert / Select mode

| Key | Action |
| --- | --- |
| `Ctrl-Space` | Trigger completion |

---

## Language support

| Language | LSP | Formatter | Notes |
| --- | --- | --- | --- |
| Go | `gopls` | `goimports` | extra hints and analyses enabled |
| Rust | `rust-analyzer` | `rustfmt` | `clippy` checks, rich inlay hints |
| Python | `basedpyright`, `ruff` | `ruff format` | explicit LSP setup in `languages.toml` |
| JavaScript | `typescript-language-server` | `deno fmt` | formatter configured explicitly |
| TypeScript | `typescript-language-server` | `deno fmt` | works for `ts`, `tsx`, `jsx`, `json` too |
| Lua | `lua-language-server` | `stylua` | simple and reliable setup |

---

## Language-specific details

### Go

- `gopls` enabled
- `goimports` used as formatter
- extra inlay hints and analyses configured

### Rust

- `rust-analyzer` enabled
- `rustfmt` used as formatter
- `cargo.allFeatures = true`
- `clippy` used for checks
- extended inlay hints enabled

### Python

- `basedpyright-langserver --stdio`
- `ruff server`
- `ruff format -` as formatter
- `typeCheckingMode = "standard"`
- `autoImportCompletions = true`

### JavaScript / TypeScript / JSX / TSX / JSON

- `typescript-language-server` available on `PATH`
- `deno fmt -` used as formatter

### Lua

- `lua-language-server` enabled
- `stylua -` used as formatter

---

## Verified tools

The following tools were available and detected when this backup was created:

- `typescript-language-server`
- `basedpyright-langserver`
- `ruff`
- `lua-language-server`
- `stylua`

### Health checks

Previously validated with:

- `hx --health python` ✅
- `hx --health lua` ✅
- `hx --health javascript` ✅

> Note: JavaScript health may still show a missing debug adapter. That does **not** affect LSP, completion, diagnostics, or formatting.

---

## Installation

### 1. Install Helix

Make sure `hx` is installed and available in your `PATH`.

### 2. Copy this config into `~/.config/helix`

If this repository is already cloned locally:

```sh
mkdir -p ~/.config/helix
cp config.toml ~/.config/helix/config.toml
cp languages.toml ~/.config/helix/languages.toml
mkdir -p ~/.config/helix/themes
cp themes/carbon-green.toml ~/.config/helix/themes/carbon-green.toml
cp themes/catppuccin-soft-yellow.toml ~/.config/helix/themes/catppuccin-soft-yellow.toml
cp themes/catppuccin-soft-blue.toml ~/.config/helix/themes/catppuccin-soft-blue.toml
```

Or copy the full directory contents:

```sh
mkdir -p ~/.config/helix
cp -r ./* ~/.config/helix/
```

### 3. Reload Helix

Inside Helix:

```text
:config-reload
```

Or simply restart the editor.

### Switching themes

Inside Helix:

```text
:theme carbon-green
:theme catppuccin-soft-yellow
:theme catppuccin-soft-blue
```

---

## Required external tools

Install the tools you actually use for your languages.

### Core tools referenced by this config

```sh
gopls
goimports
rust-analyzer
rustfmt
basedpyright
ruff
typescript-language-server
deno
lua-language-server
stylua
```

---

## Validate the setup

Run Helix health checks:

```sh
hx --health go
hx --health rust
hx --health python
hx --health javascript
hx --health lua
```

---

## Shell commands inside Helix

Helix can run shell commands, but it does **not** provide a persistent integrated terminal.

### Useful built-ins

- `:sh <command>` — run a shell command and show its output in a popup
- `!` — insert command output into the buffer
- `Alt-!` — append command output after selection
- `|` — pipe selection through a command and replace it with the result
- `Alt-|` — pipe selection to a command and ignore output

### Recommendation

For long-running commands such as:

- `go test`
- `cargo check`
- `npm run build`
- `pytest`

an external terminal, `tmux`, or `zellij` is still the best workflow.

---

## Backup and restore

### Create a backup repository

```sh
git init
git add .
git commit -m "Add Helix IDE config backup"
```

Then push it to your own Git repository.

### Restore on another machine

1. clone the repository
2. copy the files into `~/.config/helix`
3. install the required external tools
4. run `hx --health <language>` to verify everything

---

## Notes

This setup aims to stay:

- minimal
- fast
- practical
- close to stock Helix behavior

while still giving a more IDE-like experience for daily development.

---

## License

Use, modify, and adapt freely for your own setup.
