local ok_status, catppuccin = pcall(require, "catppuccin")
if not ok_status then
  return
end

catppuccin.setup({
  flavour = "mocha", -- latte, frappe, macchiato, mocha
  background = { -- :h background
    light = "latte",
    dark = "mocha",
  },
  compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
  transparent_background = true,
  term_colors = true,
  no_italic = false,
  no_bold = false,
  styles = {
    comments = { "italic" },
    conditionals = {},
    loops = {},
    functions = { "italic" },
    keywords = { "italic", "bold" },
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  integrations = { -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    cmp = true,
    fidget = true,
    gitsigns = true,
    treesitter = true,
    rainbow_delimiters = true,
    indent_blankline = {
      enabled = true,
      colored_indent_levels = true,
    },
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { "italic" },
        hints = { "italic" },
        warnings = { "italic" },
        information = { "italic" },
      },
      underlines = {
        errors = { "underline" },
        hints = { "underline" },
        warnings = { "underline" },
        information = { "underline" },
      },
    },
  },
})

vim.cmd.colorscheme("catppuccin")
