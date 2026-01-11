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

# ----- Conda/Miniconda/Miniforge (自动检测) -----
# 支持路径优先级: local.zsh 自定义 > miniforge > miniconda > anaconda
# 推荐使用 miniconda (开源免费) 或 miniforge (Apple Silicon 优化)
_conda_init() {
  # 如果在 local.zsh 中已设置 CONDA_PREFIX，优先使用
  local prefix
  local search_paths=(
    "${CONDA_PREFIX:-}"           # local.zsh 自定义路径
    "$HOME/miniforge3"            # Miniforge (推荐 Apple Silicon)
    "$HOME/miniconda3"            # Miniconda (推荐，开源免费)
    "$HOME/mambaforge"            # Mambaforge
    "$HOME/anaconda3"             # Anaconda (用户目录)
    "/opt/miniconda3"             # Miniconda (系统级)
    "/opt/miniforge3"             # Miniforge (系统级)
    "/opt/anaconda3"              # Anaconda (系统级，商业版)
  )
  
  for prefix in "${search_paths[@]}"; do
    [[ -z "$prefix" || ! -d "$prefix" ]] && continue
    
    # 初始化 Conda
    if [[ -f "$prefix/etc/profile.d/conda.sh" ]]; then
      source "$prefix/etc/profile.d/conda.sh"
    else
      export PATH="$prefix/bin:$PATH"
    fi
    
    # Mamba (更快的包管理器)
    if [[ -f "$prefix/bin/mamba" ]]; then
      eval "$("$prefix/bin/mamba" shell hook --shell zsh 2>/dev/null)" 2>/dev/null
    fi
    
    # 导出使用的 Conda 路径 (供其他脚本使用)
    export CONDA_PREFIX="$prefix"
    break
  done
}
_conda_init
unfunction _conda_init 2>/dev/null

# ----- Conda 便捷命令 -----
# 快速激活/停用环境
alias ca="conda activate"
alias cda="conda deactivate"
alias cel="conda env list"
alias cil="conda list"

# 创建环境 (用法: cnew myenv python=3.11)
cnew() {
  local name="$1"
  shift
  [[ -z "$name" ]] && { echo "用法: cnew <env_name> [packages...]"; return 1; }
  conda create -n "$name" "$@"
}

# 删除环境
crm() {
  local name="$1"
  [[ -z "$name" ]] && { echo "用法: crm <env_name>"; return 1; }
  conda env remove -n "$name"
}
