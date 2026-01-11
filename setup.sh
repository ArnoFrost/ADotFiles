#!/bin/bash
# =====================================
# ADotFiles CLI
# =====================================
# 版本: 1.0.0 | 更新: 2026-01-11
# 
# 模块化 Zsh 配置框架
# https://github.com/ArnoFrost/ADotFiles
#
# 用法: adot <command> [options]

set -e

# =====================================
# 配置
# =====================================
VERSION="1.0.0"
# 自动检测: 脚本所在目录 > 环境变量 > 默认路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ADOT_DIR="${ADOT_DIR:-$SCRIPT_DIR}"
BACKUP_DIR="$HOME/.adot_backup"
DRY_RUN=false

# =====================================
# 颜色
# =====================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# =====================================
# 日志
# =====================================
log_info()  { echo -e "${BLUE}›${NC} $1"; }
log_ok()    { echo -e "${GREEN}✓${NC} $1"; }
log_warn()  { echo -e "${YELLOW}!${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1"; }
log_dry()   { echo -e "${DIM}[dry]${NC} $1"; }
log_title() { echo -e "\n${BOLD}$1${NC}"; }

# =====================================
# 系统检测
# =====================================
detect_system() {
  [[ "$(uname -s)" != "Darwin" ]] && { log_error "仅支持 macOS"; exit 1; }
  
  if [[ "$(uname -m)" == "arm64" ]]; then
    HOMEBREW_PREFIX="/opt/homebrew"
    CHIP="Apple Silicon"
  else
    HOMEBREW_PREFIX="/usr/local"
    CHIP="Intel"
  fi
}

# =====================================
# 依赖定义
# =====================================
BREW_DEPS=(eza bat autojump zsh-autosuggestions zsh-syntax-highlighting)
BREW_OPTIONAL=(fd ripgrep fzf tldr)

# =====================================
# 工具函数
# =====================================
is_icloud_link() {
  local target=$(readlink "$1" 2>/dev/null)
  [[ "$target" == *"Mobile Documents"* || "$target" == *"iCloud"* ]]
}

check_adot() {
  [[ ! -d "$ADOT_DIR" ]] && { log_error "ADotFiles 目录不存在: $ADOT_DIR"; exit 1; }
  for f in zshrc p10k.zsh zsh/core.zsh; do
    [[ ! -f "$ADOT_DIR/$f" ]] && { log_error "文件缺失: $f"; exit 1; }
  done
}

check_brew() {
  command -v brew &>/dev/null || { log_error "Homebrew 未安装"; return 1; }
}

backup_file() {
  local file="$1"
  [[ -f "$file" && ! -L "$file" ]] || return 0
  mkdir -p "$BACKUP_DIR"
  cp "$file" "$BACKUP_DIR/$(basename "$file").$(date +%Y%m%d_%H%M%S)"
}

# =====================================
# install - 完整安装
# =====================================
cmd_install() {
  log_title "Installing ADotFiles..."
  echo -e "${DIM}System: macOS ($CHIP)${NC}"
  
  $DRY_RUN && log_warn "Dry run mode"
  
  check_adot
  
  # 依赖
  log_title "Dependencies"
  check_brew || exit 1
  
  local missing=()
  for dep in "${BREW_DEPS[@]}"; do
    brew list "$dep" &>/dev/null && log_ok "$dep" || { log_warn "$dep"; missing+=("$dep"); }
  done
  
  if [[ ${#missing[@]} -gt 0 ]]; then
    $DRY_RUN && log_dry "brew install ${missing[*]}" || {
      brew install "${missing[@]}"
      log_ok "Dependencies installed"
    }
  fi
  
  # Powerlevel10k
  if [[ ! -d "$HOME/powerlevel10k" ]]; then
    $DRY_RUN && log_dry "Install powerlevel10k" || {
      git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
      log_ok "Powerlevel10k"
    }
  else
    log_ok "Powerlevel10k"
  fi
  
  # 链接
  log_title "Linking"
  for pair in "zshrc:.zshrc" "p10k.zsh:.p10k.zsh"; do
    src="$ADOT_DIR/${pair%%:*}"
    dst="$HOME/${pair##*:}"
    $DRY_RUN && log_dry "$dst -> ADotFiles" || {
      backup_file "$dst"
      ln -sf "$src" "$dst"
      log_ok "$dst"
    }
  done
  
  # 本地配置
  mkdir -p "$HOME/.zsh"
  if [[ ! -f "$HOME/.zsh/local.zsh" ]]; then
    $DRY_RUN && log_dry "Create ~/.zsh/local.zsh" || {
      cp "$ADOT_DIR/zsh/local.zsh.template" "$HOME/.zsh/local.zsh"
      local name=$(scutil --get ComputerName 2>/dev/null || hostname -s)
      sed -i '' "s/DEVICE_NAME=\"MacBook\"/DEVICE_NAME=\"$name\"/" "$HOME/.zsh/local.zsh"
      log_ok "~/.zsh/local.zsh"
      log_warn "Edit ~/.zsh/local.zsh to customize"
    }
  fi
  
  $DRY_RUN && return
  
  log_title "Done!"
  echo "Run: source ~/.zshrc"
}

# =====================================
# deps - 仅安装依赖
# =====================================
cmd_deps() {
  log_title "Installing dependencies..."
  check_brew || exit 1
  
  local missing=()
  for dep in "${BREW_DEPS[@]}"; do
    brew list "$dep" &>/dev/null || missing+=("$dep")
  done
  
  [[ ${#missing[@]} -eq 0 ]] && { log_ok "All dependencies installed"; return; }
  
  $DRY_RUN && log_dry "brew install ${missing[*]}" || {
    brew install "${missing[@]}"
    log_ok "Installed: ${missing[*]}"
  }
}

# =====================================
# doctor - 综合诊断
# =====================================
cmd_doctor() {
  log_title "System"
  echo "  macOS $(sw_vers -productVersion) ($CHIP)"
  echo "  Zsh $(zsh --version | awk '{print $2}')"
  
  log_title "Links"
  for file in "$HOME/.zshrc" "$HOME/.p10k.zsh"; do
    if [[ -L "$file" ]]; then
      is_icloud_link "$file" && log_ok "$(basename $file) → iCloud" || log_warn "$(basename $file) → $(readlink $file)"
    elif [[ -f "$file" ]]; then
      log_warn "$(basename $file) (not linked)"
    else
      log_error "$(basename $file) missing"
    fi
  done
  [[ -f "$HOME/.zsh/local.zsh" ]] && log_ok "local.zsh" || log_warn "local.zsh missing"
  
  log_title "Dependencies"
  local missing=()
  for dep in "${BREW_DEPS[@]}"; do
    brew list "$dep" &>/dev/null && log_ok "$dep" || { log_error "$dep"; missing+=("$dep"); }
  done
  
  log_title "Optional"
  for dep in "${BREW_OPTIONAL[@]}"; do
    brew list "$dep" &>/dev/null && log_ok "$dep" || log_info "$dep (not installed)"
  done
  
  log_title "SDKs"
  [[ -d "$HOME/.nvm" ]] && log_ok "NVM" || log_info "NVM"
  [[ -d "$HOME/.sdkman" ]] && log_ok "SDKMAN" || log_info "SDKMAN"
  for p in ~/miniconda3 ~/miniforge3 ~/anaconda3; do
    [[ -d "$p" ]] && { log_ok "Conda (${p##*/})"; break; } 
  done
  
  log_title "Git"
  if [[ -d "$ADOT_DIR/.git" ]]; then
    local changes=$(git -C "$ADOT_DIR" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    [[ "$changes" == "0" ]] && log_ok "Clean" || log_warn "$changes uncommitted changes"
  else
    log_warn "Not a git repo"
  fi
  
  [[ ${#missing[@]} -gt 0 ]] && { echo ""; log_warn "Fix: brew install ${missing[*]}"; }
}

# =====================================
# status - 链接状态
# =====================================
cmd_status() {
  log_title "Status"
  for file in "$HOME/.zshrc" "$HOME/.p10k.zsh"; do
    if [[ -L "$file" ]]; then
      is_icloud_link "$file" && log_ok "$(basename $file) → iCloud" || log_warn "$(basename $file) → $(readlink $file)"
    elif [[ -f "$file" ]]; then
      log_info "$(basename $file) (standalone)"
    else
      log_error "$(basename $file) missing"
    fi
  done
  [[ -f "$HOME/.zsh/local.zsh" ]] && log_ok "local.zsh configured" || log_warn "local.zsh not found"
}

# =====================================
# unlink - 取消链接
# =====================================
cmd_unlink() {
  log_title "Unlinking..."
  
  for file in "$HOME/.zshrc" "$HOME/.p10k.zsh"; do
    [[ ! -L "$file" ]] && { log_info "$(basename $file) not a link"; continue; }
    
    $DRY_RUN && { log_dry "Unlink $file"; continue; }
    
    rm "$file"
    local backup=$(ls -t "$BACKUP_DIR/$(basename $file)."* 2>/dev/null | head -1)
    if [[ -f "$backup" ]]; then
      cp "$backup" "$file"
      log_ok "$(basename $file) restored from backup"
    else
      touch "$file"
      log_warn "$(basename $file) unlinked (no backup)"
    fi
  done
}

# =====================================
# uninstall - 完全卸载
# =====================================
cmd_uninstall() {
  log_title "Uninstalling..."
  echo "This will:"
  echo "  • Unlink config files"
  echo "  • Remove ~/.zsh"
  echo "  • Remove ~/powerlevel10k"
  echo ""
  log_info "Backups in $BACKUP_DIR will be kept"
  echo ""
  
  $DRY_RUN && { log_dry "Would uninstall"; return; }
  
  read -p "Continue? [y/N] " -n 1 -r
  echo
  [[ ! $REPLY =~ ^[Yy]$ ]] && { log_info "Cancelled"; return; }
  
  cmd_unlink
  
  [[ -d "$HOME/.zsh" ]] && { rm -rf "$HOME/.zsh"; log_ok "Removed ~/.zsh"; }
  [[ -d "$HOME/powerlevel10k" ]] && { rm -rf "$HOME/powerlevel10k"; log_ok "Removed ~/powerlevel10k"; }
  
  log_title "Done!"
  echo "Homebrew packages not removed. To clean:"
  echo "  brew uninstall ${BREW_DEPS[*]}"
}

# =====================================
# restore - 从备份恢复
# =====================================
cmd_restore() {
  log_title "Backups"
  
  [[ ! -d "$BACKUP_DIR" ]] && { log_info "No backups found"; return; }
  
  local files=($(ls -1 "$BACKUP_DIR" 2>/dev/null))
  [[ ${#files[@]} -eq 0 ]] && { log_info "No backups found"; return; }
  
  local i=1
  for f in "${files[@]}"; do
    echo "  $i) $f"
    ((i++))
  done
  echo ""
  
  read -p "Select file (number/name/q): " choice
  [[ "$choice" == "q" ]] && return
  
  local filename
  [[ "$choice" =~ ^[0-9]+$ ]] && filename="${files[$((choice-1))]}" || filename="$choice"
  
  [[ ! -f "$BACKUP_DIR/$filename" ]] && { log_error "File not found: $filename"; return 1; }
  
  local target="$HOME/.${filename%%.*}"
  $DRY_RUN && { log_dry "Restore $filename → $target"; return; }
  
  cp "$BACKUP_DIR/$filename" "$target"
  log_ok "Restored: $target"
}

# =====================================
# pull - 拉取更新
# =====================================
cmd_pull() {
  log_title "Pulling updates..."
  
  [[ ! -d "$ADOT_DIR/.git" ]] && { log_error "Not a git repo"; return 1; }
  
  local status=$(git -C "$ADOT_DIR" status --porcelain 2>/dev/null)
  if [[ -n "$status" ]]; then
    log_warn "Uncommitted changes, stashing..."
    git -C "$ADOT_DIR" stash push -m "auto-stash"
  fi
  
  git -C "$ADOT_DIR" pull --rebase
  
  [[ -n "$status" ]] && { git -C "$ADOT_DIR" stash pop; log_info "Restored stashed changes"; }
  
  log_ok "Updated"
  echo "Run: source ~/.zshrc"
}

# =====================================
# sync - 同步到远程
# =====================================
cmd_sync() {
  log_title "Syncing..."
  
  [[ ! -d "$ADOT_DIR/.git" ]] && { log_error "Not a git repo"; return 1; }
  
  local remote=$(git -C "$ADOT_DIR" remote 2>/dev/null | head -1)
  [[ -z "$remote" ]] && { log_error "No remote configured"; return 1; }
  
  local status=$(git -C "$ADOT_DIR" status --porcelain 2>/dev/null)
  if [[ -n "$status" ]]; then
    echo "$status"
    echo ""
    read -p "Commit message: " msg
    git -C "$ADOT_DIR" add -A
    git -C "$ADOT_DIR" commit -m "${msg:-update}"
    log_ok "Committed"
  fi
  
  git -C "$ADOT_DIR" push
  log_ok "Synced"
}

# =====================================
# help - 帮助
# =====================================
cmd_help() {
  cat << EOF
${BOLD}adot${NC} v$VERSION - ADotFiles CLI

${BOLD}USAGE${NC}
    adot <command> [options]

${BOLD}COMMANDS${NC}
    install     Install ADotFiles (link + deps)
    deps        Install dependencies only
    doctor      Run diagnostics
    status      Show link status

    unlink      Unlink configs (restore from backup)
    uninstall   Full uninstall
    restore     Restore from backup interactively

    pull        Pull updates from remote
    sync        Commit and push to remote

    help        Show this help
    version     Show version

${BOLD}OPTIONS${NC}
    --dry-run   Preview without executing

${BOLD}EXAMPLES${NC}
    adot install            # Full install
    adot install --dry-run  # Preview install
    adot doctor             # Check health
    adot unlink             # Unlink and restore
    adot sync               # Commit and push

${BOLD}QUICK COMMANDS${NC} (after install)
    adot        Go to ADotFiles directory
    adotedit    Edit configs
    adotlocal   Edit local config
    adotreload  Reload shell
    adotsave    Git commit and push
EOF
}

# =====================================
# 主入口
# =====================================
detect_system

# 解析全局选项
for arg in "$@"; do
  [[ "$arg" == "--dry-run" ]] && DRY_RUN=true
done

# 移除 --dry-run 后的参数
args=()
for arg in "$@"; do
  [[ "$arg" != "--dry-run" ]] && args+=("$arg")
done
set -- "${args[@]}"

case "${1:-help}" in
  install)   cmd_install ;;
  deps)      cmd_deps ;;
  doctor)    cmd_doctor ;;
  status)    cmd_status ;;
  unlink)    cmd_unlink ;;
  uninstall) cmd_uninstall ;;
  restore)   cmd_restore ;;
  pull)      cmd_pull ;;
  sync)      cmd_sync ;;
  help|-h|--help) cmd_help ;;
  version|-v|--version) echo "adot v$VERSION" ;;
  *) log_error "Unknown command: $1"; echo ""; cmd_help; exit 1 ;;
esac
