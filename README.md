# nvim-tutor-ja

Neovim の `:Tutor`（第1章 `vim-01-beginner`、第2章 `vim-02-beginner`）を平易な日本語に訳したものです。
Termux（Android）のようにロケールが使えない環境でも、`:Tutor vim-01-beginner-ja` で開けます。

## インストール

```sh
curl -fsSL https://raw.githubusercontent.com/Mokkori-Tom/nvim-tutor-ja/main/install.sh | sh
```

Termux で curl が無い場合は先に `pkg install curl` を実行してください。

`install.sh` は Neovim の版を調べ、合う形式のファイルを
`stdpath("config")/tutor/`（ふつうは `~/.config/nvim/tutor/`）に置きます。
Neovim を更新したら、もう一度実行してください。

## 使い方

```vim
:Tutor vim-01-beginner-ja   " 第1章: カーソル移動、削除、挿入、検索、置換など
:Tutor vim-02-beginner-ja   " 第2章: テキストオブジェクト、レジスタ、マーク
```

左に ✗ が付いた行を直すと ✓ に変わります。章の最後や最初のリンクから、もう一方の章（日本語版）へ移れます。

## なぜ別名のファイルなのか

- Neovim には公式の日本語訳 `$VIMRUNTIME/tutor/ja/vim-01-beginner.tutor` も入っています。
  ただし `:Tutor` は言語設定（`v:lang` / `$LANG`）を見て `tutor/ja/` を選ぶので、
  ロケールが使えない Termux などでは英語版が開きます。
- このリポジトリの訳は、言語設定に関係なく探される `tutor/` 直下に、別名で置きます。
  公式訳とは別に英語版から訳したもので、専門用語を減らし、短い説明を添えています。
- ✗/✓ の付く練習用の行は英語のままです。日本語は単語が空白で区切られないため、
  `w` `e` `dw` `ce` などの単語単位の動きが分かりにくくなるからです。

## ファイルと Neovim の版

判定データ（✗/✓ の正解）の置き場所は、Neovim の版によって違います。

| Neovim | 判定データ | 使うファイル |
|---|---|---|
| 0.12.x 以前 | 別ファイル `<名前>.tutor.json` | `*.json.tutor` と `*.tutor.json` |
| 0.13（開発版）以降 | `.tutor` の各行末の ` [[正解]]` | `*.inline.tutor` |

形式が合わないと ✗/✓ が出ません。`install.sh` はこれを自動で選びます。
根拠は Neovim の `runtime/autoload/tutor.vim` と `runtime/lua/nvim/tutor.lua` で、
master では neovim/neovim#39714 で形式が変わりました。

編集するのは `*.inline.tutor` だけです。0.12.x 用のファイルは次のコマンドで作り直せます。

```sh
python3 tools/make_json_variant.py
```

## 確認済みの環境

ヘッドレス実行で、次の版で確認しました。
- Neovim v0.12.6：Termux の neovim パッケージと同じ版。公式の Linux ビルドで確認
- Neovim v0.13.0-dev（nightly）

確認したのは、`:Tutor vim-01-beginner-ja` がエラーなく開くこと（`LANG=C`）と、
練習を解くと ✗ が ✓ に変わること（第1章 1.3、第2章 2.1.2・2.1.3）、章どうしのリンクです。
判定の正解データは、2章とも英語の公式版と同じです。Termux の実機ではまだ試していません。

Neovim 0.12.x では、一度開いた章へ戻ると左の印が二重に付くことがあります。
英語の公式版でも同じなので、Neovim 側の挙動です（0.13 の開発版では起きません）。
印がおかしいときは、`:bwipeout!` で閉じてから `:Tutor vim-02-beginner-ja` などで開き直すと元に戻ります（0.12.6 で確認）。

## ライセンス

英語版の原本は Neovim の `runtime/tutor/en/vim-01-beginner.tutor` です。
元は Vim の vimtutor で、Michael C. Pierce と Robert K. Ware が書き、
Bram Moolenaar、Felipe Morales、Rory Nesbitt が手直ししました。
第2章の原本は `runtime/tutor/en/vim-02-beginner.tutor` で、Paul D. Parker と Christian Brabandt が書き、
Restorer が手直ししました。
この翻訳には Neovim のライセンス（Apache 2.0、Vim 由来の部分は Vim ライセンス）が適用されます。
全文は [LICENSE.txt](LICENSE.txt) を見てください。
