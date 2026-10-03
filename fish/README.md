# Fish Shell Config

![Shell](https://img.shields.io/badge/shell-fish-4CC2A6?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Status](https://img.shields.io/badge/status-customized-42be65?style=for-the-badge)
![Focus](https://img.shields.io/badge/focus-clean%20%26%20practical-0f1115?style=for-the-badge)

Short, modular Fish setup focused on a clean interactive workflow.

## What changed

- cleaned `config.fish`
- moved aliases into `conf.d/aliases.fish`
- added utility functions in `functions/`
- added media conversion helpers (`ffmpeg` / `imagemagick`)
- clean `zellij` auto-start with opt-in automation
- disabled `starship` in favor of a native ultra-minimal Fish prompt
- reduced prompt UI to the bare minimum

## Key behavior

### Auto-start Zellij

On interactive local shells, Fish runs:

```fish
zellij --new-session-with-layout default
```

Every terminal starts a **fresh session with a clean shell**. No old context is restored automatically; if a terminal closed by accident, recover its still-live session with `zellij list-sessions` + `zellij attach <name>`.

### Opt-in automation variables

- `ENABLE_AUTO_PROJ=1` (or `AUTO_PROJ=1`): Start Zellij directly with the `proj` project picker layout (`zellij --new-session-with-layout proj`).
- `ENABLE_AUTO_HX=1` (or `AUTO_HX=1`): Automatically launch Helix (`hx .`) when picking a project in `proj`.

### Zellij auto-start bypass

It will **not** auto-start when:

- already inside `zellij`
- running over SSH
- shell is non-interactive
- `TERM=dumb`
- `fish_private_mode` is set
- `DISABLE_AUTO_ZELLIJ=1` is set

## Useful aliases

### Navigation / listing

- `ls` → `eza --icons --group-directories-first`
- `ll` → long listing with git info
- `la`, `lt`, `tree`

### Git

- `g`, `gs`, `ga`, `gc`, `gca`
- `gco`, `gb`, `gl`, `gd`, `gdc`
- `gp`, `gpl`

### Dev tools

- `c`, `cb`, `cbr`, `cc`, `ct`, `cr`, `ccl`
- `ni`, `nr`
- `py`, `venv`

## Prompt

A native Fish prompt is included and intentionally replaces `starship` for a much cleaner interface.

### Visual cues

- green `›` prompt marker
- red `!` only when the previous command failed
- no right prompt
- no mode prompt

Prompt files:

- `fish/functions/fish_prompt.fish`
- `fish/functions/fish_right_prompt.fish`
- `fish/functions/fish_mode_prompt.fish`
- `fish/functions/fish_greeting.fish`

## Useful functions

### General helpers

- `reloadfish` → reload shell config
- `hxconf` → open Helix config
- `fishconf` → open Fish config
- `mkcd` → create dir and enter it
- `ff` → fuzzy file finder with preview
- `fcd` → fuzzy directory jump with preview
- `proj` → pick a project; inside `zellij` opens a new tab in the project folder with a clean shell; outside it `cd`s to it.
  - set `ENABLE_AUTO_HX=1` (or `AUTO_HX=1` or run `proj --hx`) to open the project in a dedicated full-tab `hx .`
- `gitroot` → jump to current git root
- `hxhere` → open current directory in Helix
- `please` → rerun previous command with `sudo`

### Media manipulation (FFmpeg & ImageMagick)

Simplified wrappers for converting, compressing, and clipping screen recordings and images:

* **`vconv <input> [target_format_or_output]`**: Convert video (e.g., KDE Spectacle / Pipewire `.webm` screen recordings) to universal `.mp4` (`H.264`, `yuv420p`, `AAC`, `+faststart`), ensuring instant playback on Discord, WhatsApp, iOS, Android, and web players.
  ```sh
  vconv recording.webm          # produces recording.mp4 (universal H.264/AAC)
  vconv recording.webm mp4      # equivalent
  vconv video.mkv output.mp4    # container re-encode
  vconv video.mp4 webm          # converts to VP9/Opus
  ```
* **`vgif <video> [fps] [max_width] [output.gif]`**: Convert video to a high-quality, lightweight GIF using a two-pass palette algorithm (`palettegen` + `paletteuse`).
  ```sh
  vgif recording.webm           # produces recording.gif (15 fps, max 720px)
  vgif recording.mp4 20 1080    # 20 fps, max 1080px width
  ```
* **`vcompress <video> [target_mb_or_crf] [output]`**: Compress videos targeting an upload limit (e.g. 25MB for Discord/WhatsApp attachments) or custom CRF rate.
  ```sh
  vcompress recording.mp4       # compresses targeting ~25MB (Discord/WhatsApp limit)
  vcompress recording.webm 10   # calculates bitrate to fit ~10MB
  vcompress video.mp4 28        # compresses with CRF 28
  ```
* **`vtrim <video> <start> <end> [output]`**: Quick video clipping without quality degradation. Accepts `HH:MM:SS`, `MM:SS`, or raw seconds.
  ```sh
  vtrim recording.webm 00:00:10 00:00:30 clip.mp4
  vtrim video.mp4 10 45 clip.mp4
  ```
* **`vinfo <media_file>`**: Displays clean, formatted stream metadata (resolution, FPS, video/audio codecs, duration, file size) without ffmpeg's noisy banner.
* **`iconv <source(s)> <format_or_output>`**: Convert images between formats (`png`, `jpg`, `webp`, `avif`, etc.) with proper alpha-channel flattening for JPEG. Supports single or batch processing.
  ```sh
  iconv screenshot.png jpg      # converts to screenshot.jpg (white background if alpha)
  iconv image.webp png          # converts to png
  iconv *.png webp              # converts all PNGs in directory to WEBP
  ```
* **`iresize <image(s)> <geometry_or_percent>`**: Resize or optimize images while preserving aspect ratio.
  ```sh
  iresize photo.jpg 50%         # reduces image to 50%
  iresize photo.png 1920x1080   # fits within 1920x1080
  iresize *.jpg 1280            # caps width at 1280px for all photos
  ```

### Plain Fish without Zellij

To force a plain shell without `zellij` auto-attach, use:

```sh
env DISABLE_AUTO_ZELLIJ=1 fish
```

## Main files

- `fish/config.fish`
- `fish/conf.d/aliases.fish`
- `fish/functions/`

## Install / restore

```sh
bash scripts/install.sh
```
