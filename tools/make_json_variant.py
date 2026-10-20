#!/usr/bin/env python3
"""inline 形式 (行末 [[期待文]]) の *.inline.tutor から、Neovim 0.12.x 用の
   行末を取り除いた *.json.tutor と *.tutor.json を作る。
   判定の取り出し方は runtime/lua/nvim/tutor.lua の load_metadata() と同じ。
   引数なしならリポジトリ直下の *.inline.tutor をすべて処理する。"""
import glob, json, os, re, sys

root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
srcs = sys.argv[1:] or sorted(glob.glob(os.path.join(root, '*.inline.tutor')))
for src in srcs:
    base = src[:-len('.inline.tutor')]          # .../vim-01-beginner-ja
    lines = open(src, encoding='utf-8').read().split('\n')
    expect, out = {}, []
    for i, line in enumerate(lines, 1):
        m = re.match(r'^(.*?)\s\[\[(.*?)\]\]$', line)
        if m:
            expect[str(i)] = -1 if m.group(2) == '-1' else m.group(2)
            out.append(m.group(1))
        else:
            out.append(line)
    open(base + '.json.tutor', 'w', encoding='utf-8').write('\n'.join(out))
    with open(base + '.tutor.json', 'w', encoding='utf-8') as f:
        json.dump({'expect': expect}, f, ensure_ascii=False, indent=2)
    print(f'{os.path.basename(base)}: {len(expect)} 件の判定を書き出しました')
