# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.0] - 2026-02-28

> Migrate ~/.zshrc from symlink to source-stub to prevent third-party PATH pollution

### Changed

- **zshrc**: `~/.zshrc` is now a local source-stub file instead of a symlink; third-party tools (CodeBuddy, LM Studio, etc.) can safely append `export PATH=...` without polluting the shared config
- **zshrc**: ADOT_DIR detection uses `${0:A:h}` (zsh source path resolution) as primary method, symlink as compatible fallback
- **zshrc**: `adotstatus` now distinguishes source-stub / legacy symlink / unmanaged states
- **setup.sh**: `adot install` creates source-stub for `.zshrc`, keeps symlink for `.p10k.zsh`
- **setup.sh**: `adot install` auto-migrates legacy symlink to source-stub
- **setup.sh**: `adot doctor/status` separately checks `.zshrc` (expects source-stub) and `.p10k.zsh` (expects symlink)
- **setup.sh**: `adot unlink` handles both source-stub and legacy symlink
- **README**: Architecture diagram updated from `symlink` to `source`

### Migration

- Running `adot install` on existing symlink setup will automatically migrate to source-stub
- No manual action required; backward compatible with symlink mode

---

## [1.2.0] - 2026-02-14

> Secondary MacBook sync fix and cross-device improvements

### Fixed

- **setup.sh**: Remove `set -e` that caused `adot install` to silently abort when `brew list` returns non-zero for missing packages
- **setup.sh**: Sync `VERSION` dynamically from `zshrc` ADOT_VERSION (was hardcoded `1.0.0`)
- **setup.sh**: Add post-install symlink verification with iCloud caveat warning
- **setup.sh**: Add explicit error handling for `brew install` and `git clone`
- **zshrc**: Remove hardcoded tool paths (CodeBuddy / LM Studio) that were auto-appended with absolute `/Users/<username>/` prefix; such paths belong in `~/.zsh/local.zsh`
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

[1.3.0]: https://github.com/ArnoFrost/ADotFiles/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/ArnoFrost/ADotFiles/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/ArnoFrost/ADotFiles/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/ArnoFrost/ADotFiles/releases/tag/v1.0.0
