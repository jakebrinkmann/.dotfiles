local neotest = require("neotest")

vim.keymap.set('n', '<leader>tf', function()
  neotest.run.run(vim.fn.expand('%'))
end, { desc = "Run test file" }
)
vim.keymap.set('n', '<leader>tn', function()
  neotest.run.run()
end, { desc = "Run nearest test" }
)
vim.keymap.set('n', '<leader>ts', function()
  neotest.summary.toggle()
end, { desc = "Toggle summary" }
)
vim.keymap.set('n', '<leader>to', function()
  neotest.output.open({ last_run = true, enter = true })
end, { desc = "Show output" }
)
