return {
  -- 1. Obsidian.nvim 核心配置
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/vaults/personal", -- 请修改为你实际的 Obsidian 库路径
        },
      },
      -- 设置快速搜索的快捷键映射
      mappings = {
        -- 利用 Telescope 在库中全局搜索文字
        ["<leader>os"] = { action = "obsidian_grep", opts = { desc = "Obsidian Search (Grep)" } },
        -- 搜索笔记标题
        ["<leader>of"] = { action = "obsidian_quick_switch", opts = { desc = "Obsidian Find Notes" } },
      },
    },
  },

  -- 2. 渲染美化: render-markdown.nvim
  -- 这比 headlines.nvim 渲染效果更现代化
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown", "obsidian" },
    },
    ft = { "markdown", "obsidian" },
  },

  -- 3. 代码高亮与解析: Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "markdown", "markdown_inline" })
      end
    end,
  },
}
