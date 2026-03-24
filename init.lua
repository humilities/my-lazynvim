vim.g.mapleader = " "

vim.opt.clipboard = "unnamedplus"

-- 在终端模式下映射粘贴
-- <C-\><C-n> 是退出终端模式，"+"p 是从系统剪贴板粘贴，"a" 是重新进入输入状态
vim.keymap.set("t", "<C-v>", [[<C-\><C-n>"+pa]], { desc = "Paste in terminal" })

-- 同时也建议映射普通模式下的粘贴，确保万无一失
vim.keymap.set("n", "<C-v>", '"+p', { desc = "Paste from system clipboard" })

-- <Leader>w 保存文件
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
-- <Leader>q 退出 (Quit)
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })

-- <Leader>v 垂直分屏 (Split Vertical)
vim.keymap.set("n", "<leader>v", ":vsplit<CR>", { desc = "Split vertical" })
-- <Leader>h 水平分屏 (Split Horizontal)
vim.keymap.set("n", "<leader>h", ":split<CR>", { desc = "Split horizontal" })
-- <Leader>c 关闭当前分屏 (Split Close)
vim.keymap.set("n", "<leader>c", "<C-w>c", { desc = "Close current split" })

vim.keymap.set("n", "<leader>r", function()
  vim.cmd("w") -- 保存文件

  local file_path = vim.fn.expand("%:p")
  local file_dir = vim.fn.expand("%:p:h")
  local file_name_no_ext = vim.fn.expand("%:t:r")
  local bin_dir = file_dir .. "/bin"
  local output_path = bin_dir .. "/" .. file_name_no_ext

  -- 针对交互优化的命令：增加了一个清爽的头部提示
  local compile_run_cmd = string.format(
    "mkdir -p '%s' && clang++ -O2 -Wall -std=c++17 '%s' -o '%s' && echo '--- [Running] Output Below ---' && '%s'",
    bin_dir,
    file_path,
    output_path,
    output_path
  )

  -- 组合最终指令
  local final_cmd = string.format(
    "12split | term zsh -c \"%s; echo ''; print -n '--- [Finished] Press any key to exit ---'; read -k 1\"",
    compile_run_cmd
  )

  -- 执行命令
  vim.cmd(final_cmd)

  -- 【关键优化】
  -- 使用 schedule 确保在终端窗口完全渲染后，自动进入插入模式(Insert Mode)
  -- 这样你一按 <leader>r，就可以直接 Ctrl+Shift+V 粘贴或者直接打字
  vim.defer_fn(function()
    vim.cmd("startinsert")
  end, 50)
end, { desc = "Clang++ Compile & Interactive Run" })

-- 直接跳转到指定编号的 Tab (Alt + 1~9)
for i = 1, 9 do
  vim.keymap.set("n", "<A-" .. i .. ">", i .. "gt", { desc = "Go to tab " .. i })
end

-- 使用 Leader + n/p 快速切换上一个/下一个 Tab
vim.keymap.set("n", "<leader>l", ":tabnext<CR>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader>h", ":tabprev<CR>", { desc = "Previous Tab" })

-- <Leader>nh 取消搜索高亮 (No Highlight)
vim.keymap.set("n", "<leader>nh", ":nohlsearch<CR>", { desc = "No highlight" })
-- <Leader>e 打开文件树 (如果你装了 nvim-tree 或 neo-tree)
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- 全选并进入普通模式
vim.keymap.set("n", "<C-a>", "ggVG")

-- 如果你也想在插入模式下使用
vim.keymap.set("i", "<C-a>", "<Esc>ggVG")

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
