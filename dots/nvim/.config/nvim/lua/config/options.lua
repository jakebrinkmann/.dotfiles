-- [[ Setting options ]]
-- See `:help vim.o`
local o = vim.o

-- Set highlight on search
o.hlsearch = true

-- Disable mouse mode
o.mouse = nil

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
o.clipboard = "unnamedplus"

-- Enable break indent
o.breakindent = true

-- Save undo history
o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true

-- Decrease update time
o.updatetime = 1000
o.timeout = true
o.timeoutlen = 300

-- Set completeopt to have a better completion experience
o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
o.termguicolors = true

-- Set vim title
o.title = true
o.titlestring = [[%f %h%m%r%w]]

-- [ Spaces > Tabs ]
-- expand tab input with spaces characters
o.expandtab = true
-- syntax aware indentations for newline inserts
o.smartindent = true
-- num of space characters per tab
o.tabstop = 2
-- spaces per indentation level
o.shiftwidth = 2
