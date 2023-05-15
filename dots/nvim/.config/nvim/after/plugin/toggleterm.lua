-- https://github.com/akinsho/toggleterm.nvim
require("toggleterm").setup{}

-- :ToggleTerm size=40 dir=~/Desktop direction=horizontal
-- 2TermExec cmd="git status" dir=~/<my-repo-path>
vim.keymap.set("n", "<leader>tt", vim.cmd.ToggleTerm, { desc = "Open terminal" })
vim.keymap.set("n", "<leader>tr", vim.cmd.ToggleTermSendCurrentLine, { desc = "Send CurrentLine" })
vim.keymap.set("v", "<leader>tr", vim.cmd.ToggleTermSendVisualSelection)

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'kj', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
