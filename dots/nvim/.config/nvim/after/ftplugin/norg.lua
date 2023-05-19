-- :help <LocalLeader>
--      :map <buffer> <LocalLeader>A  oanother line<Esc>
vim.g.maplocalleader = ","

local journal = require("neorg.modules.core.journal.module")
local PATTERN = "(%d+)-(%d+)-(%d+).norg"
function NextDay(delta)
	print("hello")
	local year, month, day = vim.fn.expand("%"):match(PATTERN)
	local time = os.time({ year = year, month = month, day = day + delta })
	journal.private.open_diary(time)
end

-- help https://github.com/nvim-neorg/neorg/wiki/User-Keybinds
vim.keymap.set("n", "<LocalLeader><Down>", function()
	NextDay(-1)
end, { desc = "Journal yesterday" })
vim.keymap.set("n", "<LocalLeader><LocalLeader>", function()
	vim.cmd("Neorg journal today")
end, { desc = "Journal today" })
vim.keymap.set("n", "<LocalLeader><Up>", function()
	NextDay(1)
end, { desc = "Journal tomorrow" })
