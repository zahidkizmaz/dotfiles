require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = "|",
    section_separators = "",
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
    lualine_a = { { "vim.api.nvim_win_get_number(0)" } },
    lualine_b = { { "filename", path = 1 } },
    lualine_c = {},
    lualine_x = { "diff" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = { "fugitive", "oil", "quickfix" },
})
