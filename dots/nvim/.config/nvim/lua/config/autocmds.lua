-- Define autocommands with Lua APIs
-- See: h:api-autocmd, h:augroup
local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = "1000" })
	end,
	group = "YankHighlight",
})

-- Highlight variable under cursor
-- 	au CursorHold * :exec 'match TermCursor /\V\<' . expand('<cword>') . '\>/'
autocmd("CursorHold", {
	pattern = "*",
	callback = function()
		vim.fn.match("TermCursor", [[/\V\<]] .. vim.fn.expand("<cword>") .. [[\>/]])
	end,
})

-- Remove whitespace on save
autocmd("BufWritePre", {
	pattern = "",
	command = ":%s/\\s\\+$//e",
})
