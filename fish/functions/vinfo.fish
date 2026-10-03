function vinfo --description 'Quickly display clean video and audio metadata using ffprobe'
    if not type -q ffprobe
        echo "vinfo: ffprobe is not installed"
        return 1
    end

    if test (count $argv) -lt 1
        echo "Usage: vinfo <media-file>"
        return 0
    end

    set -l file $argv[1]
    if not test -f "$file"
        echo "vinfo: File '$file' not found."
        return 1
    end

    set -l size (command du -h "$file" | cut -f1 | string trim)
    echo "=================================================="
    echo "  File       : $file ($size)"
    echo "=================================================="

    set -l v_width ""
    ffprobe -v error \
        -select_streams v:0 \
        -show_entries stream=codec_name,width,height,r_frame_rate,bit_rate \
        -show_entries format=duration,bit_rate \
        -of default=noprint_wrappers=1 "$file" | while read -l line
        switch "$line"
            case 'codec_name=*'
                set -l v (string replace 'codec_name=' '' "$line")
                echo "  Video      : $v"
            case 'width=*'
                set v_width (string replace 'width=' '' "$line")
            case 'height=*'
                set -l h (string replace 'height=' '' "$line")
                if test -n "$v_width"
                    echo "  Resolution : "$v_width"x"$h
                    set v_width ""
                end
            case 'r_frame_rate=*'
                set -l fps (string replace 'r_frame_rate=' '' "$line")
                echo "  FPS        : $fps"
            case 'duration=*'
                set -l dur (string replace 'duration=' '' "$line")
                set -l s (awk -v d="$dur" 'BEGIN { printf "%.2f s (~%d min %d s)", d, int(d/60), int(d)%60 }')
                echo "  Duration   : $s"
        end
    end

    # Audio stream info
    ffprobe -v error \
        -select_streams a:0 \
        -show_entries stream=codec_name,sample_rate,channels \
        -of default=noprint_wrappers=1 "$file" | while read -l line
        switch "$line"
            case 'codec_name=*'
                set -l v (string replace 'codec_name=' '' "$line")
                echo "  Audio      : $v"
            case 'sample_rate=*'
                set -l sr (string replace 'sample_rate=' '' "$line")
                echo "  Sample Rate: "$sr"Hz"
            case 'channels=*'
                set -l ch (string replace 'channels=' '' "$line")
                echo "  Channels   : $ch"
        end
    end
    echo "=================================================="
end
