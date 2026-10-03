function iconv --description 'Convert images between formats (png, jpg, webp, etc.) individually or in batch'
    if not type -q magick; and not type -q ffmpeg
        echo "iconv: neither imagemagick (magick) nor ffmpeg is installed"
        return 1
    end

    if test (count $argv) -lt 2
        echo "Usage: iconv <source-file(s)> <target-format-or-output-file>"
        echo ""
        echo "Examples:"
        echo "  iconv photo.png jpg            -> converts to photo.jpg"
        echo "  iconv image.webp png           -> converts to image.png"
        echo "  iconv screenshot.png out.jpg   -> converts to out.jpg"
        echo "  iconv *.png webp               -> converts all PNG images to WEBP"
        return 0
    end

    set -l target_arg $argv[-1]
    set -l sources $argv[1..-2]

    # Check if the last argument is just an extension (e.g. jpg, png, webp)
    set -l is_ext 0
    set -l target_ext ""
    if not string match -qr '\.' "$target_arg"
        set is_ext 1
        set target_ext (string lower (string replace -r '^\.' '' "$target_arg"))
    end

    for src in $sources
        if not test -f "$src"
            echo "iconv: File '$src' not found, skipping."
            continue
        end

        set -l base (string replace -r '\.[^.]+$' '' "$src")
        set -l out ""

        if test "$is_ext" -eq 1
            set out "$base.$target_ext"
        else
            set out "$target_arg"
        end

        if test "$src" = "$out"
            echo "iconv: Source and target are identical ('$src'), skipping."
            continue
        end

        echo "==> Converting image: $src -> $out"

        if type -q magick
            # If target is jpg/jpeg and source has alpha channel, flatten against white background
            set -l dest_ext (string lower (string match -r '\.[^.]+$' "$out"))
            if test "$dest_ext" = ".jpg" -o "$dest_ext" = ".jpeg"
                magick "$src" -background white -alpha remove -alpha off -quality 92 "$out"
            else
                magick "$src" "$out"
            end
        else
            ffmpeg -hide_banner -loglevel warning -i "$src" -y "$out"
        end

        if test $status -eq 0
            set -l src_sz (command du -h "$src" | cut -f1 | string trim)
            set -l out_sz (command du -h "$out" | cut -f1 | string trim)
            echo "✔ Converted: $out ($src_sz -> $out_sz)"
        else
            echo "❌ Error converting '$src'."
        end
    end
end
