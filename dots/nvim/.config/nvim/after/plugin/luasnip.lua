-- https://github.com/L3MON4D3/LuaSnip
local ls = require("luasnip")
local snip = ls.snippet
-- local node = ls.snippet_node
-- local text = ls.text_node
-- local insert = ls.insert_node
local func = ls.function_node
-- local choice = ls.choice_node
-- local dynamicn = ls.dynamic_node

-- Also load both lua and json when a markdown-file is opened,
-- Other filetypes just load themselves.
ls.setup({
	load_ft_func = require("luasnip.extras.filetype_functions").extend_load_ft({
		markdown = { "plantuml", "json", "bash" },
		html = { "javascript" },
		sh = { "bash" },
	}),
})
require("luasnip.loaders.from_snipmate").lazy_load({ paths = "~/.config/nvim/snippets" })
require("luasnip.loaders.from_vscode").lazy_load({ paths = "~/.config/VSCodium/User/snippets" })

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

ls.add_snippets(nil, {
	all = {
		snip({
			trig = "date",
			namr = "Date",
			dscr = "Date in the form of YYYY-MM-DD",
		}, {
			func(function()
				return { os.date("%Y-%m-%d") }
			end, {}),
		}),
		snip({
			trig = "datetime",
			namr = "Datetime",
			dscr = "Date in the form of YYYY-MM-DDTHH:MM:SS",
		}, {
			func(function()
				return { os.date("%Y-%m-%dT%TZ") }
			end, {}),
		}),
	},
})
