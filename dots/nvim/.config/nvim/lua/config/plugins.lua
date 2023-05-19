-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require("lazy").setup({
	-- NOTE: First, some plugins that don't require any configuration

	-- Git related plugins
	{
		"tpope/vim-fugitive",
		dependencies = { "tpope/vim-rhubarb" },
	},

	-- Detect tabstop and shiftwidth automatically
	"tpope/vim-sleuth",

	-- NOTE: This is where your plugins related to LSP can be installed.
	--  The configuration is done below. Search for lspconfig to find it below.
	{
		-- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"jose-elias-alvarez/null-ls.nvim",

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ "j-hui/fidget.nvim", opts = {} },

			-- Additional lua configuration, makes nvim stuff amazing!
			"folke/neodev.nvim",

			{
				"iamcco/markdown-preview.nvim",
				run = function()
					vim.fn["mkdp#util#install"]()
				end,
				ft = "markdown",
				cmd = { "MarkdownPreview" },
			},

			{
				"weirongxu/plantuml-previewer.vim",
				dependencies = {
					"aklt/plantuml-syntax",
					"tyru/open-browser.vim",
				},
				ft = "plantuml",
			},

			{
				"SmiteshP/nvim-navic",
				dependencies = { "neovim/nvim-lspconfig" },
				config = function()
					require("nvim-navic").setup()
				end,
			},

			{
				"SmiteshP/nvim-navbuddy",
				dependencies = {
					"SmiteshP/nvim-navic",
					"MunifTanjim/nui.nvim",
					"numToStr/Comment.nvim",
					"nvim-telescope/telescope.nvim",
				},
				config = function()
					local navbuddy = require("nvim-navbuddy")
					local actions = require("nvim-navbuddy.actions")
					navbuddy.setup({
						lsp = {
							auto_attach = true,
							preference = {
								"pyright",
								"tsserver",
								"graphql",
								"cssls",
								"html",
								"bashls",
								"dockerls",
								"yamlls",
								"jsonls",
								"taplo",
								"lua_ls",
							},
						},
						mappings = {
							["<Left>"] = require("nvim-navbuddy.actions").parent,
							["<Right>"] = require("nvim-navbuddy.actions").children,
							["<Up>"] = require("nvim-navbuddy.actions").previous_sibling,
							["<Down>"] = require("nvim-navbuddy.actions").next_sibling,
							["<C-Up>"] = require("nvim-navbuddy.actions").move_up,
							["<C-Down>"] = require("nvim-navbuddy.actions").move_down,
						},
					})
				end,
			},
		},
	},

	{
		-- Autocompletion
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			{ "quangnguyen30192/cmp-nvim-ultisnips", opts = {} },
		},
	},

	-- Useful plugin to show you pending keybinds.
	{ "folke/which-key.nvim", opts = {} },
	{
		-- Adds git releated signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	{
		-- Theme inspired by Atom
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("gruvbox")
			-- [[ Set the background to transparent ]]
			-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		end,
	},

	{
		-- Set lualine as statusline
		"nvim-lualine/lualine.nvim",
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = true,
				theme = "onedark",
				component_separators = "|",
				section_separators = "",
			},
			winbar = {
				lualine_c = {
					"navic",
					color_correction = nil,
					navic_opts = nil,
				},
			},
			sections = {
				lualine_c = {
					"filename",
				},
			},
		},
	},

	{
		-- Add indentation guides even on blank lines
		"lukas-reineke/indent-blankline.nvim",
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help indent_blankline.txt`
		opts = {
			char = "┊",
			show_trailing_blankline_indent = false,
		},
	},

	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", opts = {} },

	-- Fuzzy Finder (files, lsp, etc)
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},

	-- Fuzzy Finder Algorithm which requires local dependencies to be built.
	-- Only load if `make` is available. Make sure you have the system
	-- requirements installed.
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		-- NOTE: If you are having trouble with this installation,
		--       refer to the README for telescope-fzf-native for more instructions.
		build = "make",
		cond = function()
			return vim.fn.executable("make") == 1
		end,
	},

	{
		-- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
	},

	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = true,
	},

	-- Testing
	{
		"mfussenegger/nvim-dap",
		event = "BufReadPost",
		dependencies = {
			{ "mfussenegger/nvim-dap-python" },
			{ "rcarriga/nvim-dap-ui", config = true },
		},
	},
	--[[
       Call :lua require('dap').continue() to start debugging.
       Use :lua require('dap-python').test_method()
  --]]
	{
		"nvim-neotest/neotest",
		event = "BufReadPost",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-python",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-python")({
						args = { "-vvv", "--no-cov", "--disable-warnings" },
					}),
				},
				quickfix = {
					enabled = false,
					open = false,
				},
				output = {
					enabled = true,
					open_on_run = false,
				},
				floating = {
					border = "rounded",
					max_height = 0.9,
					max_width = 0.9,
					options = {},
				},
				summary = {
					open = "botright vsplit | vertical resize 60",
				},
				status = {
					enabled = true,
					signs = true,
					virtual_text = false,
				},
			})
		end,
	},

	{
		"andymass/vim-matchup",
		event = "BufReadPost",
	},

	-- File Explorer
	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	-- Notetaking
	-- :help neorg
	{
		"nvim-neorg/neorg",
		build = ":Neorg sync-parsers",
		dependencies = {
			{
				"nvim-lua/plenary.nvim",
				-- mini.align for table alignment
				-- :help MiniAlign  nnoremap gAip
				{ "echasnovski/mini.nvim", version = false },
			},
		},
	},
}, {})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
