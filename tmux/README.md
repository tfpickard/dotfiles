# tmux Configuration — State of the Art (2026)

A modern, opinionated tmux configuration focused on discoverability, aesthetics, and
workflow efficiency. Features plugin management via TPM, self-documenting keybindings,
nested session support, and LLM-powered session summarization.

## Features

- **Plugin Management**: TPM-based with curated, maintainable plugins
- **Self-Documenting**: `tmux-which-key` modal menus for discoverable bindings
- **Nested Sessions**: Transparent SSH session handling with `F12` toggle
- **Vim Integration**: Seamless navigation via `vim-tmux-navigator`
- **Session Logging**: Automatic capture with optional LLM summarization
- **Modern Theme**: Catppuccin Mocha with informative status bar
- **Smart Defaults**: Sensible options that work across platforms

## Requirements

- tmux ≥ 3.4 (3.2+ minimum for most features)
- git
- true-color terminal (Alacritty, iTerm2, Kitty, etc.)
- For summarization: `curl`, `jq`, `ANTHROPIC_API_KEY`

## Installation

```bash
git clone <repo> ~/.config/tmux-config
cd ~/.config/tmux-config
chmod +x install.sh
./install.sh
```

Or manually:

```bash
# Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Link configuration
mkdir -p ~/.config/tmux
cp tmux.conf ~/.config/tmux/
ln -sf ~/.config/tmux/tmux.conf ~/.tmux.conf

# Install plugins (in tmux)
# prefix + I
```

## Key Bindings

### Prefixes

| Key | Function |
|-----|----------|
| `C-a` | Primary prefix |
| `C-s` | Secondary prefix (for nested sessions) |
| `F12` | Toggle nested/passthrough mode |

### Quick Reference

| Binding | Action |
|---------|--------|
| `prefix ?` | **Which-key menu** (start here!) |
| `prefix f` | FZF finder (sessions/windows/panes) |
| `prefix \|` | Split vertical |
| `prefix -` | Split horizontal |
| `prefix h/j/k/l` | Navigate panes (vim-style) |
| `prefix H/J/K/L` | Resize panes |
| `prefix z` | Zoom pane toggle |
| `prefix Enter` | Zoom pane toggle (alternate) |
| `prefix Tab` | Last pane |
| `prefix BTab` | Last window |
| `prefix s` | Choose session tree |
| `prefix w` | Choose window tree |
| `prefix S` | Sync panes toggle |
| `prefix v` | Enter copy mode |
| `prefix p` | Paste buffer |
| `prefix F` | tmux-fingers (quick selection) |

### Which-Key Menus

Press `prefix ?` to access the modal menu system:

```
w → Windows...      (create, switch, rename, kill)
p → Panes...        (split, navigate, layouts, sync)
s → Sessions...     (new, switch, rename, detach)
y → Copy/Paste...   (buffers, fingers)
r → Resize...       (grow/shrink panes)
l → Logging...      (toggle, capture, summarize)
u → Utils...        (status, mouse, clock)
c → Config...       (reload, edit, plugins)
f → FZF find...     (unified fuzzy finder)
```

### Copy Mode (vi-style)

| Binding | Action |
|---------|--------|
| `v` | Begin selection |
| `V` | Select line |
| `C-v` | Rectangle toggle |
| `y` | Copy selection |
| `Escape` | Cancel |

## Nested Sessions

When SSH'd into a remote machine running tmux, press `F12` to toggle "nested mode":

- **Normal mode**: Outer tmux receives all commands
- **Nested mode**: All keys pass through to inner tmux
  - Status bar turns red to indicate passthrough
  - Press `F12` again to return to normal mode

The status bar shows visual indicators:
- `PREFIX` (yellow): Prefix key pressed
- `NESTED` (red): Passthrough mode active
- `SSH` (orange): Running in SSH session

## Status Bar

```
┌────────────────────────────────────────────────────────────────────────┐
│ SESSION │ PREFIX │ 1  bash │ 2  nvim 🔍│ 3  htop      SSH  host  12:34 │
└────────────────────────────────────────────────────────────────────────┘
```

Left side:
- Session name (blue)
- Prefix indicator (yellow, when active)
- Nested indicator (red, when in passthrough)

Center:
- Window list with zoom indicator (🔍)

Right side:
- SSH indicator (orange, when detected)
- Hostname
- Time and date

## Session Logging

### Enable Logging

```bash
# Toggle logging for current pane
prefix + P

# Logs stored in ~/.tmux/logs/
# Format: tmux-SESSION-WINDOW-PANE-YYYYMMDD-HHMMSS.log
```

### Via Which-Key Menu

`prefix ?` → `l` (Logging):
- `l` — Toggle logging
- `s` — Screen capture (snapshot)
- `h` — Save complete history
- `c` — Clear history
- `S` — Summarize with LLM

### LLM Summarization

```bash
# Set API key
export ANTHROPIC_API_KEY="sk-ant-..."

# Summarize most recent log
tmux-summarize -r

# List available logs
tmux-summarize -l

# Summarize specific session
tmux-summarize -s myproject

# Summarize all unsummarized logs
tmux-summarize -a
```

Summaries are saved to `~/.tmux/logs/summaries/`.

## Plugins

| Plugin | Purpose |
|--------|---------|
| `tpm` | Plugin manager |
| `tmux-sensible` | Universal defaults |
| `vim-tmux-navigator` | Seamless vim/tmux navigation |
| `tmux-yank` | System clipboard integration |
| `tmux-resurrect` | Session persistence across restarts |
| `tmux-continuum` | Automatic session saving |
| `tmux-copycat` | Regex search in copy mode |
| `tmux-open` | Open URLs/files from copy mode |
| `tmux-fzf` | FZF integration |
| `tmux-fingers` | Quick hint-based selection |
| `tmux-logging` | Session logging |
| `tmux-which-key` | Discoverable keybinding menus |
| `tmux-prefix-highlight` | Visual prefix indicator |
| `tmux-cpu` | CPU/memory status |

### Plugin Management

| Command | Action |
|---------|--------|
| `prefix + I` | Install plugins |
| `prefix + U` | Update plugins |
| `prefix + alt + u` | Remove unlisted plugins |

Or via which-key: `prefix ?` → `c` → `I/U/C`

## Vim Integration

Add to your Neovim configuration for seamless pane navigation:

```lua
-- lazy.nvim
{
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
  },
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>" },
  },
}
```

## Local Overrides

Create `~/.tmux.conf.local` for machine-specific settings:

```bash
# Example: Different prefix on this machine
# set -g prefix C-Space

# Example: Custom status bar color
# set -g status-style "bg=#282a36"

# Example: Disable mouse
# set -g mouse off
```

## File Locations

```
~/.tmux.conf                    → Symlink to config
~/.config/tmux/tmux.conf        → Main configuration
~/.config/tmux/which-key.yaml   → Which-key menu definitions
~/.tmux/plugins/                → TPM plugins
~/.tmux/logs/                   → Session logs
~/.tmux/logs/summaries/         → LLM summaries
~/.local/bin/tmux-summarize     → Summarization script
```

## Troubleshooting

### Colors look wrong

Ensure your terminal supports true color and has `TERM` set correctly:

```bash
# In shell config
export TERM="xterm-256color"

# Test true color
curl -s https://raw.githubusercontent.com/JohnMorber/dotfiles/master/24-bit-color.sh | bash
```

### Plugins not loading

```bash
# Reinstall TPM
rm -rf ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Reload and install
tmux source ~/.tmux.conf
~/.tmux/plugins/tpm/bin/install_plugins
```

### vim-tmux-navigator not working

Ensure the Vim plugin is installed and that you're not overriding `C-h/j/k/l` elsewhere.

### Nested mode stuck

If `F12` doesn't restore normal mode, the keytable may be corrupted:

```bash
tmux set -u prefix
tmux set -u prefix2  
tmux set -u key-table
```

## License

MIT

## Credits

- [tmux-plugins](https://github.com/tmux-plugins) — TPM and core plugins
- [Catppuccin](https://github.com/catppuccin) — Color scheme inspiration
- [christoomey](https://github.com/christoomey) — vim-tmux-navigator
