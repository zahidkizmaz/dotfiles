return {
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "sindrets/winshift.nvim",
    keys = {
      { "<C-W>m", "<cmd>WinShift<cr>", desc = "Run WinShift" },
      { "<C-W><C-m>", "<cmd>WinShift<cr>", desc = "Run WinShift" },
    },
  },
  {
    "mbbill/undotree",
    keys = {
      { "<leader>uf", "<cmd>UndotreeFocus<cr>", desc = "Undotree Focus" },
      { "<leader>uu", "<cmd>UndotreeToggle | UndotreeFocus<cr>", desc = "Undotree Toggle" },
    },
  },
  {
    "sontungexpt/url-open",
    branch = "mini",
    cmd = "URLOpenUnderCursor",
    opts = {},
    keys = {
      {
        "<leader>o",
        "<cmd>URLOpenUnderCursor<cr>",
        desc = "Open url under cursor",
        mode = "n",
      },
    },
  },
}
