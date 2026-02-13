# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2026-02-14

> 备用 MacBook 同步修复与跨设备优化

### Fixed

- **zshrc**: 移除 CodeBuddy / LM Studio 自动追加的硬编码 `/Users/<user>/` 路径，此类工具路径应配置在 `~/.zsh/local.zsh`
- **aliases.zsh**: `alias ln` 重命名为 `alias lln`，避免覆盖系统 `ln` 命令

### Added

- **setup.sh**: `adot install` 自动创建 `ai-task` 软链接，优先使用相对路径（无用户名依赖），兜底使用 `$HOME` 绝对路径

### Changed

- **ai-task symlink**: 从绝对路径 `/Users/<user>/...` 改为相对路径 `../AI-TASK/projects/dotfiles`，跨设备稳定

---

## [1.1.0] - 2026-01-30

> zoxide 迁移与别名规范化

### Changed

- **plugins.zsh**: 从 autojump 迁移到 zoxide
- **aliases.zsh**: ls 别名规范化，保留系统 `ls`，eza 使用显式别名
- **path.zsh**: 标准化 Android SDK 路径处理

---

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
