# AGENTS.md

## Overview

This document provides guidance for AI agents (like Claude, GitHub Copilot, Cursor, etc.) working with this dotfiles repository.

## Repository Structure

This is a dotfiles repository for managing configuration files across systems. The structure follows a simple flat organization where configuration files are stored at the root level.

### Current Files

- `.tmux.conf` - Tmux configuration with plugins and sensible defaults
- `AGENTS.md` - This file, containing guidelines for AI agents
- `CLAUDE.md` - Claude-specific guidelines and context

## Guidelines for AI Agents

### General Principles

1. **Preserve User Preferences**: Do not modify or remove existing configurations without explicit user request
2. **Document Changes**: When making changes, update relevant documentation
3. **Follow Conventions**: Maintain consistency with existing configuration style
4. **Test Before Committing**: Validate syntax and functionality when possible
5. **Explain Decisions**: Provide clear reasoning for configuration choices

### Configuration Best Practices

#### Tmux Configuration

- Keep explicit sensible defaults (avoid opaque "sensible" plugins)
- Use TPM (Tmux Plugin Manager) for plugin management
- Document key bindings and non-obvious settings
- Prefer modern, well-maintained plugins
- Include comments for complex or non-standard configurations

#### Version Control

- Use clear, descriptive commit messages
- Group related changes in single commits
- Avoid committing sensitive information (tokens, passwords, etc.)
- Include .gitignore for system-specific files

#### Cross-Platform Compatibility

- Consider macOS, Linux, and WSL differences
- Use conditional logic for platform-specific settings when needed
- Document any platform-specific requirements

### Common Tasks

#### Adding New Configurations

1. Research current best practices for the tool
2. Start with sensible defaults
3. Add configuration file to repository root
4. Update this document with structure/guidelines
5. Document any dependencies or installation steps

#### Modifying Existing Configurations

1. Read the existing configuration completely
2. Understand the current setup before making changes
3. Preserve user customizations
4. Test changes when possible
5. Document what changed and why

#### Plugin Management

- Prefer well-maintained, popular plugins
- Document plugin purposes and configurations
- Include installation instructions
- Note any plugin dependencies

### Security Considerations

- Never commit secrets, API keys, or passwords
- Use environment variables for sensitive data
- Review changes for accidental exposure of private information
- Consider using tools like `git-secrets` for protection

## Tool-Specific Notes

### Tmux

- Plugin manager: TPM (Tmux Plugin Manager)
- Theme: PowerKit with Tokyo Night variant
- Key binding helper: tmux-whichkey
- Reload config: `prefix + r` (where prefix is `C-a`)

### Installation Requirements

For new systems, users may need to:

1. Install tmux: `brew install tmux` (macOS) or `apt install tmux` (Ubuntu)
2. Clone this repository to `~/.dotfiles` or desired location
3. Symlink configuration files to home directory
4. Install TPM: Handled automatically by .tmux.conf
5. Install plugins: `prefix + I` in tmux

## Questions to Ask

Before making significant changes, AI agents should consider asking:

- "Would you like me to add a backup of the current configuration?"
- "Should this work across multiple platforms (macOS/Linux)?"
- "Are there any specific tools or workflows this needs to integrate with?"
- "Do you have preferences for plugin choices?"

## Resources

- [GNU Stow](https://www.gnu.org/software/stow/) - Symlink farm manager for dotfiles
- [Chezmoi](https://www.chezmoi.io/) - Dotfiles manager with templating
- [Dotbot](https://github.com/anishathalye/dotbot) - Tool for installing dotfiles
- [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles) - Curated list of dotfiles resources

## Maintenance Notes

- Last major update: 2025-12-15
- Primary maintainer: User
- Primary AI assistant: Claude
- Review cycle: As needed
