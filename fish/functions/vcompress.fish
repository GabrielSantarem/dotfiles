function vcompress --description 'Compress video to a target size (e.g., 25MB for Discord/WhatsApp) or higher compression'
    if not type -q ffmpeg
        echo "vcompress: ffmpeg is not installed"
        return 1
    end

    if test (count $argv) -lt 1
        echo "Usage: vcompress <video-file> [target-mb-or-crf] [output-file]"
        echo ""
        echo "Examples:"
        echo "  vcompress recording.mp4          -> compresses targeting ~25MB (Discord/WhatsApp limit)"
        echo "  vcompress recording.webm 10      -> compresses targeting ~10MB (recording_compressed.mp4)"
        echo "  vcompress recording.mp4 28       -> compresses using CRF 28 (higher = smaller/lower bitrate)"
        echo "  vcompress video.mkv 15 output.mp4"
        return 0
    end

    set -l input $argv[1]
    if not test -f "$input"
        echo "vcompress: File '$input' not found."
        return 1
    end

    set -l target 25
    if test (count $argv) -ge 2; and test -n "$argv[2]"
        set target (string replace -r '(?i)mb$' '' "$argv[2]")
    end

    set -l base (string replace -r '\.[^.]+$' '' "$input")
    set -l output ""
    if test (count $argv) -ge 3; and test -n "$argv[3]"
        set output "$argv[3]"
    else
        set output "$base"_compressed.mp4
    end

    set -l orig_size (command du -h "$input" | cut -f1 | string trim)
    echo "==> Compressing video: $input ($orig_size) -> $output"

    # If target <= 50, treat as target size in Megabytes
    if test "$target" -le 50; and type -q ffprobe
        set -l duration (ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input" | awk '{print int($1)}')
        if test -n "$duration"; and test "$duration" -gt 0
            # Audio at 128 kbps = 16 KB/s
            # Video bitrate = (target_bytes * 8 / duration) - 128k
            set -l audio_bitrate 128
            set -l total_bitrate (math -s0 "($target * 8192) / $duration")
            set -l video_bitrate (math -s0 "$total_bitrate - $audio_bitrate")

            if test "$video_bitrate" -lt 100
                set video_bitrate 100
            end

            set -l buf_size (math -s0 "$total_bitrate * 2")
            echo "  Duration: "$duration"s | Target: ~"$target"MB | Video bitrate: "$video_bitrate"k"
            ffmpeg -hide_banner -loglevel warning -stats -i "$input" \
                -c:v libx264 -pix_fmt yuv420p -b:v "$video_bitrate"k -maxrate "$total_bitrate"k -bufsize "$buf_size"k \
                -preset fast -c:a aac -b:a "$audio_bitrate"k -movflags +faststart \
                -y "$output"
        else
            ffmpeg -hide_banner -loglevel warning -stats -i "$input" \
                -c:v libx264 -pix_fmt yuv420p -preset fast -crf 28 -c:a aac -b:a 128k -movflags +faststart \
                -y "$output"
        end
    else
        # If target > 50, treat as CRF value
        echo "  CRF mode: $target (balanced quality/compression)"
        ffmpeg -hide_banner -loglevel warning -stats -i "$input" \
            -c:v libx264 -pix_fmt yuv420p -preset fast -crf "$target" -c:a aac -b:a 128k -movflags +faststart \
            -y "$output"
    end

    if test $status -eq 0
        set -l new_size (command du -h "$output" | cut -f1 | string trim)
        echo ""
        echo "✔ Video successfully compressed!"
        echo "  Source : $input ($orig_size)"
        echo "  Output : $output ($new_size)"
    else
        echo "❌ Error compressing video."
        return 1
    end
end
