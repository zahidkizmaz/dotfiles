return {
  {
    "zahidkizmaz/python-docs.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "ibhagwan/fzf-lua" },
    dev = true,
    keys = {
      {
        "<leader>fp",
        function()
          return require("python-docs").fzf_lua()
        end,
        desc = "Search for installed python library docs.",
      },
      {
        "<leader>fp",
        function()
          return require("python-docs").fzf_lua({ search = true })
        end,
        mode = "v",
        desc = "Search for selection in installed python library docs.",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufRead", "BufNewFile" },
    cmd = { "TSUpdate", "TSUpdateSync" }, -- Needed for headless runs such as: nvim --headless -c "TSUpdateSync" +qa
    opts = {
      auto_install = true,
      sync_install = false,
      ignore_install = {},
      ensure_installed = {},
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "python" }, -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1573
      },
    },
    dependencies = {
      {
        "RRethy/vim-illuminate",
        keys = {
          { "gn", "<cmd>lua require('illuminate').goto_next_reference()<cr>" },
          { "gp", "<cmd>lua require('illuminate').goto_prev_reference()<cr>" },
        },
      },
      { "nvim-treesitter/nvim-treesitter-context" },
      {
        "HiPhish/rainbow-delimiters.nvim",
        config = function()
          local rainbow_delimiters = require("rainbow-delimiters")

          vim.g.rainbow_delimiters = {
            strategy = {
              [""] = rainbow_delimiters.strategy["global"],
              vim = rainbow_delimiters.strategy["local"],
            },
            query = { [""] = "rainbow-delimiters" },
            highlight = {
              "RainbowDelimiterRed",
              "RainbowDelimiterYellow",
              "RainbowDelimiterBlue",
              "RainbowDelimiterOrange",
              "RainbowDelimiterGreen",
              "RainbowDelimiterViolet",
              "RainbowDelimiterCyan",
            },
          }
        end,
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    opts = {},
    keys = {
      { "gcc", mode = "n" },
      { "gcc", mode = "x" },
    },
  },
  {
    "danymat/neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = { "Neogen" },
    opts = {
      languages = {
        python = {
          template = {
            annotation_convention = "google_docstrings",
          },
        },
      },
    },
  },
  {
    "klen/nvim-test",
    config = function()
      require("nvim-test.runners.pytest"):setup({
        args = { "--disable-warnings", "-s" }, -- Warnings can create a lot of clutter in small buffers.
      })
      require("nvim-test").setup({ silent = true })
    end,
    keys = {
      { "<leader>tl", "<cmd>TestLast<cr>", desc = "Run the last ran test" },
      { "<leader>tf", "<cmd>TestFile<cr>", desc = "Run all tests for the current file" },
      { "<leader>tr", "<cmd>TestNearest<cr>", desc = "Run the test nearest to the cursor" },
    },
  },
  {
    "NvChad/nvim-colorizer.lua",
    opts = {},
    cmd = { "ColorizerToggle" },
  },
  {
    "zahidkizmaz/sf.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    dev = true,
    opts = {},
    keys = {
      { "<leader>sfd", "<cmd>SFDeploy<cr>", desc = "Deploy current buffer to default sf org" },
      { "<leader>sft", "<cmd>SFTest<cr>", desc = "Run test class in current buffer" },
      { "<leader>sfT", "<cmd>SFDeployTest<cr>", desc = "Deploy and run tests of the current buffer" },
      { "<leader>sfs", "<cmd>SFShow<cr>", desc = "Show sf.nvim split" },
      { "<leader>sfh", "<cmd>SFHide<cr>", desc = "Hide sf.nvim split" },
    },
  },
}
