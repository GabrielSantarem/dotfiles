# Zellij Configuration Reference

Located in `zellij/config.kdl` and `zellij/layouts/default.kdl`.

---

## `zellij/config.kdl` Key Settings

```kdl
default_mode "locked"
default_layout "default"
simplified_ui true
pane_frames false
session_serialization false

themes {
    carbon_green {
        fg "#d7dce2"
        bg "#0f1115"
        black "#1a1d23"
        red "#ff7b72"
        green "#42be65"
        yellow "#f2cc60"
        blue "#78dba9"
        magenta "#b392f0"
        cyan "#56b6c2"
        white "#f0f6fc"
        orange "#f0883e"
    }
}
theme "carbon_green"
```

---

## Floating Terminal Keybinding

```kdl
keybinds {
    locked {
        bind "Alt f" { ToggleFloatingPanes; }
        bind "Ctrl g" { SwitchToMode "Normal"; }
        bind "Ctrl s" { SwitchToMode "Scroll"; }
    }
}
```
