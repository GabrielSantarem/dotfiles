function fcd --description 'Fuzzy cd into a directory using fd and fzf with preview'
    if not type -q fd
        echo 'fcd: fd is not installed'
        return 1
    end

    if not type -q fzf
        echo 'fcd: fzf is not installed'
        return 1
    end

    set -l preview 'if command -v eza >/dev/null 2>&1; then eza --tree --level=2 --icons --group-directories-first {}; else ls -la {}; fi'
    set -l dir (fd --type d . $argv | fzf --preview "$preview" --preview-window 'right,60%,border-left')
    if test -n "$dir"
        cd -- "$dir"
    end
end
