# TF — Terminal Forever

A personal terminal setup pre-configured around Helix, Fish, Zellij, Alacritty, and a few handy TUIs and aliases.

---

## What is this?

**TF (Terminal Forever)** is a personal collection of configurations for people who enjoy doing things directly from the command line.

It's not an anti-GUI manifesto or a product to sell—it's just a cohesive, fun setup where:
- The terminal looks consistent across all tools.
- The editor ([Helix](core/helix.md)) comes with language servers and formatters pre-configured.
- The shell ([Fish](core/fish.md)) has useful aliases and functions for daily work.
- The multiplexer ([Zellij](core/zellij.md)) gives you tabs and floating terminals without clutter.
- Common tasks like Git staging ([lazygit](tui/git.md)), file browsing ([yazi](tui/files.md)), and disk checks ([dust](tui/files.md)) have quick aliases.

```text
┌─────────────────────────────────────────────────────────────┐
│ Alacritty (Terminal)                                        │
│   ┌───────────────────────────────────────────────────────┐ │
│   │ Zellij (Tabs & Splits)                                │ │
│   │   ┌──────────────────────┐  ┌───────────────────────┐ │ │
│   │   │ Helix (Editor)       │  │ Fish (Shell)          │ │ │
│   │   │ LSPs & Treesitter    │  │ Aliases & TUIs        │ │ │
│   │   └──────────────────────┘  └───────────────────────┘ │ │
│   └───────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## The Stack

| Component | Tool | Purpose |
| :--- | :--- | :--- |
| **Terminal** | [Alacritty](core/alacritty.md) | Clean, GPU-accelerated terminal |
| **Multiplexer** | [Zellij](core/zellij.md) | Tabs, splits, and floating terminals |
| **Editor** | [Helix](core/helix.md) | Modal editor with built-in LSP & Tree-sitter |
| **Shell** | [Fish](core/fish.md) | Clean interactive shell with custom functions |
| **Tool Manager**| [Mise](quickstart.md) | Manages language runtimes and tool binaries |
| **Git** | [Lazygit](tui/git.md) | Visual staging and rebase interface |
| **Diffs** | [Delta](tui/git.md) | Syntax-highlighted git diffs |
| **Files** | [Yazi](tui/files.md) | Fast terminal file manager with auto-cd |
| **Monitor** | [Bottom](tui/utils.md) | Graphical terminal system monitor |
| **Disk** | [Dust](tui/files.md) | Tree view of disk usage |
| **Search** | [Serpl](tui/utils.md) | Interactive search & replace |
| **HTTP** | [xh](tui/utils.md) | Fast, friendly curl replacement |
| **Docker** | [Lazydocker](tui/utils.md) | Terminal UI for containers |

---

## Where to start?

- Read [About TF](about.md) for more context on the setup.
- Check the [Quick Start](quickstart.md) to set it up on a machine.
- Explore the [CLI Guide](cli.md) to see how `dotfiles doctor`, `test`, `install`, and `diff` work.
