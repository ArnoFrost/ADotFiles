# =====================================
# PATH 环境变量
# =====================================
# 个人路径可在 local.zsh 或 path.local.zsh 中添加

# ----- 工具函数 -----
_path_prepend() { [[ -d "$1" && ":$PATH:" != *":$1:"* ]] && PATH="$1:$PATH"; }
_path_append()  { [[ -d "$1" && ":$PATH:" != *":$1:"* ]] && PATH="$PATH:$1"; }

# ----- Homebrew (自动检测架构) -----
[[ -d "/opt/homebrew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -d "/usr/local/Homebrew" ]] && eval "$(/usr/local/bin/brew shellenv)"

# ----- Android SDK -----
: ${ANDROID_HOME:="$HOME/Library/Android/sdk"}
if [[ -d "$ANDROID_HOME" ]]; then
  export ANDROID_HOME
  _path_append "$ANDROID_HOME/platform-tools"
  _path_append "$ANDROID_HOME/emulator"
  _path_append "$ANDROID_HOME/cmdline-tools/latest/bin"
fi

# ----- 语言环境 -----
# Ruby (rbenv)
command -v rbenv &>/dev/null && eval "$(rbenv init - zsh)"

# Rust
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# Go
[[ -d "$HOME/go/bin" ]] && _path_append "$HOME/go/bin"

# ----- 本地路径扩展 -----
# 加载 path.local.zsh (个人应用路径，不同步)
[[ -f "${DOTFILES_DIR:-$HOME}/zsh/path.local.zsh" ]] && source "${DOTFILES_DIR:-$HOME}/zsh/path.local.zsh"
[[ -f "$HOME/.zsh/path.local.zsh" ]] && source "$HOME/.zsh/path.local.zsh"

# 导出
export PATH

# 清理
unfunction _path_prepend _path_append 2>/dev/null
