# =====================================
# ZSH 配置入口 - ADotFiles
# =====================================
# 版本: 1.3.0 | 更新: 2026-02-28
# https://github.com/ArnoFrost/ADotFiles

# ----- 路径定义 -----
# 自动检测 ADotFiles 位置: source 脚本路径 > 符号链接源 > 环境变量 > 默认路径
if [[ -n "${0:A:h}" && -f "${0:A:h}/zsh/core.zsh" ]]; then
  # 首选: 通过 source 解析脚本真实路径 (支持 source-stub 模式)
  export ADOT_DIR="${0:A:h}"
elif [[ -L "$HOME/.zshrc" ]]; then
  # 兼容: 旧版 symlink 模式
  export ADOT_DIR="$(dirname "$(readlink "$HOME/.zshrc")")"
else
  export ADOT_DIR="${ADOT_DIR:-$HOME/ADotFiles}"
fi
export ADOT_LOCAL="$HOME/.zsh"
export ADOT_VERSION="1.3.0"

# 兼容变量 (供旧脚本使用)
export DOTFILES_DIR="$ADOT_DIR"

# ----- 加载器 -----
_adot_load() {
  local name="$1" file
  [[ "$name" == "local.zsh" ]] && file="$ADOT_LOCAL/$name" || file="$ADOT_DIR/zsh/$name"
  [[ -f "$file" ]] && { source "$file"; return 0; } || return 1
}

# =====================================
# 加载顺序（依赖关系决定）
# =====================================
# 1. local.zsh 最先加载 - 设置本机变量供后续使用
_adot_load "local.zsh"

# 1.5. secret.zsh - 敏感凭证 (gitignored, 在 core 之前加载)
_adot_load "secret.zsh"

# 2. 核心配置
_adot_load "core.zsh"
_adot_load "path.zsh"
_adot_load "plugins.zsh"

# 3. 用户配置
_adot_load "aliases.zsh"
_adot_load "functions.zsh"

# 4. 可选模块（按需加载）
[[ "$ADOT_LOAD_SDK" != "false" ]] && _adot_load "sdk.zsh"
[[ "$ADOT_LOAD_WORK" != "false" ]] && _adot_load "work.zsh"

# 5. 本地扩展 (最后加载，可覆盖前面的配置)
[[ -f "$ADOT_LOCAL/aliases.local.zsh" ]] && source "$ADOT_LOCAL/aliases.local.zsh"
[[ -f "$ADOT_LOCAL/path.local.zsh" ]] && source "$ADOT_LOCAL/path.local.zsh"

# ----- 便捷命令 -----
unalias adot 2>/dev/null
adot() {
  if [[ $# -eq 0 ]]; then
    cd "$ADOT_DIR"
  else
    bash "$ADOT_DIR/setup.sh" "$@"
  fi
}
alias adotedit="code \"\$ADOT_DIR\""
alias adotlocal="code \"\$ADOT_LOCAL/local.zsh\""
alias adotreload="source ~/.zshrc && echo '✅ 配置已重载'"

# 版本管理
adotsave() {
  local msg="${1:-snapshot $(date +%Y-%m-%d\ %H:%M)}"
  git -C "$ADOT_DIR" add -u && git -C "$ADOT_DIR" commit -m "$msg" && echo "✅ 已保存: $msg"
}
adotlog() { git -C "$ADOT_DIR" log --oneline -20; }
adotdiff() { git -C "$ADOT_DIR" diff; }
adotrevert() { git -C "$ADOT_DIR" checkout -- .; echo "✅ 已还原到上次保存"; }

# 状态查看
adotstatus() {
  echo "📊 ADotFiles 状态 (v$ADOT_VERSION)"
  echo ""
  echo "配置路径:"
  echo "  ADotFiles: $ADOT_DIR"
  echo "  本地:      $ADOT_LOCAL"
  echo ""
  echo "链接状态:"
  if [[ -L "$HOME/.zshrc" ]]; then
    echo "  ⚠️  .zshrc -> symlink (旧版, 建议运行 adot install 迁移到 source-stub)"
  elif [[ -f "$HOME/.zshrc" ]] && grep -q "# ADotFiles source-stub" "$HOME/.zshrc" 2>/dev/null; then
    echo "  ✅ .zshrc -> source-stub"
  else
    echo "  ⚠️  .zshrc 未管理"
  fi
  [[ -L "$HOME/.p10k.zsh" ]] && echo "  ✅ .p10k.zsh -> $(readlink "$HOME/.p10k.zsh")" || echo "  ⚠️  .p10k.zsh 未链接"
  echo ""
  echo "已加载模块:"
  echo "  core, path, plugins, aliases, functions"
  [[ "$ADOT_LOAD_SDK" != "false" ]] && echo "  sdk" || echo "  sdk (已禁用)"
  [[ "$ADOT_LOAD_WORK" != "false" ]] && echo "  work" || echo "  work (已禁用)"
  echo ""
  [[ -n "${DEVICE_NAME:-}" ]] && echo "设备: $DEVICE_NAME"
  [[ -n "${CONDA_PREFIX:-}" ]] && echo "Conda: $CONDA_PREFIX"
}

# 清理
unfunction _adot_load 2>/dev/null

# ===== END OF ADOT CONFIG =====
# DO NOT append PATH exports below this line.
# Use ~/.zsh/local.zsh for device-specific PATH, aliases, and env vars.
