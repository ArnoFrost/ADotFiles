#!/bin/bash
# 标准化 SDK 路径映射（写入 ~/.zsh/local.zsh）
# 用法:
#   bash scripts/sdk-setup.sh
#   bash scripts/sdk-setup.sh --work-dir "$HOME/Desktop/Work/SDK"

set -e

WORK_DIR="$HOME/Desktop/Work/SDK"
LOCAL_ZSH="$HOME/.zsh/local.zsh"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ADOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE="$ADOT_DIR/zsh/local.zsh.template"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --work-dir)
      WORK_DIR="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

mkdir -p "$HOME/.zsh"
if [[ ! -f "$LOCAL_ZSH" && -f "$TEMPLATE" ]]; then
  cp "$TEMPLATE" "$LOCAL_ZSH"
fi

BLOCK_START="# >>> ADOT SDK MAP"
BLOCK_END="# <<< ADOT SDK MAP"

SDK_BLOCK=$(cat <<EOF
$BLOCK_START
# 标准 SDK 映射（本机可调整）
export WORK_SDK_DIR="$WORK_DIR"
export ANDROID_SDK_ROOT="\$WORK_SDK_DIR/Android"
export ANDROID_HOME="\$ANDROID_SDK_ROOT"
export HARMONY_SDK_ROOT="\$WORK_SDK_DIR/Harmony"
# 可选：如需额外工具链路径
# export HARMONY_SDK_TOOLS="\$HARMONY_SDK_ROOT/toolchains"
$BLOCK_END
EOF
)

if grep -q "$BLOCK_START" "$LOCAL_ZSH"; then
  # 替换已有区块
  awk -v start="$BLOCK_START" -v end="$BLOCK_END" -v block="$SDK_BLOCK" '
    $0==start {print block; inblock=1; next}
    $0==end && inblock {inblock=0; next}
    !inblock {print}
  ' "$LOCAL_ZSH" > "$LOCAL_ZSH.tmp"
  mv "$LOCAL_ZSH.tmp" "$LOCAL_ZSH"
else
  printf "\n%s\n" "$SDK_BLOCK" >> "$LOCAL_ZSH"
fi

echo "SDK 映射已写入: $LOCAL_ZSH"
echo "Work SDK 目录: $WORK_DIR"

