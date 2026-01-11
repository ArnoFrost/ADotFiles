# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-11

> 🏷️ [Release](https://github.com/ArnoFrost/ADotFiles/releases/tag/v1.0.0) · [Compare](https://github.com/ArnoFrost/ADotFiles/commits/v1.0.0)

### Features

- **CLI Commands**: `adot install`, `adot deps`, `adot doctor`, `adot status`, `adot unlink`, `adot uninstall`, `adot restore`, `adot pull`, `adot sync`
- **Modular Config**: `core`, `path`, `plugins`, `aliases`, `functions`, `sdk`
- **Local Isolation**: Device-specific settings in `~/.zsh/local.zsh`
- **Extension Mechanism**: `.example` templates + `.local.zsh` pattern
- **Lazy Loading**: NVM/SDKMAN/Conda lazy initialization for faster startup
- **Auto Backup**: Backup existing configs before overwriting
- **Auto Detection**: Detect ADotFiles path from symlink or script location

### Modules

| Module | Description |
|--------|-------------|
| `core.zsh` | History, completion, shell options |
| `path.zsh` | PATH variables, Homebrew, language envs |
| `plugins.zsh` | Zsh plugins loading |
| `aliases.zsh` | Common aliases |
| `functions.zsh` | Utility functions |
| `sdk.zsh` | NVM/SDKMAN/Conda with lazy loading |

### Templates

- `work.zsh.example` - Work-related config template
- `path.local.zsh.example` - Personal PATH extensions
- `aliases.local.zsh.example` - Personal aliases
- `local.zsh.template` - Device-specific config

### Shell Aliases

| Alias | Description |
|-------|-------------|
| `adot` | Go to ADotFiles directory |
| `adotedit` | Open configs in editor |
| `adotlocal` | Edit local config |
| `adotreload` | Reload shell |
| `adotsave` | Git commit |
| `adotlog` | Git log |
| `adotdiff` | Git diff |
| `adotstatus` | Show status |

---

## Version Numbering

This project follows [Semantic Versioning](https://semver.org/):

- **PATCH** (x.y.Z): Bug fixes, documentation updates
- **MINOR** (x.Y.z): New features, backward compatible
- **MAJOR** (X.y.z): Breaking changes
