require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  highlight = { enable = true },
  indent = {
    enable = true,
    disable = { "python" }, -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1573
  },
  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
  },
  refactor = {
    highlight_definitions = {
      enable = true,
      clear_on_cursor_move = true,
    },
    navigation = {
      enable = true,
      keymaps = {
        goto_next_usage = "gn",
        goto_previous_usage = "gp",
        goto_definition_lsp_fallback = "gd",
      },
    },
  },
})
vim.treesitter.language.register("java", "apexcode") -- Treestter doesn't have apexcode support. However, java seems to work fine for it.
