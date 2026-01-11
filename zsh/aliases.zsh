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

# ----- 文件操作 (现代工具优先) -----
if command -v eza &>/dev/null; then
  alias ls="eza --icons"
  alias ll="eza -l --icons"
  alias la="eza -la --icons"
  alias lt="eza -l --icons --sort=modified"
  alias tree="eza --tree --icons"
else
  alias ll="ls -alF"
  alias la="ls -A"
  alias l="ls -CF"
fi
alias ln="ls -ln"

command -v bat &>/dev/null && alias cat="bat --paging=never"

# ----- 目录导航 -----
alias ..="cd .."
alias ...="cd ../.."
alias proj="cd ~/Projects"
alias docs="cd ~/Documents"
alias desk="cd ~/Desktop"

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
[[ -f "${DOTFILES_DIR:-$HOME}/zsh/aliases.local.zsh" ]] && source "${DOTFILES_DIR:-$HOME}/zsh/aliases.local.zsh"
[[ -f "$HOME/.zsh/aliases.local.zsh" ]] && source "$HOME/.zsh/aliases.local.zsh"
