return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    -- 绑定快捷键：<leader>fy (Find Yazi) 开启 Yazi 浮窗
    {
      "<leader>fy",
      function()
        require("yazi").yazi()
      end,
      desc = "Open yazi",
    },
    -- 绑定快捷键：<leader>fA 并在当前文件的父目录下打开 Yazi
    {
      "<leader>fA",
      function()
        require("yazi").toggle()
      end,
      desc = "Resume yazi",
    },
  },
  opts = {
    -- 如果你希望用 Yazi 完全替代 Netrw (默认的文件浏览器)
    open_for_directories = true,
    keymaps = {
      show_help = "<f1>",
    },
  },
}
