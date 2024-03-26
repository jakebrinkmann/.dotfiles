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

  -- Markdown Align Table
  "junegunn/vim-easy-align",

  -- [[Python dependencies FIXME! :PoetvActivate not working with null-ls?
  -- maybe 'HallerPatrick/py_lsp.nvim' ?
  -- "petobens/poet-v",
  --]]

  {
    -- Install with yarn or npm
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  "jbyuki/venn.nvim",
  -- set virtualedit=all
  -- :VBox

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
      { "j-hui/fidget.nvim",       tag = "legacy", opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      "folke/neodev.nvim",

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

      {
        -- Autocompletion
        "hrsh7th/nvim-cmp",
        dependencies = {
          "hrsh7th/cmp-nvim-lsp",
          {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
            build = "make install_jsregexp",
            dependencies = { "rafamadriz/friendly-snippets" },
          },
          "saadparwaiz1/cmp_luasnip",
          -- { "quangnguyen30192/cmp-nvim-ultisnips", opts = {} },
        },
      },
    },
  },

  {
    -- Show function signature when you type
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  },

  -- Useful plugin to show you pending keybinds.
  { "folke/which-key.nvim",  opts = {} },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    opts = {},
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
    main = "ibl",
    opts = {
      indent = {
        char = "┊",
      },
      whitespace = {
        remove_blankline_trail = false,
      },
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
    -- NOTE: having trouble with treesitter after update? Try :TSUpdate
    build = ":TSUpdate",
  },

  -- conceal typical boiler Code
  { "Jxstxs/conceal.nvim", dependencies = "nvim-treesitter/nvim-treesitter" },

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
      { "rcarriga/nvim-dap-ui",        config = true },
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
      "nvim-neotest/nvim-nio",
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

  -- modern matchit and matchparen.
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
  },

  -- File Explorer
  {
    -- See :help oil-actions for a list of all available actions
    "stevearc/oil.nvim",
    opts = {
      -- See :help oil-columns
      columns = { "icon" },
      -- Window-local options to use for oil buffers
      win_options = {
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
      },
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = false,
        sort = {
          -- sort order can be "asc" or "desc"
          -- see :help oil-columns to see which columns are sortable
          { "type", "asc" },
          { "name", "asc" },
        },
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Easy Skeletons
  {
    'cvigilv/esqueleto.nvim',
    opts = {},
  },
  -- NOT CONFIGURED CORRECTLY (YET)
  -- {
  -- 	"chipsenkbeil/vimwiki.nvim",
  -- 	dependencies = {
  -- 		"vimwiki/vimwiki",
  -- 		"chipsenkbeil/vimwiki-rs",
  -- 	},
  -- },
}, {})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
