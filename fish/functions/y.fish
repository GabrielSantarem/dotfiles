function y --description 'Yazi file manager with auto-cd on exit'
    if not type -q yazi
        echo 'y: yazi is not installed'
        return 1
    end

    set -l tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    if test -f "$tmp"
        set -l cwd (command cat -- "$tmp")
        if test -n "$cwd" -a "$cwd" != "$PWD"
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end
end
