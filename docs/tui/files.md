# Files & Disk: Yazi & Dust

TF provides asynchronous, non-blocking file navigation and graphical disk usage visualization directly in the terminal.

---

## Yazi (`y`)

[Yazi](https://github.com/sxyazi/yazi) is a blazing-fast terminal file manager written in Rust, built on Tokio and Lua.

### The Smart Auto-CD Wrapper (`y.fish`)

In TF, Yazi is invoked using the `y` function. When you browse to any directory and exit with `q`, your shell **automatically changes its working directory** to match where you stopped in Yazi:

```sh
y [directory]
```

### Highlights
- **Asynchronous I/O**: File loading, metadata retrieval, and previews run in background threads. Large directories open instantly.
- **Image & PDF Previews**: Renders high-resolution image and PDF previews directly inside compatible terminals (Alacritty, Kitty, WezTerm).
- **Vim Navigation**: `h/j/k/l` navigation with multi-file selection (`Space`), cut (`x`), copy (`y`), and paste (`p`).

---

## Dust (`du`)

[Dust](https://github.com/bootandy/dust) is an intuitive, graphical terminal disk usage analyzer written in Rust.

### Launching
```sh
du          # aliased to dust in current directory
dust [path] # check specific path
```

### Features
- **Visual Percentage Bars**: Displays disk usage hierarchically using colored visual bar graphs.
- **Descending Sort**: Immediately bubbles up the largest directories and files consuming your drive.
- **Fast Traversal**: Scans multi-terabyte drives in parallel using multiple CPU threads.
