return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        background = {
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
          blink_cmp = true,
          cmp = false,
          mason = false,
          fidget = true,
          harpoon = false,
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
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
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
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = "ibl",
    opts = {},
  },
  {
    "folke/zen-mode.nvim",
    opts = {
      plugins = {
        tmux = { enabled = true }, -- disables the tmux statusline
        twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
      },
    },
    keys = { { "<leader>zm", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" } },
  },
}
