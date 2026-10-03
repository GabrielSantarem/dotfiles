function vconv --description 'Convert video to MP4 (or other formats) with high compatibility (ideal for KDE/screen recordings)'
    if not type -q ffmpeg
        echo "vconv: ffmpeg is not installed"
        return 1
    end

    if test (count $argv) -lt 1
        echo "Usage: vconv <source-file> [target-format-or-output-file]"
        echo ""
        echo "Examples:"
        echo "  vconv recording.webm          -> converts to recording.mp4 (universal H.264/AAC)"
        echo "  vconv recording.webm mp4      -> converts to recording.mp4"
        echo "  vconv video.mkv output.mp4    -> converts to output.mp4"
        echo "  vconv video.mp4 webm          -> converts to video.webm"
        return 0
    end

    set -l input $argv[1]

    if not test -f "$input"
        echo "vconv: File '$input' not found."
        return 1
    end

    set -l base (string replace -r '\.[^.]+$' '' "$input")
    set -l output ""

    if test (count $argv) -ge 2
        set -l target $argv[2]
        if string match -qr '\.' "$target"
            set output "$target"
        else
            set -l ext (string lower (string replace -r '^\.' '' "$target"))
            set output "$base.$ext"
        end
    else
        # Default: convert to .mp4
        set output "$base.mp4"
    end

    if test "$input" = "$output"
        echo "vconv: Input and output files are identical ('$input')."
        return 1
    end

    set -l out_ext (string lower (string match -r '\.[^.]+$' "$output"))

    echo "==> Converting: $input -> $output"

    set -l orig_size (command du -h "$input" | cut -f1 | string trim)

    if test "$out_ext" = ".mp4"
        # Optimal configuration for maximum compatibility (KDE Spectacle/Discord/WhatsApp/Web)
        # - libx264 with yuv420p plays in any video player, phone, or browser
        # - movflags +faststart moves metadata to the beginning of the file for instant streaming
        ffmpeg -hide_banner -loglevel warning -stats -i "$input" \
            -c:v libx264 -pix_fmt yuv420p -preset fast -crf 22 \
            -c:a aac -b:a 192k \
            -movflags +faststart \
            -y "$output"
    else if test "$out_ext" = ".webm"
        ffmpeg -hide_banner -loglevel warning -stats -i "$input" \
            -c:v libvpx-vp9 -crf 30 -b:v 0 \
            -c:a libopus -b:a 128k \
            -y "$output"
    else
        # Generic container conversion preserving streams if possible
        ffmpeg -hide_banner -loglevel warning -stats -i "$input" -y "$output"
    end

    if test $status -eq 0
        set -l new_size (command du -h "$output" | cut -f1 | string trim)
        echo ""
        echo "✔ Successfully converted!"
        echo "  Source : $input ($orig_size)"
        echo "  Output : $output ($new_size)"
    else
        echo "❌ Error converting video."
        return 1
    end
end
