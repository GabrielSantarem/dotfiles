# Configuration Reference

This section provides an annotated reference to the primary configuration files tracked in TF (Terminal Forever).

---

## Directory Architecture

```text
~/.config/
├── helix/
│   ├── config.toml           # Editor options, UI, keymaps, autosave
│   ├── languages.toml        # Language servers & formatters
│   └── themes/               # Carbon Green & Catppuccin themes
├── fish/
│   ├── config.fish           # Interactive shell initialization
│   ├── conf.d/
│   │   ├── aliases.fish      # Clean aliases (eza, git, TUIs, dev tools)
│   │   └── swiftly.fish      # Swift runtime environment setup
│   ├── functions/            # 22 modular shell functions
│   └── completions/          # Pre-generated shell completions
├── zellij/
│   ├── config.kdl            # Multiplexer bindings, Carbon Green theme
│   └── layouts/
│       ├── default.kdl       # Clean shell workspace layout
│       └── proj.kdl          # Project picker layout
├── alacritty/
│   └── alacritty.toml        # GPU terminal styling, fonts, and geometry
└── mise/
    └── config.toml           # Local user tool definitions
```

---

## Reference Chapters

- [Helix Configuration](helix.md)
- [Fish Configuration](fish.md)
- [Zellij Configuration](zellij.md)
- [Alacritty Configuration](alacritty.md)
