# =====================================
# 核心配置 - 所有设备通用
# =====================================

# Powerlevel10k 即时提示 (需最先加载)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 主题配置
ZSH_THEME="powerlevel10k/powerlevel10k"
[[ -f ~/powerlevel10k/powerlevel10k.zsh-theme ]] && source ~/powerlevel10k/powerlevel10k.zsh-theme

# Powerlevel10k 主题配置文件
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
