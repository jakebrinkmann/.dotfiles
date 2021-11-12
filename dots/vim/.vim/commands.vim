" remove trailing white space
command Nows :%s/\s\+$//e
" remove blank lines
command Nobl :g/^\s*$/d
" change double-quote to single
command Nodq :s/"/'/g
" <S-J> would be so useful... but I remapped it
command Join :s/\n\s*//
" make current buffer executable
command Chmodx :!chmod a+x %
" fix syntax highlighting
command FixSyntax :syntax sync fromstart
" Usually, trying to write (not fzf#vim#windows)
command W :w
