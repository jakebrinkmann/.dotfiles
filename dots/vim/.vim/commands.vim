" remove trailing white space
command Nows :%s/\s\+$//
" remove blank lines
command Nobl :g/^\s*$/d
" make current buffer executable
command Chmodx :!chmod a+x %
" fix syntax highlighting
command FixSyntax :syntax sync fromstart
" Usually, trying to write (not fzf#vim#windows)
command W :w
