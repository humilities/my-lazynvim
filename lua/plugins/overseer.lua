return {
  "stevearc/overseer.nvim",
  opts = {
    templates = { "builtin" },
    -- 配置 UI 布局
    patch_ft = {
      ["overseer"] = "float", -- 强制将 overseer 缓冲区设为浮动模式
    },
    setup = {
      -- 默认打开窗口的配置
      dap = false,
      task_win = {
        padding = 2,
        border = "rounded",
        win_opts = {
          winblend = 5, -- 稍微带一点透明度，更有质感
        },
      },
    },
    -- 核心：修改打开窗口的默认行为
    component_aliases = {
      -- 这是一个很有用的组件，当任务失败时保持窗口开启，成功则倒计时关闭
      ["default"] = {
        { "display_status", detail_level = 2 },
        "on_exit_set_status",
        "on_complete_notify",
        { "on_complete_dispose", require_view = true },
      },
    },
  },
  keys = {
    -- 重新定义打开 Overseer 列表的快捷键为浮动窗口
    { "<leader>oo", "<cmd>OverseerToggle<cr>", desc = "Overseer Toggle" },
  },
}
