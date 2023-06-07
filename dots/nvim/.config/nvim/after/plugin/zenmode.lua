local util = require("zen-mode")
util.setup({
	window = {
		options = {
			signcolumn = "no",
			number = false,
		},
	},
	plugins = {
		twilight = { enabled = true },
	},
})
