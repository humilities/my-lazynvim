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

  -- 1. 创建一个临时的浮动窗口
  local buf = vim.api.nvim_create_buf(false, true) -- 创建一个不关联文件的 buffer
  --local width = math.floor(vim.o.columns * 0.8)
  -- 2. 精确计算右下角坐标
  -- 宽度占 35%，高度占 60%（可以根据写题习惯微调）
  local width = math.floor(vim.o.columns * 0.35)
  local height = math.floor(vim.o.lines * 0.6)

  -- 计算起始位置：总行/列数 - 窗口高/宽 - 留出的边距
  local row = vim.o.lines - height - 3 -- 距离底部留 3 行（给状态栏留位置）
  local col = vim.o.columns - width - 2 -- 距离右边留 2 列
  --local row = math.floor((vim.o.lines - height) / 2)
  --local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  -- 2. 在浮动窗口里启动终端并运行命令
  -- 运行完后按任意键，窗口会自动关闭 (通过 nvim_win_close)
  vim.fn.termopen('zsh -c "' .. compile_run_cmd .. '"', {
    on_exit = function()
      -- 任务结束后，只要在窗口里按任意键（因为命令里有 read），手动关闭即可
      -- 或者你可以取消下面这行的注释来实现“运行完自动关窗”
      -- vim.api.nvim_win_close(win, true)
    end,
  })

  -- 在该 buffer 中设置局部快捷键：按 q 直接关闭窗口
  vim.keymap.set("n", "q", function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, { buffer = buf, silent = true })

  -- 3. 自动进入插入模式，方便你直接粘贴测试样例
  vim.cmd("startinsert")
end, { desc = "Clang++ Compile & Run (Native Float)" })
-- 组合最终指令
--local final_cmd = string.format(
--  "12split | term zsh -c \"%s; echo ''; print -n '--- [Finished] Press any key to exit ---'; read -k 1\"",
--  compile_run_cmd
--)

-- 执行命令
--vim.cmd(final_cmd)

-- 【关键优化】
-- 使用 schedule 确保在终端窗口完全渲染后，自动进入插入模式(Insert Mode)
-- 这样你一按 <leader>r，就可以直接 Ctrl+Shift+V 粘贴或者直接打字
--vim.defer_fn(function()
--  vim.cmd("startinsert")
--end, 50)
--end, { desc = "Clang++ Compile & Interactive Run" })

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
