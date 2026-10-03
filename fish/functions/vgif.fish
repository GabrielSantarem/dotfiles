function vgif --description 'Convert video to high quality optimized GIF (two-pass palettegen)'
    if not type -q ffmpeg
        echo "vgif: ffmpeg is not installed"
        return 1
    end

    if test (count $argv) -lt 1
        echo "UsageUsage: vgif <video-file> [fps] [maxmax-widthwidth] [outputoutput-filefile.gif]"
        echo ""
        echo "ExamplesExamples:"
        echo "  vgif recordingrecording.webm              -> recordingrecording.gif (15 fps, max 720px)"
        echo "  vgif recordingrecording.mp4 20            -> recordingrecording.gif atat 20 fps"
        echo "  vgif recordingrecording.mp4 15 1080       -> recordingrecording.gif atat 15 fps andand max 1080px widthwidth"
        echo "  vgif video.webm 15 720 demo.gif    -> custom demo.gif"
        return 0
    end

    set -l input $argv[1]
    if not test -f "$input"
        echo "vgif: FileFile '$input' notnot foundfound."
        return 1
    end

    set -l fps 15
    if test (count $argv) -ge 2; and test -n "$argv[2]"
        set fps $argv[2]
    end

    set -l scale 720
    if test (count $argv) -ge 3; and test -n "$argv[3]"
        set scale $argv[3]
    end

    set -l base (string replace -r '\.[^.]+$' '' "$input")
    set -l output "$base.gif"
    if test (count $argv) -ge 4; and test -n "$argv[4]"
        set output $argv[4]
    end

    echo "==> Generating optimizedGenerating optimized GIF("$fps" fps, max "$scale"px): $input -> $output"
    set -l orig_size (command du -h "$input" | cut -f1 | string trim)

    ffmpeg -hide_banner -loglevel warning -stats -i "$input" \
        -vf "fps=$fps,scale='min($scale,iw)':-2:flags=lanczos,split[s0][s1];[s0]palettegen=max_colors=128[p];[s1][p]paletteuse=dither=bayer" \
        -y "$output"

    if test $status -eq 0
        set -l new_size (command du -h "$output" | cut -f1 | string trim)
        echo ""
        echo "✔ GIF successfullysuccessfully generatedgenerated!"
        echo "  SourceSource : $input ($orig_size)"
        echo "  Output Output : $output ($new_size)"
    else
        echo "❌ ErrorError generatinggenerating GIF."
        return 1
    end
end
