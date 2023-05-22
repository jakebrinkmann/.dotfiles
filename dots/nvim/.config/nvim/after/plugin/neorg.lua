require("mini.align").setup({})

local neorg = require("neorg")
neorg.setup({
	load = {
		["core.defaults"] = {},
		["core.concealer"] = {
			config = {
				icon_preset = "basic",
			},
		},
		["core.dirman"] = {
			config = {
				workspaces = {
					work = "~/notes/work",
					public = "~/notes/public",
				},
				default_workspace = "work",
			},
		},
		["core.journal"] = {
			config = {
				journal_folder = "journal",
				strategy = "flat",
				workspace = "work",
			},
		},
		["core.completion"] = {
			config = {
				engine = "nvim-cmp",
			},
		},
	},
})

if os.getenv("NEORGJOURNAL") then
	vim.cmd("Neorg index")
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
