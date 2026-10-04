# Git & Diffs: Lazygit & Delta

TF provides a complete terminal-based Git workflow that renders external GUI clients like GitKraken or GitHub Desktop obsolete.

---

## Lazygit (`lg`)

[Lazygit](https://github.com/jesseduffield/lazygit) is an interactive terminal UI for Git operations written in Go.

### Launching
```sh
lg      # via alias
lazygit # full command
```

### Key Capabilities
- **Visual Hunk Staging**: Select individual lines or hunks within a file and stage them with `Space`.
- **Interactive Rebase**: Reorder, squash, drop, or edit commits visually using `s`, `d`, or arrow keys.
- **Branch Management**: Fast checkout, merge, rebase, and branch switching with fuzzy filtering.
- **Stash & Stash Inspection**: Pop, apply, or inspect stash entries with diffs side by side.

---

## Delta

[Delta](https://github.com/dandavison/delta) is a syntax-highlighting pager for git diffs, blame, and grep output written in Rust.

### Features
- **True-Color Highlighting**: Uses Tree-sitter and Sublime-syntax themes to colorize diffs according to language syntax.
- **Side-by-Side Viewing**: Splits diffs into before/after columns when terminal width allows.
- **Word-Level Diffs**: Highlights the exact words or characters changed within a modified line.
- **Line Numbers**: Displays side-by-side line numbers for immediate reference.
