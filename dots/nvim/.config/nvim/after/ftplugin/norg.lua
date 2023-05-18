-- :help <LocalLeader>
--      :map <buffer> <LocalLeader>A  oanother line<Esc>
vim.g.maplocalleader = ","

-- help https://github.com/nvim-neorg/neorg/wiki/User-Keybinds
vim.keymap.set("n", "<LocalLeader>jt", [[<Cmd>Neorg journal today]], { desc = "[J]ournal [T]oday" })
vim.keymap.set("n", "<LocalLeader>jy", [[<Cmd>Neorg journal yeterday]], { desc = "[J]ournal [Y]esterday" })
