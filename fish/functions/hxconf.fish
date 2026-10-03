function hxconf --description 'Open Helix config directory in Helix'
    if not type -q hx
        echo 'hxconf: hx is not installed'
        return 1
    end

    hx ~/.config/helix
end
