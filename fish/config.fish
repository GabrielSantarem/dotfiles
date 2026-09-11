# ~/.config/fish/config.fish
# Personal Fish configuration

# -----------------------------
# Environment
# -----------------------------
set -gx SYSTEMD_PAGER ""
set -gx EDITOR "/usr/bin/nvim"
set -Ux ADB_MDNS 0

# Android SDK
set -gx ANDROID_HOME "$HOME/Android/Sdk"
set -gx NDK_HOME "$ANDROID_HOME/ndk/26.1.10909125"

# -----------------------------
# PATH
# -----------------------------
fish_add_path --move --path \
    "$HOME/.local/bin" \
    "$HOME/bin" \
    "$HOME/.cargo/bin" \
    "$ANDROID_HOME/emulator" \
    "$ANDROID_HOME/platform-tools" \
    "$ANDROID_HOME/cmdline-tools/latest/bin"

# -----------------------------
# Optional compatibility loader
# -----------------------------
# Loads plain shell snippets from ~/.bashrc.d when they are compatible with Fish.
if test -d ~/.bashrc.d
    for rc in ~/.bashrc.d/*
        if test -f "$rc"
            source "$rc"
        end
    end
end
set -e rc

# -----------------------------
# Tool initialization
# -----------------------------
if type -q mise
    mise activate fish | source
end

if type -q zoxide
    zoxide init fish | source
end

# Starship disabled in favor of a native ultra-minimal Fish prompt.

# -----------------------------
# Zellij auto-start
# -----------------------------
# Start a fresh Zellij session (clean panes, no old context) in interactive
# local terminals. The `proj` layout opens straight into the project picker.
# Accidentally closed terminals leave a detached session you can recover
# manually with `zellij list-sessions` + `zellij attach <name>`.
# Set DISABLE_AUTO_ZELLIJ=1 to launch a plain Fish shell without Zellij.
if status is-interactive
    and type -q zellij
    and not set -q ZELLIJ
    and not set -q SSH_CONNECTION
    and not set -q SSH_TTY
    and test "$TERM" != "dumb"
    and not set -q fish_private_mode
    and not set -q DISABLE_AUTO_ZELLIJ
    and test (count $argv) -eq 0
    zellij --new-session-with-layout proj
end

# -----------------------------
# Aliases
# -----------------------------
if type -q eza
    alias ls 'eza --icons --group-directories-first'
    alias ll 'eza -l --icons --git'
end

if type -q bat
    alias cat 'bat'
end

if type -q rg
    alias grep 'rg'
end

if type -q fd
    alias find 'fd'
end
