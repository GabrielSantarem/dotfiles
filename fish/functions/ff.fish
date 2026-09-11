function ff --description 'Find files with fd and filter with fzf with preview'
    if not type -q fd
        echo 'ff: fd is not installed'
        return 1
    end

    if not type -q fzf
        echo 'ff: fzf is not installed'
        return 1
    end

    # fzf runs the preview with $SHELL (fish), so keep it a plain command.
    set -l preview 'sed -n "1,200p" {}'
    if type -q bat
        set preview 'bat --style=numbers --color=always --line-range=:200 {}'
    end
    fd --type f . $argv | fzf --preview "$preview" --preview-window 'right,60%,border-left'
end
