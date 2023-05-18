require("neorg").setup({
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

-- :help <LocalLeader>

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
