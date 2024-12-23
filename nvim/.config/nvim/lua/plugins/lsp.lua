return {
  {
    "j-hui/fidget.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = { notification = { window = { winblend = 0 } } },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "Mason" },
    config = require("lsp").setup,
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        -- Auto install LSP servers if they have setup
        opts = { automatic_installation = true },
      },
      { "williamboman/mason.nvim", opts = { ui = { border = "rounded" } } },
    },
  },
  { "folke/neodev.nvim" }, -- Setup called in lsp/init.lua
  { "b0o/schemastore.nvim" }, -- Setup called in lsp/init.lua
  {
    "rmagatti/goto-preview",
    opts = {
      border = "rounded",
      stack_floating_preview_windows = false, -- Whether to nest floating windows
      preview_window_title = { enable = true, position = "right" }, -- Whether to set the preview window title as the filename
    },
    keys = {
      { "gC", "<CMD>lua require('goto-preview').close_all_win()<CR>", desc = "Close all windows" },
      { "gD", "<CMD>lua require('goto-preview').goto_preview_definition()<CR>", desc = "Glance Definitions" },
      { "gM", "<CMD>lua require('goto-preview').goto_preview_implementation()<CR>", desc = "Glance implementations" },
      {
        "gY",
        "<CMD>lua require('goto-preview').goto_preview_type_definition()<CR>",
        desc = "Glance Type Definitions",
      },
    },
  },
  {
    "smjonas/inc-rename.nvim",
    keys = { "<leader>rn" },
    config = function()
      require("inc_rename").setup()
      vim.keymap.set("n", "<leader>rn", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { expr = true })
    end,
  },
}
