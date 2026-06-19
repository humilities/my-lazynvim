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

-- 通用浮动窗口创建函数（供 <leader>r 和 <leader>t 复用）
local function open_float_win()
local buf = vim.api.nvim_create_buf(false, true)
local width = math.floor(vim.o.columns * 0.35)
local height = math.floor(vim.o.lines * 0.6)
local row = vim.o.lines - height - 3
local col = vim.o.columns - width - 2
local win = vim.api.nvim_open_win(buf, true, {
  relative = "editor",
  width = width,
  height = height,
  row = row,
  col = col,
  style = "minimal",
  border = "rounded",
})
vim.keymap.set("n", "q", function()
if vim.api.nvim_win_is_valid(win) then
  vim.api.nvim_win_close(win, true)
  end
  end, { buffer = buf, silent = true })
return buf, win
end

-- <Leader>r 编译并运行当前文件
vim.keymap.set("n", "<leader>r", function()
vim.cmd("w")

local ft = vim.bo.filetype
local file_path = vim.fn.expand("%:p")
local file_dir = vim.fn.expand("%:p:h")
local file_name_no_ext = vim.fn.expand("%:t:r")
local compile_run_cmd

if ft == "cpp" or ft == "c" then
  local bin_dir = file_dir .. "/bin"
  local output_path = bin_dir .. "/" .. file_name_no_ext
  compile_run_cmd = string.format(
    "mkdir -p '%s' && clang++ -O2 -Wall -std=c++17 '%s' -o '%s' && echo '--- [Running] Output Below ---' && '%s'",
    bin_dir, file_path, output_path, output_path
  )
  elseif ft == "python" then
    compile_run_cmd = string.format(
      "cd '%s' && echo '--- [Running] Output Below ---' && python3 '%s'",
      file_dir, file_path
    )
    elseif ft == "rust" then
      local cargo_toml = vim.fn.findfile("Cargo.toml", file_dir .. ";")
      if cargo_toml ~= "" then
        local project_root = vim.fn.fnamemodify(cargo_toml, ":h")
        compile_run_cmd = string.format(
          "cd '%s' && echo '--- [Running] Output Below ---' && cargo run",
          project_root
        )
        else
          local bin_dir = file_dir .. "/bin"
          local output_path = bin_dir .. "/" .. file_name_no_ext
          compile_run_cmd = string.format(
            "mkdir -p '%s' && rustc '%s' -o '%s' && echo '--- [Running] Output Below ---' && '%s'",
            bin_dir, file_path, output_path, output_path
          )
          end
          else
            vim.notify("No run config for filetype: " .. ft, vim.log.levels.WARN)
            return
            end

            local buf, _ = open_float_win()
            vim.fn.termopen('zsh -c "' .. compile_run_cmd .. '"', { on_exit = function() end })
            vim.cmd("startinsert")
            end, { desc = "Compile & Run (cpp / python / rust)" })

-- <Leader>t 打开交互式浮动终端（用于手动输命令，如 python3 x86.py -p loop.s ...）
vim.keymap.set("n", "<leader>T", function()
local buf, win = open_float_win()
vim.fn.termopen("zsh", {
  on_exit = function()
  if vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
    end
    end,
})
vim.cmd("startinsert")
end, { desc = "Open float terminal" })

-- 直接跳转到指定编号的 Tab (Alt + 1~9)
for i = 1, 9 do
  vim.keymap.set("n", "<A-" .. i .. ">", i .. "gt", { desc = "Go to tab " .. i })
  end

  -- 使用 Leader + l/h 快速切换上一个/下一个 Tab
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
