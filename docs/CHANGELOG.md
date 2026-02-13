# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2026-02-14

> Secondary MacBook sync fix and cross-device improvements

### Fixed

- **setup.sh**: Remove `set -e` that caused `adot install` to silently abort when `brew list` returns non-zero for missing packages
- **setup.sh**: Sync `VERSION` dynamically from `zshrc` ADOT_VERSION (was hardcoded `1.0.0`)
- **setup.sh**: Add post-install symlink verification with iCloud caveat warning
- **setup.sh**: Add explicit error handling for `brew install` and `git clone`
- **zshrc**: Remove hardcoded `/Users/<user>/` paths auto-appended by CodeBuddy / LM Studio; such tool paths belong in `~/.zsh/local.zsh`
- **aliases.zsh**: Rename `alias ln` to `alias lln` to avoid shadowing system `ln` command
- **README**: Fix incorrect backup path in migration guide (`~/.zshrc.backup.*` → `~/.adot_backup/`)

### Added

- **setup.sh**: `adot install` auto-creates `ai-task` symlink with relative path preference (no username dependency), falling back to `$HOME` absolute path

### Changed

- **ai-task symlink**: From absolute `/Users/<user>/...` to relative `../AI-TASK/projects/dotfiles` for cross-device stability

---

## [1.1.0] - 2026-01-30

> Zoxide migration and alias normalization

### Changed

- **plugins.zsh**: Migrate from autojump to zoxide
- **aliases.zsh**: Normalize ls aliases — keep system `ls` as default, use explicit `eza` aliases
- **path.zsh**: Standardize Android SDK path handling

---

## [1.0.0] - 2026-01-11

### Added

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

---

[1.2.0]: https://github.com/ArnoFrost/ADotFiles/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/ArnoFrost/ADotFiles/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/ArnoFrost/ADotFiles/releases/tag/v1.0.0
