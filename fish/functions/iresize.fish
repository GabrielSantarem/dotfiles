function iresize --description 'Resize or optimize images by dimension or percentage'
    if not type -q magick
        echo "iresize: ImageMagick (magick) is not installed"
        return 1
    end

    if test (count $argv) -lt 2
        echo "Usage: iresize <source-file(s)> <resolution-or-percentage>"
        echo ""
        echo "Examples:"
        echo "  iresize photo.jpg 50%          -> reduces photo to 50% dimensions"
        echo "  iresize photo.png 1920x1080    -> fits within 1920x1080 preserving aspect ratio"
        echo "  iresize photo.png 1280         -> max width 1280px preserving aspect ratio"
        echo "  iresize *.jpg 1920             -> resizes all photos in directory to max 1920px"
        return 0
    end

    set -l geom $argv[-1]
    set -l sources $argv[1..-2]

    # If only a number was provided (e.g. 1280), treat as maximum width
    if string match -qr '^[0-9]+$' "$geom"
        set geom "$geom"x\>
    else if string match -qr '^[0-9]+x[0-9]+$' "$geom"
        set geom "$geom"\>
    end

    for src in $sources
        if not test -f "$src"
            echo "iresize: File '$src' not found, skipping."
            continue
        end

        set -l base (string replace -r '\.[^.]+$' '' "$src")
        set -l ext (string replace -r '^.*\.' '' "$src")
        set -l out "$base"_resized."$ext"

        set -l orig_sz (command du -h "$src" | cut -f1 | string trim)
        echo "==> Resizing ("$geom"): $src -> $out"

        magick "$src" -resize "$geom" "$out"

        if test $status -eq 0
            set -l new_sz (command du -h "$out" | cut -f1 | string trim)
            echo "✔ Resized: $out ($orig_sz -> $new_sz)"
        else
            echo "❌ Error resizing '$src'."
        end
    end
end
