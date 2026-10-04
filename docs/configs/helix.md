# Helix Configuration Reference

Helix configurations are located in `helix/config.toml` and `helix/languages.toml`.

---

## `helix/config.toml` Key Settings

```toml
theme = "carbon-green"

[editor]
line-number = "relative"
cursorline = true
mouse = true
bufferline = "multiple"
true-color = true
color-modes = true

[editor.cursor-shape]
insert = "bar"
normal = "block"
select = "underline"

[editor.auto-save]
focus-lost = true
after-delay.enable = true
after-delay.timeout = 3000

[editor.lsp]
display-messages = true
auto-signature-help = true
display-inlay-hints = true
snippets = true

[editor.indent-guides]
render = true
character = "│"
skip-levels = 1
```

---

## `helix/languages.toml` LSP Definitions

### Deno (TypeScript / JavaScript)
```toml
[language-server.deno-lsp]
command = "deno"
args = ["lsp"]

[language-server.deno-lsp.config.deno]
enable = true
lint = true
unstable = true
suggest.imports.hosts = { "https://deno.land" = true }
inlayHints.parameterNames.enabled = "all"
inlayHints.variableTypes.enabled = true
inlayHints.functionLikeReturnTypes.enabled = true
```

### Python (BasedPyright & Ruff)
```toml
[language-server.basedpyright]
command = "basedpyright-langserver"
args = ["--stdio"]

[language-server.ruff]
command = "ruff"
args = ["server"]
```

### Go & Rust
```toml
[language-server.gopls]
command = "gopls"

[language-server.rust-analyzer]
command = "rust-analyzer"
[language-server.rust-analyzer.config.check]
command = "clippy"
```
