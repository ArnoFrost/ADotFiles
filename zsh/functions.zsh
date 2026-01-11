# =====================================
# 通用函数
# =====================================

# 复制当前 Git 分支名
cur() {
  git rev-parse --is-inside-work-tree &>/dev/null || { echo "不在 Git 仓库"; return 1; }
  local name=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null || git rev-parse --short HEAD)
  echo -n "$name" | pbcopy
  echo "已复制: $name"
}

# Git 分支清理
gclean() {
  git rev-parse --is-inside-work-tree &>/dev/null || { echo "不在 Git 仓库"; return 1; }
  
  local pattern="${1:-master_*}" dry_run=0
  [[ "$2" == "-n" ]] && dry_run=1
  
  local current=$(git branch --show-current)
  local protected=("main" "master" "$current")
  local branches=($(git branch --list "$pattern" --format="%(refname:short)"))
  
  local to_delete=()
  for b in "${branches[@]}"; do
    local skip=0
    for p in "${protected[@]}"; do [[ "$b" == "$p" ]] && skip=1; done
    (( skip )) || to_delete+=("$b")
  done
  
  if [[ ${#to_delete[@]} -eq 0 ]]; then
    echo "无匹配分支: $pattern"
    return 0
  fi
  
  echo "将删除 ${#to_delete[@]} 个分支:"
  printf "  %s\n" "${to_delete[@]}"
  
  if (( dry_run )); then
    echo "[预览模式]"
    return 0
  fi
  
  read -q "?确认删除? [y/N] " && echo && git branch -D "${to_delete[@]}"
}

# 快速创建并进入目录
mkcd() { mkdir -p "$1" && cd "$1"; }

# 查找进程
psg() { ps aux | grep -v grep | grep -i "$1"; }

# 端口占用查询
port() { lsof -i :"$1"; }
