#!/bin/sh
# Neovim 日本語チュートリアル (vim-01-beginner-ja, vim-02-beginner-ja) の配置スクリプト
# 使い方:
#   curl -fsSL https://raw.githubusercontent.com/Mokkori-Tom/nvim-tutor-ja/main/install.sh | sh
#   sh install.sh                        … 横にファイルがあればそれを使い、無ければ GitHub から取得
#   BASE_URL=https://... sh install.sh   … BASE_URL/<ファイル名> から取得
set -eu
NAMES="vim-01-beginner-ja vim-02-beginner-ja"

command -v nvim >/dev/null 2>&1 || { echo "nvim が見つかりません" >&2; exit 1; }

# 設定フォルダ (通常 ~/.config/nvim) と、判定データの形式を Neovim 自身に聞く
CONF=$(nvim --headless --clean -c 'lua io.stdout:write(vim.fn.stdpath("config"))' -c 'qa!' 2>/dev/null)
# 0.12.x 以前: 判定データは別ファイル (.tutor.json)。master(2026-05 以降): .tutor の行末 [[...]]
FMT=$(nvim --headless --clean -c 'lua io.stdout:write(vim.fn.filereadable(vim.env.VIMRUNTIME.."/tutor/en/vim-01-beginner.tutor.json")==1 and "json" or "inline")' -c 'qa!' 2>/dev/null)
[ -n "$CONF" ] || { echo "設定フォルダを取得できませんでした" >&2; exit 1; }
DEST="$CONF/tutor"
SRC_DIR=$(dirname "$0")
if [ -z "${BASE_URL:-}" ] && [ ! -f "$SRC_DIR/vim-01-beginner-ja.json.tutor" ]; then
  BASE_URL=https://raw.githubusercontent.com/Mokkori-Tom/nvim-tutor-ja/main
fi
if [ -n "${BASE_URL:-}" ]; then
  command -v curl >/dev/null 2>&1 || { echo "curl がありません (Termux: pkg install curl)" >&2; exit 1; }
fi
echo "Neovim: $(nvim --version | head -n1)  形式: $FMT  配置先: $DEST"
mkdir -p "$DEST"

fetch() {  # $1=元のファイル名 $2=配置するファイル名
  if [ -n "${BASE_URL:-}" ]; then
    curl -fsSL "$BASE_URL/$1" -o "$DEST/$2"
  else
    cp "$SRC_DIR/$1" "$DEST/$2"
  fi
}

for n in $NAMES; do
  fetch "$n.$FMT.tutor" "$n.tutor"
  if [ "$FMT" = json ]; then
    fetch "$n.tutor.json" "$n.tutor.json"
  else
    rm -f "$DEST/$n.tutor.json"   # inline 形式では不要
  fi
done
ls -l "$DEST"
echo "完了。nvim を起動して  :Tutor vim-01-beginner-ja  を実行してください (第2章は :Tutor vim-02-beginner-ja)。"
