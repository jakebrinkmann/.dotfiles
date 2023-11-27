vim.cmd([[
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Set a <Leader><Bslash> e.g. `|` key
au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>
]])
