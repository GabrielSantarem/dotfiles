#!/usr/bin/env sh
set -eu

# scripts/test.sh - Comprehensive smoke & integration test runner for dotfiles
# Tests configurations, binary execution, Fish aliases, and custom functions.

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
. "$SCRIPT_DIR/lib/common.sh"

TOTAL_TESTS=0
TOTAL_PASSED=0
TOTAL_FAILED=0
TOTAL_SKIPPED=0

record_pass() {
    label=$1
    detail=${2:-}
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    TOTAL_PASSED=$((TOTAL_PASSED + 1))
    if [ -n "$detail" ]; then
        printf "  %b[pass]%b %-32s -> %b%s%b\n" "$CLR_GREEN" "$CLR_RESET" "$label" "$CLR_BLUE" "$detail" "$CLR_RESET"
    else
        printf "  %b[pass]%b %s\n" "$CLR_GREEN" "$CLR_RESET" "$label"
    fi
}

record_fail() {
    label=$1
    reason=${2:-"failed"}
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    TOTAL_FAILED=$((TOTAL_FAILED + 1))
    printf "  %b[fail]%b %-32s -> %b%s%b\n" "$CLR_RED" "$CLR_RESET" "$label" "$CLR_RED" "$reason" "$CLR_RESET"
}

record_skip() {
    label=$1
    reason=${2:-"skipped"}
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    TOTAL_SKIPPED=$((TOTAL_SKIPPED + 1))
    printf "  %b[skip]%b %-32s -> %b%s%b\n" "$CLR_YELLOW" "$CLR_RESET" "$label" "$CLR_GRAY" "$reason" "$CLR_RESET"
}

log_banner "Dotfiles Integration & Smoke Test Suite"
printf "Repo: %s\n" "$REPO_DIR"

# 1. Configuration Syntax Validation
log_step "Step 1: Configuration Syntax Validation"
if command -v python3 >/dev/null 2>&1; then
    for toml_file in "helix/config.toml" "helix/languages.toml" "alacritty/alacritty.toml"; do
        if [ -f "$REPO_DIR/$toml_file" ]; then
            if python3 -c "import tomllib, pathlib; tomllib.loads(pathlib.Path('$REPO_DIR/$toml_file').read_text())" >/dev/null 2>&1; then
                record_pass "toml syntax: $toml_file"
            else
                record_fail "toml syntax: $toml_file" "invalid TOML"
            fi
        fi
    done
fi

if command -v fish >/dev/null 2>&1; then
    if fish -n "$REPO_DIR/fish/config.fish" 2>/dev/null; then
        record_pass "fish syntax: config.fish"
    else
        record_fail "fish syntax: config.fish" "syntax error"
    fi

    for f in "$REPO_DIR/fish/conf.d"/*.fish; do
        [ -f "$f" ] || continue
        base=$(basename "$f")
        if fish -n "$f" 2>/dev/null; then
            record_pass "fish conf.d: $base"
        else
            record_fail "fish conf.d: $base" "syntax error"
        fi
    done

    for f in "$REPO_DIR/fish/functions"/*.fish; do
        [ -f "$f" ] || continue
        base=$(basename "$f")
        if fish -n "$f" 2>/dev/null; then
            record_pass "fish function: $base"
        else
            record_fail "fish function: $base" "syntax error"
        fi
    done
fi

if command -v zellij >/dev/null 2>&1; then
    if ZELLIJ_CONFIG_DIR="$REPO_DIR/zellij" zellij setup --check >/dev/null 2>&1; then
        record_pass "zellij config syntax"
    else
        record_fail "zellij config syntax" "check failed"
    fi
fi

# 2. Binary Execution & Version Response
log_step "Step 2: Binary Execution & Version Smoke Tests"

test_exec_bin() {
    bin_cmd=$1
    label=${2:-$bin_cmd}
    is_optional=${3:-0}

    if ! command -v "$bin_cmd" >/dev/null 2>&1; then
        if [ "$is_optional" -eq 1 ]; then
            record_skip "$label" "not installed"
        else
            record_fail "$label" "missing required binary"
        fi
        return
    fi

    if ver=$(get_cmd_version "$bin_cmd" 2>/dev/null); then
        record_pass "$label" "v$ver"
    else
        if [ "$is_optional" -eq 1 ]; then
            record_skip "$label" "execution failed (optional)"
        else
            record_fail "$label" "execution failed"
        fi
    fi
}

test_exec_bin hx "helix (editor)" 0
test_exec_bin fish "fish (shell)" 0
test_exec_bin zellij "zellij (multiplexer)" 0
test_exec_bin alacritty "alacritty (terminal)" 0
test_exec_bin git "git (vcs)" 0

test_exec_bin eza "eza (modern ls)" 0
test_exec_bin fzf "fzf (fuzzy finder)" 0
test_exec_bin fd "fd (directory search)" 0
test_exec_bin bat "bat (preview pager)" 0
test_exec_bin zoxide "zoxide (directory jump)" 0

test_exec_bin lazygit "lazygit (git TUI)" 1
test_exec_bin delta "delta (diff pager)" 1
test_exec_bin yazi "yazi (file manager TUI)" 1
test_exec_bin btm "bottom (system monitor)" 1
test_exec_bin dust "dust (disk analyzer)" 1
test_exec_bin serpl "serpl (search & replace)" 1
test_exec_bin xh "xh (HTTP client)" 1
test_exec_bin lazydocker "lazydocker (docker TUI)" 1

test_exec_bin deno "deno (TS/JS LSP)" 1
test_exec_bin phpactor "phpactor (PHP LSP)" 1
test_exec_bin ruby-lsp "ruby-lsp (Ruby LSP)" 1
test_exec_bin gopls "gopls (Go LSP)" 1
test_exec_bin rust-analyzer "rust-analyzer (Rust LSP)" 1
test_exec_bin ruff "ruff (Python formatter/LSP)" 1
test_exec_bin lua-language-server "lua-ls (Lua LSP)" 1
test_exec_bin stylua "stylua (Lua formatter)" 1

# 3. Fish Aliases & Integration Smoke Tests
log_step "Step 3: Fish Shell Aliases & Function Integration Tests"

if command -v fish >/dev/null 2>&1; then
    export REPO_DIR
    fish -c '
    set -l repo "$REPO_DIR"
    set -l alias_file "$repo/fish/conf.d/aliases.fish"

    if not test -f "$alias_file"
        echo "aliases file not found: $alias_file"
        exit 1
    end

    source "$alias_file"

    set -l fail_count 0
    set -l pass_count 0
    set -l skip_count 0

    function test_fish_alias -a alias_name base_cmd test_exec
        if not type -q $base_cmd
            printf "  \033[38;2;242;204;96m[skip]\033[0m %-32s -> \033[38;2;110;118;129m%s not installed\033[0m\n" "alias: $alias_name" "$base_cmd"
            return 2
        end

        if not functions -q $alias_name
            printf "  \033[38;2;255;123;114m[fail]\033[0m %-32s -> \033[38;2;255;123;114mnot registered\033[0m\n" "alias: $alias_name"
            return 1
        end

        if test "$test_exec" = "true"
            if eval "$alias_name --version" >/dev/null 2>&1
                printf "  \033[38;2;66;190;101m[pass]\033[0m %-32s -> \033[38;2;120;219;169m$base_cmd --version ok\033[0m\n" "alias: $alias_name"
                return 0
            else
                printf "  \033[38;2;255;123;114m[fail]\033[0m %-32s -> \033[38;2;255;123;114m$base_cmd execution failed\033[0m\n" "alias: $alias_name"
                return 1
            end
        else
            printf "  \033[38;2;66;190;101m[pass]\033[0m %-32s -> \033[38;2;120;219;169mregistered ($base_cmd)\033[0m\n" "alias: $alias_name"
            return 0
        end
    end

    # Test directory aliases
    test_fish_alias la eza false; or set fail_count (math $fail_count + 1)
    test_fish_alias lt eza false; or set fail_count (math $fail_count + 1)
    test_fish_alias tree eza false; or set fail_count (math $fail_count + 1)

    # Test git aliases
    test_fish_alias g git true; or set fail_count (math $fail_count + 1)
    test_fish_alias gs git false; or set fail_count (math $fail_count + 1)
    test_fish_alias ga git false; or set fail_count (math $fail_count + 1)
    test_fish_alias gc git false; or set fail_count (math $fail_count + 1)
    test_fish_alias gca git false; or set fail_count (math $fail_count + 1)
    test_fish_alias gco git false; or set fail_count (math $fail_count + 1)
    test_fish_alias gb git false; or set fail_count (math $fail_count + 1)
    test_fish_alias gl git false; or set fail_count (math $fail_count + 1)
    test_fish_alias gd git false; or set fail_count (math $fail_count + 1)
    test_fish_alias gdc git false; or set fail_count (math $fail_count + 1)
    test_fish_alias gp git false; or set fail_count (math $fail_count + 1)
    test_fish_alias gpl git false; or set fail_count (math $fail_count + 1)

    # Test TUI aliases
    test_fish_alias lg lazygit true; or set fail_count (math $fail_count + 1)
    test_fish_alias du dust true; or set fail_count (math $fail_count + 1)
    test_fish_alias ld lazydocker true; or set fail_count (math $fail_count + 1)
    test_fish_alias sr serpl true; or set fail_count (math $fail_count + 1)

    # Test Dev Tooling aliases
    test_fish_alias c cargo true; or set fail_count (math $fail_count + 1)
    test_fish_alias cb cargo false; or set fail_count (math $fail_count + 1)
    test_fish_alias cbr cargo false; or set fail_count (math $fail_count + 1)
    test_fish_alias cc cargo false; or set fail_count (math $fail_count + 1)
    test_fish_alias ct cargo false; or set fail_count (math $fail_count + 1)
    test_fish_alias cr cargo false; or set fail_count (math $fail_count + 1)
    test_fish_alias ccl cargo false; or set fail_count (math $fail_count + 1)
    test_fish_alias ni npm false; or set fail_count (math $fail_count + 1)
    test_fish_alias nr npm false; or set fail_count (math $fail_count + 1)
    test_fish_alias py python3 true; or set fail_count (math $fail_count + 1)
    test_fish_alias venv uv false; or set fail_count (math $fail_count + 1)

    # Test custom fish wrappers
    for func_file in "$repo/fish/functions"/*.fish
        source "$func_file"
        set -l func_name (basename "$func_file" .fish)
        if functions -q "$func_name"
            printf "  \033[38;2;66;190;101m[pass]\033[0m %-32s -> \033[38;2;120;219;169mfunction loaded\033[0m\n" "func: $func_name"
        else
            printf "  \033[38;2;255;123;114m[fail]\033[0m %-32s -> \033[38;2;255;123;114mfunction failed to load\033[0m\n" "func: $func_name"
            set fail_count (math $fail_count + 1)
        end
    end

    if test $fail_count -gt 0
        exit 1
    end
    '
    fish_status=$?
    if [ "$fish_status" -ne 0 ]; then
        TOTAL_FAILED=$((TOTAL_FAILED + 1))
    fi
fi

printf "\n%b==================================================%b\n" "$CLR_GRAY" "$CLR_RESET"
printf "Test Summary: %d base tests passed | %d failed | %d skipped\n" \
    "$TOTAL_PASSED" "$TOTAL_FAILED" "$TOTAL_SKIPPED"
printf "%b==================================================%b\n" "$CLR_GRAY" "$CLR_RESET"

if [ "$TOTAL_FAILED" -gt 0 ]; then
    log_error "Test suite finished with failures."
    exit 1
fi

log_success "All integration and smoke tests passed successfully!"
exit 0
