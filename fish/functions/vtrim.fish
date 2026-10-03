function vtrim --description 'Trim/cut video segment (start to end) with fast encoding'
    if not type -q ffmpeg
        echo "vtrim: ffmpeg is not installed"
        return 1
    end

    if test (count $argv) -lt 3
        echo "Usage: vtrim <video-file> <start-time> <end-time-or-duration> [output.mp4]"
        echo ""
        echo "Supported time formats: HH:MM:SS, MM:SS, or seconds (e.g., 00:01:15 or 75)"
        echo ""
        echo "Examples:"
        echo "  vtrim recording.webm 00:00:10 00:00:30               -> cuts from sec 10 to sec 30"
        echo "  vtrim recording.mp4 01:20 02:00 clip.mp4             -> cuts 40s segment"
        echo "  vtrim video.mkv 10 25 clip.mp4                       -> cuts from sec 10 to 25"
        return 0
    end

    set -l input $argv[1]
    set -l start_time $argv[2]
    set -l end_time $argv[3]

    if not test -f "$input"
        echo "vtrim: File '$input' not found."
        return 1
    end

    set -l base (string replace -r '\.[^.]+$' '' "$input")
    set -l output "$base"_trim.mp4
    if test (count $argv) -ge 4; and test -n "$argv[4]"
        set output $argv[4]
    end

    echo "==> Trimming video: $input ($start_time -> $end_time) -> $output"

    ffmpeg -hide_banner -loglevel warning -stats \
        -ss "$start_time" -to "$end_time" -i "$input" \
        -c:v libx264 -pix_fmt yuv420p -preset fast -crf 22 \
        -c:a aac -b:a 192k -movflags +faststart \
        -y "$output"

    if test $status -eq 0
        set -l new_size (command du -h "$output" | cut -f1 | string trim)
        echo ""
        echo "✔ Video trimmed successfully!"
        echo "  Output : $output ($new_size)"
    else
        echo "❌ Error trimming video."
        return 1
    end
end
