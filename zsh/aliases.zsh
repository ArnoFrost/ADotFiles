# =====================================
# 通用别名
# =====================================

# ----- 编辑器 -----
alias e="code"
alias v="vim"
alias zshrc="code ~/.zshrc"

# ----- Shell 重载 -----
alias sz="source ~/.zshrc"
alias reload="source ~/.zshrc"

# ----- 文件操作 (不覆盖 ls) -----
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias lln="ls -ln"  # 原 ln，改名避免覆盖系统命令

# eza 显式别名（可选）
if command -v eza &>/dev/null; then
  alias exa="eza --icons"
  alias exal="eza -l --icons"
  alias exaa="eza -la --icons"
  alias exat="eza --tree --icons"
  alias exam="eza -l --icons --sort=modified"
fi

command -v bat &>/dev/null && alias cat="bat --paging=never"

# ----- 目录导航 -----
alias ..="cd .."
alias ...="cd ../.."

# ----- Git -----
alias g="git"
alias ga="git add"
alias gc="git commit -m"
alias gs="git status -sb"
alias gp="git push"
alias gl="git log --oneline --graph -20"
alias gd="git diff"
alias gb="git branch -vv"

# ----- 通用工具 -----
alias cls="clear"

# ----- 本地别名扩展 -----
# 已移至 zshrc 统一加载
# 本地别名请在 ~/.zsh/local.zsh 或 ~/.zsh/aliases.local.zsh 中配置
