function fcd --description 'Fuzzy cd into a directory using fd and fzf with preview'
    if not type -q fd
        echo 'fcd: fd is not installed'
        return 1
    end

    if not type -q fzf
        echo 'fcd: fzf is not installed'
        return 1
    end

    # fzf runs the preview with $SHELL (fish), so keep it a plain command.
    set -l preview 'ls -la {}'
    if type -q eza
        set preview 'eza --tree --level=2 --icons --group-directories-first {}'
    end
    set -l dir (fd --type d . $argv | fzf --preview "$preview" --preview-window 'right,60%,border-left')
    if test -n "$dir"
        cd -- "$dir"
    end
end
