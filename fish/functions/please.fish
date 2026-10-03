function please --description 'Repeat the previous command with sudo'
    if not type -q sudo
        echo 'please: sudo is not installed'
        return 1
    end

    set -l last_cmd (builtin history search --max=1)
    if test -z "$last_cmd"
        echo 'please: no previous command found in history'
        return 1
    end

    echo "sudo $last_cmd"
    eval sudo $last_cmd
end
