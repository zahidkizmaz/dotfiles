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
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>fo",
        function()
          require("conform").format({ async = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      log_level = vim.log.levels.INFO,
      notify_on_error = false,
      default_format_opts = { lsp_format = "fallback" },
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 5000, lsp_format = "fallback" }
      end,
      formatters = {
        apex_prettier = {
          command = "./node_modules/.bin/prettier",
          args = { "$FILENAME", "--plugin", "prettier-plugin-apex" },
        },
        edi_format = {
          command = "edi-format",
          args = { "-l", "error", "--stdin" },
        },
        html_django = { command = "djhtml", args = { "--tabwidth", "2", "-" } },
      },
      formatters_by_ft = {
        apex = { "apex_prettier", stop_after_first = true },
        edi = { "edi_format" },
        html = { "prettierd", "prettier", stop_after_first = true },
        htmldjango = { "html_django" },
        javascript = { "prettierd", "prettier", stop_after_first = true, lsp_format = "never" },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true, lsp_format = "never" },
        lua = { "stylua" },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        python = { "ruff_organize_imports", "ruff_format", lsp_format = "never" },
        rust = { "rustfmt" },
        sh = { "shfmt", lsp_format = "never" },
        sql = { "sqlfluff", stop_after_first = true },
        toml = { "taplo", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "yamlfmt", stop_after_first = true },
        zsh = { "shfmt", lsp_format = "never" },
        ["*"] = { "trim_newlines", "trim_whitespace" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local opts = {
        dockerfile = { "hadolint" },
        gitcommit = { "gitlint" },
        javascript = { "eslint_d", "eslint" },
        javascriptreact = { "eslint_d", "eslint" },
        sh = { "shellcheck" },
        typescript = { "eslint_d", "eslint" },
        typescriptreact = { "eslint_d", "eslint" },
        yaml = { "yamllint" },
        zsh = { "zsh" },
      }
      local lint = require("lint")
      lint.linters_by_ft = opts

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint(nil, { ignore_errors = true })
        end,
      })
    end,
  },
}
