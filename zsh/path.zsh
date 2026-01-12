# =====================================
# PATH 环境变量
# =====================================
# 变量可在 local.zsh 中预先覆盖

# ----- 工具函数 -----
_path_prepend() { [[ -d "$1" && ":$PATH:" != *":$1:"* ]] && PATH="$1:$PATH"; }
_path_append()  { [[ -d "$1" && ":$PATH:" != *":$1:"* ]] && PATH="$PATH:$1"; }

# ----- Homebrew (自动检测架构) -----
[[ -d "/opt/homebrew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -d "/usr/local/Homebrew" ]] && eval "$(/usr/local/bin/brew shellenv)"

# ----- Android SDK -----
: ${ANDROID_HOME:="$HOME/Library/Android/sdk"}
export ANDROID_HOME
_path_append "$ANDROID_HOME/platform-tools"
_path_append "$ANDROID_HOME/emulator"
_path_append "$ANDROID_HOME/cmdline-tools/latest/bin"

# ----- 语言环境 -----
# Ruby
command -v rbenv &>/dev/null && eval "$(rbenv init - zsh)"

# Rust
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# Go
[[ -d "$HOME/go/bin" ]] && _path_append "$HOME/go/bin"

# ----- 应用程序 -----
_path_prepend "$HOME/.codebuddy/bin"
_path_append "$HOME/.lmstudio/bin"
_path_prepend "/opt/homebrew/opt/qt@5/bin"

# 导出
export PATH

# 清理
unfunction _path_prepend _path_append 2>/dev/null
