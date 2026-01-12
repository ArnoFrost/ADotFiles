# =====================================
# SDK 管理器 (懒加载优化)
# =====================================

# ----- NVM (延迟加载) -----
export NVM_DIR="$HOME/.nvm"
# 懒加载：首次调用 nvm/node/npm 时才初始化
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  _nvm_lazy_load() {
    unfunction node npm npx nvm 2>/dev/null
    source "$NVM_DIR/nvm.sh"
    [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
  }
  node()  { _nvm_lazy_load; node  "$@"; }
  npm()   { _nvm_lazy_load; npm   "$@"; }
  npx()   { _nvm_lazy_load; npx   "$@"; }
  nvm()   { _nvm_lazy_load; nvm   "$@"; }
fi

# ----- SDKMAN -----
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# ----- Conda (自动检测) -----
_conda_init() {
  local prefix
  for prefix in "$HOME/miniforge3" "$HOME/miniconda3" "$HOME/anaconda3"; do
    [[ -d "$prefix" ]] || continue
    if [[ -f "$prefix/etc/profile.d/conda.sh" ]]; then
      source "$prefix/etc/profile.d/conda.sh"
    else
      export PATH="$prefix/bin:$PATH"
    fi
    # Mamba
    [[ -f "$prefix/bin/mamba" ]] && eval "$("$prefix/bin/mamba" shell hook --shell zsh 2>/dev/null)" 2>/dev/null
    break
  done
}
_conda_init
unfunction _conda_init 2>/dev/null
