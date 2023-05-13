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
    if client.server_capabilities.documentformattingprovider then
      vim.cmd("nnoremap <silent><buffer> <space>f :lua vim.lsp.buf.format()<cr>")
      -- format on save
      vim.cmd("autocmd bufwritepost <buffer> lua vim.lsp.buf.formatting()")
    end
    if client.server_capabilities.documentrangeformattingprovider then
      vim.cmd("xnoremap <silent><buffer> <space>f :lua vim.lsp.buf.range_formatting({})<cr>")
    end
  end,
})
