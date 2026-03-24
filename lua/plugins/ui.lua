return {
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })
    end,
  },

  {
    "j-hui/fidget.nvim",
    opts = {
      -- options
    },
  },
}

