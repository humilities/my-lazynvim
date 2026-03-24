return {
  -- 1. 启用 Overseer 任务管理插件
  {
    "stevearc/overseer.nvim",
    opts = {
      templates = { "builtin" },
    },
  },

  -- 2. 增强 nvim-dap 的配置
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")

      -- 定义 C++ 调试配置
      dap.configurations.cpp = {
        {
          name = "Clang++ Build & Debug",
          type = "codelldb", -- 使用 Mason 安装的 codelldb
          request = "launch",
          program = function()
            -- 默认寻找与当前文件同名但无后缀的二进制文件
            return vim.fn.expand("%:p:r")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          -- 关键：在启动调试前，运行名为 "C++ Compile" 的任务
          preLaunchTask = "C++ Compile",

          console = "integratedTerminal",
        },
      }
    end,
  },

  -- 3. 定义编译任务 (Overseer)
  -- 你也可以直接在项目根目录创建 .vscode/tasks.json，
  -- 但这里我们直接用 Lua 定义一个全局通用的简易编译模板
  {
    "stevearc/overseer.nvim",
    opts = function(_, opts)
      local overseer = require("overseer")
      overseer.register_template({
        name = "C++ Compile",
        builder = function()
          return {
            cmd = { "clang++" },
            args = { "-g", vim.fn.expand("%:p"), "-o", vim.fn.expand("%:p:r") },
            components = { { "on_output_quickfix", open = true }, "default" },
          }
        end,
        condition = {
          filetype = { "cpp" },
        },
      })
    end,
  },
}
