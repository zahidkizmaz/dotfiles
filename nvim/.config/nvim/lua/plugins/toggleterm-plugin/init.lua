require("toggleterm").setup({
  float_opts = { border = "curved" },
})

function Toggle_lazygit()
  local Terminal = require("toggleterm.terminal").Terminal
  local nvr_command = "nvr --nostart --remote-tab-wait +'set bufhidden=wipe'"
  local lazygit = Terminal:new({
    cmd = "lazygit",
    hidden = true,
    direction = "tab",
    env = {
      VISUAL = nvr_command,
      EDITOR = nvr_command,
    },
  })
  lazygit:toggle()
end
