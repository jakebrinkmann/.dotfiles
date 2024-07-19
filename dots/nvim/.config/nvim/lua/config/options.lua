-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local o = vim.opt

-- set window title
o.title = true
o.titlestring = [[%f %h%m%r%w]]

-- vim.opt.winbar = "%=%m %f" -- content at top right of every buffer (useful for splits)

-- TODO: Disable mouse mode
o.mouse = nil

-- TODO: make all terminals login shells
-- vim.opt.shell = "zsh"
-- vim.opt.shellcmdflag = "--login"
