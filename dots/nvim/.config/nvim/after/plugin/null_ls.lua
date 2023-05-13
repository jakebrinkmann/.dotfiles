local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require("null-ls")

local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting
local hover = null_ls.builtins.hover

null_ls.setup({
  debug = true,
  sources = {
    code_actions.shellcheck,
    code_actions.refactoring,
    code_actions.cspell,
    formatting.djlint,
    formatting.stylua,
    formatting.jq,
    formatting.isort,
    diagnostics.checkstyle,
    -- diagnostics.codespell.with({ filetypes = { "python" } }),
    -- diagnostics.flake8.with({
    --   extra_args = { "--ignore", "e501", "--select", "e126" }
    -- }),
    -- diagnostics.eslint,
    -- diagnostics.mypy,
    hover.dictionary,
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- :help vim.lsp.buf.format
          vim.lsp.buf.format({
            async = false,
            filter = function(client) return client.name ~= "tsserver" end
          })
        end,
      })
    end
  end,
})
