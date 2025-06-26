return {
  {
    "j-hui/fidget.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = { notification = { window = { winblend = 0 } } },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = { "b0o/schemastore.nvim" }, -- Used in yamlls and jsonls
    cmd = { "LspInfo" },
    config = require("lsp").setup,
  },
  {
    "rmagatti/goto-preview",
    opts = {
      border = "rounded",
      stack_floating_preview_windows = false, -- Whether to nest floating windows
      preview_window_title = { enable = true, position = "right" }, -- Whether to set the preview window title as the filename
    },
    keys = {
      {
        "gC",
        function()
          require("goto-preview").close_all_win()
        end,
        desc = "Close all windows",
      },
      {
        "gD",
        function()
          require("goto-preview").goto_preview_definition()
        end,
        desc = "Glance Definitions",
      },
      {
        "gM",
        function()
          require("goto-preview").goto_preview_implementation()
        end,
        desc = "Glance implementations",
      },
      {
        "gY",
        function()
          require("goto-preview").goto_preview_type_definition()
        end,
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
