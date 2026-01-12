# =====================================
# ZSH 配置入口 - ADotFiles
# =====================================
# 版本: 1.0.0 | 更新: 2026-01-11
# https://github.com/ArnoFrost/ADotFiles

# ----- 路径定义 -----
# 自动检测 ADotFiles 位置: 符号链接源 > 环境变量 > 默认路径
if [[ -L "$HOME/.zshrc" ]]; then
  export ADOT_DIR="$(dirname "$(readlink "$HOME/.zshrc")")"
else
  export ADOT_DIR="${ADOT_DIR:-$HOME/ADotFiles}"
fi
export ADOT_LOCAL="$HOME/.zsh"
export ADOT_VERSION="1.0.0"

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

# ----- 便捷命令 -----
alias adot="cd \"\$ADOT_DIR\""
alias adotedit="code \"\$ADOT_DIR\""
alias adotlocal="code \"\$ADOT_LOCAL/local.zsh\""
alias adotreload="source ~/.zshrc && echo '✅ 配置已重载'"

# 版本管理
adotsave() {
  local msg="${1:-snapshot $(date +%Y-%m-%d\ %H:%M)}"
  git -C "$ADOT_DIR" add -A && git -C "$ADOT_DIR" commit -m "$msg" && echo "✅ 已保存: $msg"
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
  for f in ~/.zshrc ~/.p10k.zsh; do
    [[ -L "$f" ]] && echo "  ✅ $(basename $f) -> $(readlink $f)" || echo "  ⚠️  $(basename $f) 未链接"
  done
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


# Added by CodeBuddy CN
export PATH="/Users/<user>/.codebuddy/bin:$PATH"
