return {
  "stevearc/oil.nvim",
  opts = {},
  -- 可选：如果你想通过快捷键快速打开 Oil
  keys = {
    { "-", "<CMD>Oil<CR>", desc = "Open parent directory in Oil" },
  },
  -- 确保图标能正常显示
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
