require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  highlight = { enable = true },
  indent = {
    enable = true,
    disable = { "python" }, -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1573
  },
  refactor = {
    highlight_definitions = {
      enable = true,
      clear_on_cursor_move = true,
    },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition_lsp_fallback = "gd",
      },
    },
  },
})
