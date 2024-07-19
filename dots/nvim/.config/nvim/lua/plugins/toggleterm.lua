-- https://github.com/akinsho/toggleterm.nvim
return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      shade_terminals = false,
      winbar = {
        enabled = true,
        name_formatter = function(term)
          return term.dir
        end,
      },
    },
  },
}
