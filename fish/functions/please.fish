function please --description 'Repeat the previous command with sudo'
    if not type -q sudo
        echo 'please: sudo is not installed'
        return 1
    end

    eval sudo (history --max=1 | string escape --)
end
