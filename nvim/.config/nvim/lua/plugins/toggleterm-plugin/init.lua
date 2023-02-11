require("toggleterm").setup({
  float_opts = { border = "curved" },
})

function Toggle_lazygit()
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({
    cmd = "lazygit",
    hidden = true,
    direction = "tab",
    env = { EDITOR = "nvr" },
  })
  lazygit:toggle()
end
