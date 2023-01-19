local present, true_zen = pcall(require, "true-zen")
if not present then
  return
end

local width = vim.api.nvim_win_get_width(0)
local padding_left = math.floor(width / 4) + math.floor(width / 8)
local padding_right = math.floor(width / 4) - math.floor(width / 8)

true_zen.setup({
  modes = {
    ataraxis = {
      shade = "dark", -- if `dark` then dim the padding windows, otherwise if it's `light` it'll brighten said windows
      backdrop = 0, -- percentage by which padding windows should be dimmed/brightened. Must be a number between 0 and 1. Set to 0 to keep the same background color
      minimum_writing_area = { -- minimum size of main window
        width = 80,
        height = 44,
      },
      quit_untoggles = true, -- type :q or :qa to quit Ataraxis mode
      padding = { -- padding windows
        left = padding_left,
        right = padding_right,
        top = 0,
        bottom = 0,
      },
    },
  },
})
