syntax on
filetype indent plugin on
set background=dark
set nu " Line Numbers
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufWritePre *.{py,pro} :%s/^\s*__updated__\zs.*\ze/\=strftime(" = '%Y-%m-%d'")
