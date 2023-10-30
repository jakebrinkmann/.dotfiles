-- https://github.com/L3MON4D3/LuaSnip
local ls = require("luasnip")
-- Also load both lua and json when a markdown-file is opened,
-- Other filetypes just load themselves.
ls.setup({
	load_ft_func = require("luasnip.extras.filetype_functions").extend_load_ft({
		markdown = { "plantuml", "json" },
		html = { "javascript" },
	}),
})
require("luasnip.loaders.from_snipmate").lazy_load({ paths = "~/.config/nvim/snippets" })

vim.keymap.set({ "i" }, "<C-K>", function()
	ls.expand()
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-L>", function()
	ls.jump(1)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-J>", function()
	ls.jump(-1)
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true })
