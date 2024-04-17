-- Define autocommands with Lua APIs
-- See: h:api-command
local cmd = vim.api.nvim_create_user_command
cmd("W", "noautocmd w", { nargs = 0 })
