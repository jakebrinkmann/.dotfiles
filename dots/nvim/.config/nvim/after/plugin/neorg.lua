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
					private = "~/notes/private",
					public = "~/notes/public",
				},
				default_workspace = "private",
			},
		},
		["core.journal"] = {
			config = {
				journal_folder = "journal",
				strategy = "flat",
				workspace = "private",
			},
		},
		["core.completion"] = {
			config = {
				engine = "nvim-cmp",
			},
		},
	},
})

local journal = require("neorg.modules.core.journal.module")
if os.getenv("NEORGJOURNAL") then
	-- Open Table of Contents
	journal[os.getenv("NEORGJOURNAL")].open_toc()
	-- Split, open today's journal
	vim.cmd.vsplit()
	vim.cmd("wincmd l | :Neorg journal today")
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
