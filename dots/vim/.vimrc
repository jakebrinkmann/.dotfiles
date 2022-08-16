let configs = [
\  ".vim/general.vim",
\  ".vim/ui.vim",
\  ".vim/commands.vim",
\  ".vim/plugins.vim",
\  ".vim/plugin-settings.vim",
\]
for file in configs
  let x = expand("~/".file)
  if filereadable(x)
    execute 'source' x
  endif
endfor

if has("gui_running")
  execute 'source ~/.vim/gvimrc.vim'
endif
