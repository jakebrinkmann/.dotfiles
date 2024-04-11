local oil = require("oil")
oil.setup({
	view_options = { show_hidden = true },
})
vim.keymap.set("n", "<Leader>--", oil.open, { desc = "Open current directory" })
