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
- battery-included Deno setup (`deno-lsp` + `deno fmt`) for TypeScript and JavaScript
- language setup for Go, Rust, Python, PHP (Phpactor), Ruby, TypeScript/JavaScript/JSX/TSX, HTML/CSS/SCSS, JSON, and Lua
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
| PHP | `phpactor` | `phpactor` | configured with `language-server` command |
| Ruby | `ruby-lsp`, `solargraph` | LSP format (`rubocop`) | modern Shopify `ruby-lsp` integration |
| JavaScript / TypeScript | `deno-lsp` | `deno fmt` | native Deno LSP with rich inlay hints & linting |
| JSX / TSX | `deno-lsp`, `tailwindcss-ls` | `deno fmt` | full Deno + Tailwind CSS support |
| HTML | `vscode-html-language-server`, `tailwindcss-ls` | `deno fmt` | template and class completion |
| CSS / SCSS | `vscode-css-language-server`, `tailwindcss-ls` | `deno fmt` | style linting and utility completion |
| JSON | `vscode-json-language-server` | `deno fmt` | schema validation and auto-format |
| Lua | `lua-language-server` | `stylua` | simple and reliable setup |

---

## Language-specific details

### JavaScript / TypeScript / JSX / TSX (Deno)

- `deno-lsp` (`deno lsp`) enabled as the unified language server with:
  - linting enabled (`deno lint`)
  - inlay hints for parameter names, variable types, function returns, and enum values
  - auto-import completion suggestions
- `tailwindcss-language-server` attached to JSX and TSX
- `deno fmt -` used as the fast, built-in formatter

### PHP (Phpactor)

- `phpactor` configured as the primary LSP (`phpactor language-server`)
- auto-format on save enabled
- standalone binary installed in `~/.local/bin/phpactor`

### Ruby

- `ruby-lsp` enabled as primary language server
- `solargraph` fallback available
- automatic formatting using project RuboCop through `ruby-lsp`

### HTML / CSS / SCSS

- `vscode-html-language-server` and `vscode-css-language-server` enabled
- `tailwindcss-language-server` attached for Tailwind utility classes
- `deno fmt` used for clean, reliable formatting

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
- `typeCheckingMode = \"standard\"`
- `autoImportCompletions = true`

### Lua

- `lua-language-server` enabled
- `stylua -` used as formatter

---

## Installation

### 1. Install configs using repository script

Run from repo root:

```sh
bash scripts/install.sh
```

### 2. Validate environment

```sh
bash scripts/doctor.sh
```
