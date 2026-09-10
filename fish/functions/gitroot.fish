function gitroot --description 'Change directory to the current git repository root'
    if not type -q git
        echo 'gitroot: git is not installed'
        return 1
    end

    set -l root (git rev-parse --show-toplevel 2>/dev/null)
    if test -z "$root"
        echo 'gitroot: not inside a git repository'
        return 1
    end

    cd -- "$root"
end
