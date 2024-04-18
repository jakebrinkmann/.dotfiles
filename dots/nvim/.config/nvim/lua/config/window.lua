-- [[ Setting window options ]]
-- See `:help vim.wo`
-- Make line numbers default
vim.wo.number = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"
vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "§", texthl = "DiagnosticHint" })
