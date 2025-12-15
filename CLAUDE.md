# CLAUDE.md

## Claude-Specific Guidelines

This document contains specific instructions and context for Claude (Anthropic's AI assistant) when working with this dotfiles repository.

## Session Context

### Repository Purpose

This is a personal dotfiles repository for managing development environment configurations across different machines. The primary goal is to maintain consistent, reproducible development environments.

### Key Priorities

1. **Simplicity**: Keep configurations understandable and maintainable
2. **Explicitness**: Avoid "magic" configurations; make choices explicit
3. **Documentation**: Every non-obvious decision should be documented
4. **Plugin-Based**: Prefer plugins over manual implementations when sensible
5. **Modularity**: Organize configurations by tool/purpose

## Working with This Repository

### File Organization

Currently using a flat structure at the repository root:
- Configuration files (`.tmux.conf`, `.zshrc`, etc.)
- Documentation files (`README.md`, `AGENTS.md`, `CLAUDE.md`)
- Utility scripts (if needed, in `scripts/` directory)

### Development Workflow

When working on this repository:

1. **Read First**: Always read existing configurations before modifying
2. **Maintain Style**: Follow existing commenting and organization patterns
3. **Test Locally**: Validate syntax when possible
4. **Document Changes**: Update comments and documentation
5. **Commit Clearly**: Use descriptive commit messages

### Tmux Configuration Philosophy

The .tmux.conf follows these principles:

- **No "Sensible" Plugin**: Instead of using tmux-sensible plugin, we explicitly define all sensible defaults with clear comments
- **Plugin-Based Features**: Use plugins for complex features (theming, session management, etc.)
- **Vim-Like Bindings**: Prefer vim-style navigation (hjkl) for consistency
- **Modern Defaults**: Use contemporary best practices (256 color, mouse support, etc.)

### Key Design Decisions

#### Why Explicit Sensible Defaults?

Rather than using `tmux-plugins/tmux-sensible`, we explicitly set:
- Prefix key (`C-a` instead of `C-b`)
- Window/pane numbering (starting at 1)
- Scrollback buffer size
- Mouse support
- Vi mode keys

**Reasoning**: Makes the configuration self-documenting and easier to customize without hunting through plugin source code.

#### Plugin Choices

- **PowerKit**: Modern, actively maintained theme engine with tokyo-night aesthetic
- **tmux-whichkey**: Discoverable keybindings (similar to which-key in vim)
- **tmux-resurrect + continuum**: Session persistence across reboots
- **tmux-yank**: Better clipboard integration
- **vim-tmux-navigator**: Seamless vim/tmux pane switching

### Common Operations

#### Adding New Configuration Files

```bash
# Add new dotfile
touch ~/.dotfiles/.newconfig

# Symlink to home directory (manual)
ln -s ~/.dotfiles/.newconfig ~/.newconfig

# Or use a dotfile manager (chezmoi, stow, etc.)
```

#### Modifying Tmux Config

```bash
# Edit configuration
vim ~/.dotfiles/.tmux.conf

# Reload in tmux session
tmux source ~/.tmux.conf
# Or use: prefix + r (bound in config)
```

#### Managing Plugins

```bash
# Install/Update plugins
# In tmux: prefix + I (install)
# In tmux: prefix + U (update)
# In tmux: prefix + alt + u (uninstall)
```

## Response Guidelines

### When Helping with Configurations

1. **Explain Why**: Don't just provide configurations, explain the reasoning
2. **Show Alternatives**: Present options when multiple valid approaches exist
3. **Consider Platform**: Note any macOS/Linux/WSL differences
4. **Security First**: Never suggest storing secrets in plain text
5. **Link Resources**: Provide links to documentation for complex setups

### When Making Changes

Before modifying files:
- Confirm the change aligns with the repository's philosophy
- Check for breaking changes or incompatibilities
- Consider cross-platform implications
- Update documentation to reflect changes

After making changes:
- Summarize what changed and why
- Note any required user actions (install dependencies, reload configs, etc.)
- Suggest testing steps

### Code Review Checklist

When reviewing or creating configurations:

- [ ] Are all settings commented clearly?
- [ ] Are there any hardcoded paths that should be variables?
- [ ] Are any secrets or personal info included?
- [ ] Does this work on both macOS and Linux?
- [ ] Are there any deprecated options/plugins?
- [ ] Is documentation updated?
- [ ] Are there any new dependencies to document?

## Useful Context

### User Environment Assumptions

- Primary OS: Likely Linux/macOS (based on tmux usage)
- Terminal: Supports 256 colors and true color
- Shell: Likely zsh or bash
- Editor: Likely vim/neovim (based on vim-tmux-navigator plugin)
- Development: Software engineering focused

### Tools Likely in Use

Based on current configuration:
- tmux (obviously)
- git
- vim/neovim
- Modern terminal emulator

May also use:
- Docker/Kubernetes (PowerKit includes K8s plugin)
- Cloud providers (AWS/GCP/Azure)
- Node.js/Python/Go (common dev environments)

## Future Considerations

### Potential Additions

- Shell configuration (.zshrc, .bashrc)
- Git configuration (.gitconfig, .gitignore_global)
- Vim/Neovim configuration
- Editor configs (.editorconfig)
- Development tool configs (.eslintrc, .prettierrc, etc.)
- SSH config
- GPG config

### Potential Improvements

- Add dotfile installation script
- Add platform detection and conditional loading
- Set up automated testing for configs
- Create bootstrap script for new machines
- Add backup/restore functionality

## Communication Preferences

When working with this repository, Claude should:

- Use technical but clear language
- Provide practical, actionable advice
- Explain trade-offs between different approaches
- Ask clarifying questions when requirements are ambiguous
- Suggest modern best practices while respecting user preferences
- Be concise but thorough in explanations

## Resources & References

### Tmux

- [Tmux Manual](https://man7.org/linux/man-pages/man1/tmux.1.html)
- [TPM GitHub](https://github.com/tmux-plugins/tpm)
- [Awesome Tmux](https://github.com/rothgar/awesome-tmux)

### Dotfiles Management

- [Dotfiles Guide](https://dotfiles.github.io/)
- [Chezmoi](https://www.chezmoi.io/)
- [GNU Stow](https://www.gnu.org/software/stow/)

### Best Practices

- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
- [The Art of Command Line](https://github.com/jlevy/the-art-of-command-line)

---

**Note**: This document should evolve as the repository grows and patterns emerge. Update it regularly to reflect current practices and lessons learned.
