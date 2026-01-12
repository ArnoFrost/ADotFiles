# =====================================
# 别名配置
# =====================================

# ----- 编辑器 -----
alias e="code"
alias v="vim"
alias zshrc="code ~/.zshrc"
alias sublime="'/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl'"
alias subz="sublime ~/.zshrc"
alias subg="sublime ~/.gitconfig"
alias subb="sublime ~/.bash_profile"
alias subh="sudo vim /etc/hosts"

# ----- Shell 重载 -----
alias sz="source ~/.zshrc"
alias sb="source ~/.bash_profile"
alias reload="source ~/.zshrc"
alias p10k="code ~/.p10k.zsh"

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

# ----- 目录 -----
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

# ----- 工具 -----
# alias python="python3"
# alias pip="pip3"
alias cls="clear"
alias sp="scrcpy"

# ----- 多媒体 -----
alias ydl='yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mp4 --cookies-from-browser chrome'
