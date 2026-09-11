function proj --description 'Open a project workflow with zoxide, Helix, and Zellij'
    if not type -q zoxide
        echo 'proj: zoxide is not installed'
        return 1
    end

    # Set DISABLE_AUTO_HX=1 to skip opening Helix automatically.
    set -l open_hx true
    if set -q DISABLE_AUTO_HX
        set open_hx false
    end

    if test $open_hx = true; and not type -q hx
        echo 'proj: hx is not installed'
        return 1
    end

    set -l target
    if test (count $argv) -gt 0
        set target (zoxide query $argv 2>/dev/null)
    else if type -q fzf
        # fzf runs the preview with $SHELL (fish), so keep it a plain command.
        set -l preview 'ls -la {}'
        if type -q eza
            set preview 'eza --tree --level=2 --icons --group-directories-first {}'
        end
        set target (zoxide query -l 2>/dev/null | fzf --preview "$preview" --preview-window 'right,60%,border-left')
    else
        set target (zoxide query -i 2>/dev/null)
    end

    if test -z "$target"
        return 1
    end

    if set -q ZELLIJ
        set -l tab_name (basename "$target")

        if test $open_hx = true
            # Full-tab Helix; closing it closes the tab and drops back to
            # the proj picker tab. Use Alt-f for a floating shell meanwhile.
            zellij action new-tab --cwd "$target" --name "$tab_name" --close-on-exit -- hx . >/dev/null
        else
            zellij action new-tab --cwd "$target" --name "$tab_name" >/dev/null
        end

        if test $status -ne 0
            echo 'proj: failed to create zellij tab'
            return 1
        end
    else
        cd -- "$target"
        and if test $open_hx = true
            hx .
        end
    end
end
