local api = vim.api

-- TODO: rewrite as lua? [[ Highlight variable under cursor ]]
-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = api.nvim_create_augroup("YankHighlight", { clear = true })
api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- TODO: [[ Highlight variable under cursor ]]
vim.cmd([[
	au CursorHold * :exec 'match TermCursor /\V\<' . expand('<cword>') . '\>/'
]])

api.nvim_create_user_command("W", "noautocmd write ++p", { nargs = 0 })

-- " Move VISUAL-LINE up
vim.cmd("xnoremap <Up> dkP`[V`]")
-- "Move VISUAL-LINE down
vim.cmd("xnoremap <Down> dp`[V`]")

-- " Remove trailing whitespace
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	callback = function()
		local save_cursor = vim.fn.getpos(".")
		pcall(function()
			vim.cmd([[%s/\s\+$//e]])
		end)
		vim.fn.setpos(".", save_cursor)
	end,
})
