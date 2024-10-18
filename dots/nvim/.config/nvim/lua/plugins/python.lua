return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ruff = {
        cmd_env = { RUFF_TRACE = "messages" },
        init_options = {
          settings = {
            logLevel = "error",
          },
        },
        keys = {
          {
            "<leader>co",
            LazyVim.lsp.action["source.organizeImports"],
            desc = "Organize Imports",
          },
          {
            "<leader>cx",
            LazyVim.lsp.action["source.fixAll"],
            desc = "Fix All",
          },
        },
      },
    },
  },
}
