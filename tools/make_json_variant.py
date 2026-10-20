#!/usr/bin/env python3
"""inline 形式 (行末 [[期待文]]) の .tutor から、Neovim 0.12.x 用の
   行末を取り除いた .tutor と .tutor.json を作る。
   判定の取り出し方は runtime/lua/nvim/tutor.lua の load_metadata() と同じ。"""
import json, re, sys

src = sys.argv[1] if len(sys.argv) > 1 else 'vim-01-beginner-ja.inline.tutor'
lines = open(src, encoding='utf-8').read().split('\n')
expect, out = {}, []
for i, line in enumerate(lines, 1):
    m = re.match(r'^(.*?)\s\[\[(.*?)\]\]$', line)
    if m:
        expect[str(i)] = -1 if m.group(2) == '-1' else m.group(2)
        out.append(m.group(1))
    else:
        out.append(line)
open('vim-01-beginner-ja.json.tutor', 'w', encoding='utf-8').write('\n'.join(out))
with open('vim-01-beginner-ja.tutor.json', 'w', encoding='utf-8') as f:
    json.dump({'expect': expect}, f, ensure_ascii=False, indent=2)
print(f'{len(expect)} 件の判定を書き出しました')
