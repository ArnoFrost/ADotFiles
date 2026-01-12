# =====================================
# 插件配置
# =====================================

# Homebrew 前缀 (已在 path.zsh 中设置)
: ${HOMEBREW_PREFIX:="/opt/homebrew"}

# ----- 插件加载 -----
_plugin() { [[ -f "$1" ]] && source "$1"; }

# 自动补全
_plugin "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# autojump
_plugin "$HOMEBREW_PREFIX/etc/profile.d/autojump.sh"

# 语法高亮 (必须最后加载)
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR="$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/highlighters"
_plugin "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

unfunction _plugin 2>/dev/null
