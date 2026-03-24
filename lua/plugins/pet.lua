return {
  {
    "giusgad/pets.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "giusgad/hologram.nvim", -- 用于图像渲染
    },
    config = function()
      require("pets").setup({
        row = 1, -- 宠物出现在第几行
        col = 0, -- 宠物出现在第几列
        speed_multiplier = 1.0, -- 动画速度
        default_pet = "cat", -- 默认宠物类型: dog, cat, crab, horse 等
        default_style = "brown", -- 颜色: black, brown, gray, white
        random_color = true, -- 是否随机颜色
        death_animation = true, -- 是否开启死亡动画 (如果不喂它...)
      })
    end,
  },
}
