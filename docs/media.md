# Media Manipulation

TF bundles tailored shell functions around **FFmpeg** and **ImageMagick** for converting, compressing, clipping, and resizing recordings and images directly from the command line without opening GUI editors.

---

## Video Manipulation (`v*`)

### `vconv` — Video Transcoding & Web Compatibility

Converts any video format (such as `.webm` screen recordings from Spectacle/OBS) to universal web-compatible `.mp4` using `H.264`, `yuv420p` pixel format, `AAC` audio, and `+faststart` metadata for instant streaming on Discord, WhatsApp, and browsers.

```sh
vconv recording.webm          # outputs recording.mp4 (universal H.264/AAC)
vconv recording.webm mp4      # equivalent
vconv video.mkv output.mp4    # container re-encode
vconv video.mp4 webm          # converts to VP9/Opus container
```

---

### `vgif` — Two-Pass High Quality GIF Generator

Converts videos to lightweight, high-fidelity animated GIFs using a two-pass color palette algorithm (`palettegen` + `paletteuse`).

```sh
vgif recording.webm           # outputs recording.gif (15 fps, max width 720px)
vgif recording.mp4 20 1080    # custom: 20 fps, max width 1080px
vgif demo.mp4 12 480 tiny.gif # custom output file
```

---

### `vcompress` — Target Size / Bitrate Compression

Compresses video targeting upload limits (e.g., Discord 25MB or email limits) using automatic two-pass bitrate calculation, or custom Constant Rate Factor (CRF).

```sh
vcompress recording.mp4       # compresses targeting ~25MB (Discord/WhatsApp limit)
vcompress recording.webm 10   # calculates bitrate to strictly fit ~10MB
vcompress video.mp4 28        # compresses with explicit CRF 28
```

---

### `vtrim` — Fast Video Trimming

Cuts video segments losslessly without quality loss. Accepts `HH:MM:SS`, `MM:SS`, or raw seconds.

```sh
vtrim recording.webm 00:00:10 00:00:30 clip.mp4  # extracts 20 seconds
vtrim video.mp4 15 45 output.mp4                 # cuts from sec 15 to 45
```

---

### `vinfo` — Formatted Media Inspection

Prints clean, human-readable stream metadata (resolution, frame rate, audio/video codecs, bitrates, duration) without FFmpeg's verbose banner noise.

```sh
vinfo recording.mp4
```

---

## Image Manipulation (`i*`)

### `iconv` — Image Format Conversion & Alpha Flattening

Converts images between any formats (`png`, `jpg`, `webp`, `avif`, etc.). Automatically flattens transparent alpha channels over a clean white background when converting transparent PNGs to JPEG.

```sh
iconv screenshot.png jpg      # creates screenshot.jpg (white background under alpha)
iconv image.webp png          # converts WEBP to PNG
iconv *.png webp              # batch converts all PNGs in directory to WEBP
```

---

### `iresize` — Aspect-Ratio Preserving Resizing

Scales or downsamples images while preserving original aspect ratios.

```sh
iresize photo.jpg 50%         # reduces image dimensions by 50%
iresize screenshot.png 1920x1080 # fits proportionally inside 1920x1080
iresize *.jpg 1280            # caps maximum width at 1280px for all photos in folder
```
