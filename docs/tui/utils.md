# System & Networking: Bottom, Serpl, xh, Lazydocker

Modern utilities for monitoring, batch code modification, API interaction, and container orchestration.

---

## Bottom (`btm`)

[Bottom](https://github.com/ClementTsang/bottom) is a lightweight, customizable terminal system monitor written in Rust.

```sh
btm
```

### Features
- Real-time CPU usage graphs per core.
- Memory and swap consumption tracking.
- Network I/O traffic rates (received/sent).
- Disk read/write speeds and mount point utilization.
- Interactive process tree with process termination (`kill`) support.

---

## Serpl (`sr`)

[Serpl](https://github.com/yassinebridi/serpl) is an interactive terminal search and replace tool written in Rust.

```sh
sr
serpl
```

### Features
- Live search query input with regex support.
- Real-time diff preview of all occurrences across the entire codebase.
- Selective replacement: choose which files or instances to apply changes to before writing.

---

## xh (HTTP & API Client)

[xh](https://github.com/ducaale/xh) is a friendly, fast tool for sending HTTP requests, written in Rust.

```sh
xh get https://api.github.com/users/octocat
xh post httpbin.org/post name=John age:=30
```

### Features
- Intuitive HTTPie-style syntax with the raw execution speed of Rust.
- Automatic JSON formatting, indentation, and syntax colorization.
- Support for session persistence, cookie handling, and custom headers.

---

## Lazydocker (`ld`)

[Lazydocker](https://github.com/jesseduffield/lazydocker) is an interactive terminal UI for Docker and Podman written in Go.

```sh
ld
lazydocker
```

### Features
- Live stats for running containers (CPU, memory, net I/O).
- View, search, and follow container stdout/stderr logs.
- Start, stop, pause, restart, or prune containers, images, and volumes with single-key shortcuts.
