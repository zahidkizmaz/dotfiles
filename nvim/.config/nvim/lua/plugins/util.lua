return {
  {
    "selimacerbas/markdown-preview.nvim",
    dependencies = { "selimacerbas/live-server.nvim" },
    ft = "markdown",
    config = {
      instance_mode = "takeover", -- "takeover" (one tab) or "multi" (tab per instance)
      port = 0, -- 0 = auto (8421 for takeover, OS-assigned for multi)
      open_browser = true,
      default_theme = "dark",
      debounce_ms = 300,
    },
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
