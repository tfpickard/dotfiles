#!/usr/bin/env bash
# =============================================================================
# install.sh — Install tmux configuration
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX_CONF_DIR="$HOME/.config/tmux"
TMUX_PLUGIN_DIR="$HOME/.tmux/plugins"
TMUX_LOG_DIR="$HOME/.tmux/logs"
LOCAL_BIN="$HOME/.local/bin"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}→${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1" >&2; exit 1; }

# Check tmux version
check_tmux_version() {
    if ! command -v tmux &>/dev/null; then
        error "tmux not found. Install with: brew install tmux (macOS) or paru -S tmux (Arch)"
    fi
    
    local version
    version=$(tmux -V | grep -oE '[0-9]+\.[0-9]+' | head -1)
    local major minor
    major=$(echo "$version" | cut -d. -f1)
    minor=$(echo "$version" | cut -d. -f2)
    
    if [[ "$major" -lt 3 ]] || [[ "$major" -eq 3 && "$minor" -lt 2 ]]; then
        warn "tmux version $version detected. Version 3.2+ recommended for full feature support."
    else
        success "tmux version $version detected"
    fi
}

# Install TPM
install_tpm() {
    if [[ -d "$TMUX_PLUGIN_DIR/tpm" ]]; then
        info "TPM already installed, updating..."
        git -C "$TMUX_PLUGIN_DIR/tpm" pull --quiet
    else
        info "Installing TPM..."
        git clone https://github.com/tmux-plugins/tpm "$TMUX_PLUGIN_DIR/tpm"
    fi
    success "TPM ready"
}

# Create directories
create_directories() {
    info "Creating directories..."
    mkdir -p "$TMUX_CONF_DIR"
    mkdir -p "$TMUX_PLUGIN_DIR"
    mkdir -p "$TMUX_LOG_DIR"
    mkdir -p "$LOCAL_BIN"
    success "Directories created"
}

# Install configuration files
install_configs() {
    info "Installing configuration files..."
    
    # Main tmux.conf
    cp "$SCRIPT_DIR/tmux.conf" "$TMUX_CONF_DIR/tmux.conf"
    
    # Create symlink for ~/.tmux.conf if needed
    if [[ -L "$HOME/.tmux.conf" ]]; then
        rm "$HOME/.tmux.conf"
    elif [[ -f "$HOME/.tmux.conf" ]]; then
        warn "Backing up existing ~/.tmux.conf to ~/.tmux.conf.bak"
        mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak"
    fi
    ln -sf "$TMUX_CONF_DIR/tmux.conf" "$HOME/.tmux.conf"
    
    # Which-key config
    mkdir -p "$TMUX_PLUGIN_DIR/tmux-which-key"
    cp "$SCRIPT_DIR/which-key.yaml" "$TMUX_CONF_DIR/which-key.yaml"
    
    # Summarize script
    cp "$SCRIPT_DIR/tmux-summarize" "$LOCAL_BIN/tmux-summarize"
    chmod +x "$LOCAL_BIN/tmux-summarize"
    
    success "Configuration files installed"
}

# Install plugins via TPM
install_plugins() {
    info "Installing tmux plugins (this may take a moment)..."
    
    # Source tmux config and install plugins
    if tmux list-sessions &>/dev/null; then
        tmux source "$HOME/.tmux.conf"
        "$TMUX_PLUGIN_DIR/tpm/bin/install_plugins"
    else
        # No tmux server running, start one temporarily
        tmux new-session -d -s _install_plugins
        tmux source "$HOME/.tmux.conf"
        "$TMUX_PLUGIN_DIR/tpm/bin/install_plugins"
        tmux kill-session -t _install_plugins
    fi
    
    success "Plugins installed"
}

# Verify installation
verify_installation() {
    info "Verifying installation..."
    
    local issues=0
    
    [[ -f "$HOME/.tmux.conf" ]] || { warn "~/.tmux.conf not found"; ((issues++)); }
    [[ -d "$TMUX_PLUGIN_DIR/tpm" ]] || { warn "TPM not installed"; ((issues++)); }
    [[ -x "$LOCAL_BIN/tmux-summarize" ]] || { warn "tmux-summarize not executable"; ((issues++)); }
    
    if [[ $issues -eq 0 ]]; then
        success "Installation verified"
    else
        warn "$issues issues found"
    fi
}

# Print post-install instructions
print_instructions() {
    cat <<EOF

${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}
${GREEN}Installation complete!${NC}
${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}

${BLUE}Quick Start:${NC}
  • Start new tmux session:     tmux new -s main
  • Reload config (in tmux):    prefix + C-r
  • Show keybindings:           prefix + ?  (which-key menu)
  • FZF finder:                 prefix + f

${BLUE}Key Bindings:${NC}
  • Primary prefix:             C-a
  • Secondary prefix:           C-s
  • Toggle nested mode:         F12
  • Split horizontal:           prefix + -
  • Split vertical:             prefix + |
  • Zoom pane:                  prefix + z  or  prefix + Enter
  • Navigate panes:             prefix + h/j/k/l

${BLUE}Session Logging:${NC}
  • Toggle logging:             prefix + P
  • Logs stored in:             ~/.tmux/logs/
  • Summarize session:          prefix + l, then S
  • Or directly:                tmux-summarize -r

${BLUE}For LLM summarization:${NC}
  export ANTHROPIC_API_KEY="your-key-here"

${BLUE}Vim Integration:${NC}
  Add to your nvim config for seamless navigation:
  
    -- lazy.nvim
    { "christoomey/vim-tmux-navigator" }

${BLUE}Troubleshooting:${NC}
  • Reinstall plugins:          prefix + I
  • Update plugins:             prefix + U
  • Check plugin status:        prefix + c, then I/U/C

${YELLOW}Note:${NC} If you're in a tmux session, run:
  tmux source ~/.tmux.conf

EOF
}

# Main
main() {
    echo
    echo -e "${BLUE}tmux Configuration Installer${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo
    
    check_tmux_version
    create_directories
    install_tpm
    install_configs
    install_plugins
    verify_installation
    print_instructions
}

main "$@"
