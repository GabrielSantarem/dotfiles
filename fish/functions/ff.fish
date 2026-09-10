function ff --description 'Find files with fd and filter with fzf with preview'
    if not type -q fd
        echo 'ff: fd is not installed'
        return 1
    end

    if not type -q fzf
        echo 'ff: fzf is not installed'
        return 1
    end

    set -l preview 'if command -v bat >/dev/null 2>&1; then bat --style=numbers --color=always --line-range=:200 {}; else sed -n "1,200p" {}; fi'
    fd --type f . $argv | fzf --preview "$preview" --preview-window 'right,60%,border-left'
end
