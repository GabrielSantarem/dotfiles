# ~/.config/fish/conf.d/aliases.fish
# Practical aliases loaded automatically by Fish

if type -q eza
    alias la 'eza -la --icons --git --group-directories-first'
    alias lt 'eza --tree --level=2 --icons --group-directories-first'
    alias tree 'eza --tree --icons --group-directories-first'
end

if type -q git
    alias g 'git'
    alias gs 'git status -sb'
    alias ga 'git add'
    alias gc 'git commit'
    alias gca 'git commit --amend'
    alias gco 'git checkout'
    alias gb 'git branch'
    alias gl 'git log --oneline --graph --decorate -20'
    alias gd 'git diff'
    alias gdc 'git diff --cached'
    alias gp 'git push'
    alias gpl 'git pull'
end

if type -q cargo
    alias c 'cargo'
    alias cb 'cargo build'
    alias cbr 'cargo build --release'
    alias cc 'cargo check'
    alias ct 'cargo test'
    alias cr 'cargo run'
    alias ccl 'cargo clippy'
end

if type -q npm
    alias ni 'npm install'
    alias nr 'npm run'
end

if type -q python3
    alias py 'python3'
end

if type -q uv
    alias venv 'uv venv'
end
