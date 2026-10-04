# Helix Editor

[Helix](https://helix-editor.com/) is a post-modern modal text editor written in Rust. It serves as the primary editor in TF (Terminal Forever), configured to deliver a battery-included, lightweight IDE experience without external plugins.

---

## Highlights

- **Custom Carbon Green Theme**: Clean contrast with `#42be65` accents, plus bundled Catppuccin Soft Blue and Soft Yellow variants.
- **Battery-Included LSPs**: Native Tree-sitter syntax trees, LSP diagnostics, signature help, and inlay hints.
- **Full Deno TypeScript/JS Engine**: Native `deno lsp` with inline type hints, linting, and `deno fmt`.
- **Comprehensive Polyglot Tooling**: Pre-configured language servers and formatters for Go, Rust, Python, PHP, Ruby, Tailwind CSS, HTML/SCSS, JSON, and Lua.
- **Safe Editing**: Auto-format on save, auto-save on focus loss, and system clipboard yank (`+` register) by default.

---

## Keybindings Reference

### Normal Mode

| Keybinding | Action |
| :--- | :--- |
| `Ctrl-s` | Save current buffer |
| `Ctrl-q` | Close current view / window |
| `Ctrl-Shift-q` | Force quit all views |
| `Ctrl-r` | Reload Helix configuration |
| `Ctrl-Space` | Trigger completion popup |
| `Ctrl-h` | Navigate to left window split |
| `Ctrl-j` | Navigate to lower window split |
| `Ctrl-k` | Navigate to upper window split |
| `Ctrl-l` | Navigate to right window split |
| `Alt-j` | Shift current line down |
| `Alt-k` | Shift current line up |
| `Ctrl-,` | Switch to previous buffer |
| `Ctrl-.` | Switch to next buffer |

### Space Leader Menu (`Space`)

| Keybinding | Action |
| :--- | :--- |
| `Space w` | Write / save buffer |
| `Space q` | Quit buffer |
| `Space b` | Buffer picker |
| `Space f` | File picker (fzf/fd style) |
| `Space /` | Global regex search across workspace |
| `Space r` | Live reload config |

---

## Language Support Matrix

| Language | Primary LSP | Formatter | Notes |
| :--- | :--- | :--- | :--- |
| **TypeScript / JS** | `deno lsp` | `deno fmt` | Rich inlay hints for parameter names & return types |
| **JSX / TSX** | `deno lsp`, `tailwindcss-ls` | `deno fmt` | Full Tailwind class completion & linting |
| **HTML / CSS** | `vscode-html-ls`, `vscode-css-ls` | `deno fmt` | Tailwind class autocompletion |
| **Go** | `gopls` | `goimports` | Automatic imports and struct analysis hints |
| **Rust** | `rust-analyzer` | `rustfmt` | Clippy checks on save and type hints |
| **Python** | `basedpyright`, `ruff` | `ruff format` | Fast linting, imports, and strict type checking |
| **PHP** | `phpactor` | `phpactor` | Installed via `~/.local/bin/phpactor` |
| **Ruby** | `ruby-lsp` | `rubocop` | Modern Shopify LSP with Solargraph fallback |
| **Lua** | `lua-language-server` | `stylua` | Standard Lua engine |

---

## Configuration Files

Helix configuration is stored in two files:
- `helix/config.toml`: Editor UX, gutter, statusline, themes, and keymaps.
- `helix/languages.toml`: LSP binaries, arguments, formatting rules, and roots.
