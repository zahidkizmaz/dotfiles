return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          local always_hidden = { ".git" }
          return vim.tbl_contains(always_hidden, name)
        end,
      },
    },
    keys = {
      { "<leader>-", "<CMD>tabnew | Oil<CR>", desc = "Open parent directory" },
    },
  },
  {
    "echasnovski/mini.files",
    opts = {},
    keys = {
      { "<leader>m", "<CMD>:lua MiniFiles.open()<CR>", desc = "Open mini.files" },
    },
  },
}
