# =====================================
# 插件配置
# =====================================
# 自动检测 Homebrew 路径 (Apple Silicon vs Intel)

# ----- Homebrew 前缀检测 -----
if [[ -z "${HOMEBREW_PREFIX:-}" ]]; then
  if [[ -d "/opt/homebrew" ]]; then
    HOMEBREW_PREFIX="/opt/homebrew"
  elif [[ -d "/usr/local/Homebrew" ]]; then
    HOMEBREW_PREFIX="/usr/local"
  fi
fi

# ----- 插件加载 -----
_plugin() {
  local file="$1"
  if [[ -f "$file" ]]; then
    source "$file"
    return 0
  fi
  return 1
}

# 自动补全
_plugin "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# autojump
_plugin "$HOMEBREW_PREFIX/etc/profile.d/autojump.sh"

# 语法高亮 (必须最后加载)
if [[ -d "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting" ]]; then
  export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR="$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/highlighters"
  _plugin "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

unfunction _plugin 2>/dev/null
