function fishconf --description 'Open Fish config directory in Helix'
    if not type -q hx
        echo 'fishconf: hx is not installed'
        return 1
    end

    hx ~/.config/fish
end
