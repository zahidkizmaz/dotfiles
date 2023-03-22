require("toggleterm").setup({
  float_opts = { border = "curved" },
})

function Toggle_lazygit()
  local Terminal = require("toggleterm.terminal").Terminal
  local nvr_command = "nvr --nostart --remote-tab-wait +'set bufhidden=delete'"
  local lazygit = Terminal:new({
    cmd = "lazygit",
    hidden = true,
    direction = "tab",
    env = {
      VISUAL = nvr_command,
      EDITOR = nvr_command,
    },
    on_open = function()
      vim.api.nvim_del_keymap("t", "<Esc>")
      Toggle_lines()
    end,
    on_close = function()
      Toggle_lines()
      vim.api.nvim_set_keymap("t", "<Esc>", "<c-\\><c-n>", { silent = true })
    end,
  })
  lazygit:toggle()
end

function Toggle_lines()
  local lua_line = require("lualine")

  if vim.opt.showtabline._value == 0 then
    lua_line.hide({ unhide = true })
    vim.opt.showtabline = 1
  else
    lua_line.hide()
    vim.opt.laststatus = 0
    vim.opt.showtabline = 0
  end
end
