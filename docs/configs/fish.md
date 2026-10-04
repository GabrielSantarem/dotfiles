# Fish Configuration Reference

Fish configurations are modularized across `fish/config.fish`, `fish/conf.d/aliases.fish`, and `fish/functions/`.

---

## `fish/config.fish`

```fish
# Disable default greeting
set -g fish_greeting ""

# Ensure user binaries are in PATH
fish_add_path ~/.local/bin
fish_add_path ~/.local/share/mise/shims

# Auto-start Zellij on interactive local shells
if status is-interactive
    and not set -q ZELLIJ
    and not set -q SSH_CONNECTION
    and test "$TERM" != "dumb"
    and not set -q DISABLE_AUTO_ZELLIJ

    if test "$ENABLE_AUTO_PROJ" = "1" -o "$AUTO_PROJ" = "1"
        exec zellij --new-session-with-layout proj
    else
        exec zellij --new-session-with-layout default
    end
end
```

---

## `fish/conf.d/aliases.fish` (Excerpt)

```fish
# Navigation
if type -q eza
    alias la 'eza -la --icons --git --group-directories-first'
    alias lt 'eza --tree --level=2 --icons --group-directories-first'
    alias tree 'eza --tree --icons --group-directories-first'
end

# Git
if type -q git
    alias g 'git'
    alias gs 'git status -sb'
    alias ga 'git add'
    alias gc 'git commit'
    alias gd 'git diff'
    alias gp 'git push'
    alias gpl 'git pull'
end

# Modern TUIs
if type -q lazygit; alias lg 'lazygit'; end
if type -q dust; alias du 'dust'; end
if type -q lazydocker; alias ld 'lazydocker'; end
if type -q serpl; alias sr 'serpl'; end
```
