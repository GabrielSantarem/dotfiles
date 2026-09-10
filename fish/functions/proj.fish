function proj --description 'Jump to a project with zoxide and open it in Helix'
    if not type -q zoxide
        echo 'proj: zoxide is not installed'
        return 1
    end

    if not type -q hx
        echo 'proj: hx is not installed'
        return 1
    end

    set -l target
    if test (count $argv) -gt 0
        set target (zoxide query $argv 2>/dev/null)
    else if type -q fzf
        set target (zoxide query -l 2>/dev/null | fzf --preview 'if command -v eza >/dev/null 2>&1; then eza --tree --level=2 --icons --group-directories-first {}; else ls -la {}; fi' --preview-window 'right,60%,border-left')
    else
        set target (zoxide query -i 2>/dev/null)
    end

    if test -z "$target"
        return 1
    end

    cd -- "$target"
    and hx .
end
