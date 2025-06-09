return {
  {
    "zahidkizmaz/python-docs.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "ibhagwan/fzf-lua" },
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
    config = function()
      require("nvim-treesitter.configs").setup({
        auto_install = true,
        sync_install = false,
        ignore_install = {},
        ensure_installed = {},
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      })
    end,
    dependencies = {
      {
        "RRethy/vim-illuminate",
        keys = {
          { "gn", "<cmd>lua require('illuminate').goto_next_reference()<cr>" },
          { "gp", "<cmd>lua require('illuminate').goto_prev_reference()<cr>" },
        },
      },
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
    "Bekaboo/dropbar.nvim",
    event = { "BufReadPost" },
    opts = {
      bar = {
        sources = function(buf, _)
          local sources = require("dropbar.sources")
          local utils = require("dropbar.utils")
          if vim.bo[buf].ft == "markdown" then
            return {
              sources.path,
              sources.markdown,
            }
          end
          if vim.bo[buf].buftype == "terminal" then
            return {
              sources.terminal,
            }
          end
          return {
            utils.source.fallback({
              sources.lsp,
              sources.treesitter,
            }),
          }
        end,
      },
    },
    keys = {
      {
        "<leader>;",
        function()
          require("dropbar.api").pick()
        end,
        "Pick symbols in winbar",
      },
      {
        "[;",
        function()
          require("dropbar.api").goto_context_start()
        end,
        "Pick symbols in winbar",
      },
      {
        "];",
        function()
          require("dropbar.api").select_next_context()
        end,
        "Pick symbols in winbar",
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
        html = { "prettierd" },
        htmldjango = { "html_django" },
        javascript = { "biome", "prettierd", stop_after_first = true, lsp_format = "never" },
        javascriptreact = { "biome", "prettierd", stop_after_first = true, lsp_format = "never" },
        json = { "jq" },
        json5 = { "fixjson" },
        just = { "just", stop_after_first = true },
        lua = { "stylua" },
        markdown = { "prettierd" },
        nix = { "nixfmt", stop_after_first = true },
        python = { "ruff_organize_imports", "ruff_format", lsp_format = "never" },
        rust = { "rustfmt" },
        sh = { "shfmt", lsp_format = "never" },
        sql = { "sqlfluff", stop_after_first = true },
        toml = { "taplo", lsp_format = "never" },
        typescript = { "biome", "prettierd", stop_after_first = true, lsp_format = "never" },
        typescriptreact = { "biome", "prettierd", stop_after_first = true, lsp_format = "never" },
        yaml = { "yamlfmt", stop_after_first = true },
        zsh = { "shfmt", lsp_format = "never" },
        ["*"] = { "trim_newlines", "trim_whitespace", "injected" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local opts = {
        htmldjango = { "djlint" },
        dockerfile = { "hadolint" },
        gitcommit = { "gitlint" },
        javascript = { "biomejs" },
        javascriptreact = { "biomejs" },
        markdown = { "markdownlint" },
        nix = { "deadnix" },
        sh = { "shellcheck" },
        typescript = { "biomejs" },
        typescriptreact = { "biomejs" },
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
