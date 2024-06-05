return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      -- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#snipmate
      require("luasnip.loaders.from_snipmate").lazy_load()

      local list_snips = function()
        local ft_list = require("luasnip").available()[vim.o.filetype]
        local ft_snips = {}
        for _, item in pairs(ft_list) do
          ft_snips[item.trigger] = item.name
        end
        print(vim.inspect(ft_snips))
      end

      vim.api.nvim_create_user_command("SnipList", list_snips, {})
    end,
  },
  { "benfowler/telescope-luasnip.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>cc",
        function()
          require("telescope").extensions.luasnip.luasnip({})
        end,
        desc = "Find Snippet",
      },
    },
  },
}
