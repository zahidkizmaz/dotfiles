require("nvim-treesitter.configs").setup({
  auto_install = true,
  sync_install = false,
  ignore_install = {},
  ensure_installed = {},
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "python" }, -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1573
  },
})
