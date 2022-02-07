#!/usr/bin/env python3
import os
import glob
import re

WIKI=os.path.expanduser('~/wiki/diary/*.mkd')
CATS=os.path.expanduser('~/.dots/TODOS.md')
TODO=os.path.expanduser('~/wiki/todo.mkd')

regex = re.compile('.*(\[.*\]) (.*)')

def read_todos(filename):
    lines = [regex.match(line.strip()) for line in open(filename).readlines()]
    lines = filter(None, lines)
    matches = [line.groups() for line in lines]
    return matches

cats = dict(read_todos(CATS))

files = sorted(glob.glob(WIKI, recursive=True))

todos = {}
for fid in files:
    lines = read_todos(fid)
    if not lines:
        continue

    mkdlink = f"[{os.path.basename(fid).replace('.mkd', '')}](./{fid.split('/wiki/')[-1]})"

    for line in lines:
        cat = cats.get(line[0])
        if cat not in todos:
            todos[cat] = {}
        if mkdlink not in todos[cat]:
            todos[cat][mkdlink] = []
        todos[cat][mkdlink].append(f"- {line[0]} {line[1]}")

content = ""
for cat, catlines in todos.items():
    added = False
    content += f"## {cat}\n"
    for mklink, lines in catlines.items():
        content += f"#### {mklink}\n"
        content += "\n".join(lines) + "\n\n"
        added = True
    if added:
        content += "\n"

open(TODO, 'w').write(content)
