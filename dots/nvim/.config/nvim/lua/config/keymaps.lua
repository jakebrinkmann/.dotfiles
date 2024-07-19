-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local set = vim.keymap.set
-- Resume the last Telescope picker
set("n", "<leader>sx", require("telescope.builtin").resume, { noremap = true, silent = true, desc = "Resume" })

-- Allow a horizontal terminal, not just float!
set("n", "<c-/>", ":ToggleTerm direction=horizontal <CR>", { desc = "ToggleTerm (horizontal)" })
