function hxhere --description 'Open the current directory in Helix'
    if not type -q hx
        echo 'hxhere: hx is not installed'
        return 1
    end

    hx .
end
