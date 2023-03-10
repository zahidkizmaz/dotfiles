local C = require("catppuccin.palettes").get_palette()

require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "catppuccin",
    component_separators = "|",
    section_separators = "",
    disabled_filetypes = {},
    always_divide_middle = false,
  },
  sections = {
    lualine_a = {
      {
        "mode",
        fmt = function(str)
          -- only show first character of mode
          return str:sub(1, 1)
        end,
      },
    },
    lualine_b = { { "filename", path = 1 } },
    lualine_c = {},
    lualine_x = { "branch", "diff", "diagnostics" },
    lualine_y = { "filetype" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {
      {
        "vim.api.nvim_win_get_number(0)",
        color = { bg = C.blue, fg = C.mantle, gui = "bold" },
      },
    },
    lualine_b = { { "filename", path = 1 } },
    lualine_c = {},
    lualine_x = { "diff" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = { "neo-tree", "toggleterm" },
})
