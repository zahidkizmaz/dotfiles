require("plugins.init_lazy")
local lazy = require("lazy")
lazy.setup({
  spec = {
    {
      "catppuccin/nvim",
      name = "catppuccin",
      lazy = false,
      config = function()
        require("plugins.catpuccin-plugin")
      end,
    },
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      event = "VeryLazy",
      config = function()
        require("plugins.lualine-plugin")
      end,
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      event = "VeryLazy",
      main = "ibl",
      config = true,
    },
    {
      "echasnovski/mini.surround",
      event = { "BufReadPost", "BufNewFile", "InsertEnter" },
      config = true,
    },
    {
      "iamcco/markdown-preview.nvim",
      ft = "markdown",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      build = function()
        lazy.load({ plugins = { "markdown-preview.nvim" } })
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
      "j-hui/fidget.nvim",
      event = { "BufReadPost", "BufNewFile" },
      opts = { notification = { window = { winblend = 0 } } },
    },
    {
      "sontungexpt/url-open",
      branch = "mini",
      cmd = "URLOpenUnderCursor",
      config = true,
      keys = {
        {
          "<leader>o",
          "<cmd>URLOpenUnderCursor<cr>",
          desc = "Open url under cursor",
          mode = "n",
        },
      },
    },
    ---------------------

    -----------------
    -- Git Plugins --
    -----------------
    { "rhysd/committia.vim", ft = "gitcommit" }, -- nice commit setup
    {
      "ruifm/gitlinker.nvim",
      opts = { mappings = nil },
      keys = {
        {
          "<leader>hh",
          function()
            require("gitlinker").get_buf_range_url("n")
          end,
          desc = "Create VCS remote link for line and copy to clipboard",
          mode = "n",
        },
        {
          "<leader>hh",
          function()
            require("gitlinker").get_buf_range_url("v")
          end,
          desc = "Create VCS remote link for line and copy to clipboard",
          mode = "v",
        },
      },
    },
    {
      "tpope/vim-fugitive",
      dependencies = { "tpope/vim-rhubarb" },
      cmd = { "Git", "GBrowse", "Gedit", "Gread", "Gdiffsplit", "Gvdiffsplit" },
      keys = {
        {
          "<leader>cc",
          "<CMD>lua TabnewGitcommit()<CR>",
          desc = "Open a new tab and run git commit",
          mode = "n",
        },
      },
    },
    {
      "lewis6991/gitsigns.nvim",
      event = { "BufReadPost", "BufNewFile" },
      config = function()
        require("plugins.gitsigns-plugin")
      end,
    },
    {
      "sindrets/diffview.nvim",
      cmd = { "DiffviewOpen", "DiffviewFileHistory" },
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    -----------------

    ---------------------
    -- Auto Completion --
    ---------------------
    {
      "hrsh7th/nvim-cmp",
      event = "InsertEnter",
      dependencies = {
        { "hrsh7th/cmp-path" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-nvim-lsp" },
        {
          "tzachar/cmp-tabnine",
          build = "./install.sh",
          config = function()
            require("plugins.cmp-plugin.tabnine")
          end,
        },
        {
          "dcampos/nvim-snippy",
          dependencies = { "honza/vim-snippets", "dcampos/cmp-snippy" },
        },
      },
      config = function()
        require("plugins.cmp-plugin")
      end,
    },
    ---------------------

    -------------------------
    -- LSP Related Plugins --
    -------------------------
    {
      "neovim/nvim-lspconfig",
      event = { "BufReadPre", "BufNewFile" },
      cmd = { "LspInfo" },
      config = require("lsp").setup,
    },
    { "folke/neodev.nvim" }, -- Setup called in lsp/init.lua
    { "b0o/schemastore.nvim" }, -- Setup called in lsp/init.lua
    {
      "ibhagwan/fzf-lua",
      config = function()
        require("plugins.fzf-lua-plugin")
      end,
      dependencies = {
        {
          "ludovicchabant/vim-gutentags",
          config = function()
            vim.g.gutentags_cache_dir = vim.env.HOME .. "/.cache/tags"
            vim.g.gutentags_file_list_command = {
              markers = {
                [".git"] = "git ls-files --cached --others --exclude-standard",
              },
            }
          end,
        },
      },
      keys = {
        { "<leader>fl", "<cmd>FzfLua<cr>", desc = "FzfLua" },
        { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find File" },
        { "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Find Git File" },
        { "<leader>fs", "<cmd>FzfLua btags<cr>", desc = "Current File Fuzzy Search" },
        { "<leader>fr", "<cmd>FzfLua lsp_references<cr>", desc = "Find References" },
        { "<leader>ft", "<cmd>FzfLua tags<cr>", desc = "FzfLua Tags" },
        { "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "FzfLua Help Tags" },
        { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "FzfLua Buffers" },
        { "<leader>fd", "<cmd>FzfLua lsp_definitions<cr>", desc = "FzfLua Definitions" },
        { "<leader>rg", "<cmd>FzfLua live_grep_glob<cr>", desc = "Ripgrep Search" },
        { "<leader>fw", "<cmd>FzfLua grep_cword<cr>", desc = "Ripgrep Current Word" },
        { "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Ripgrep Current Word" },
        { "<leader>ca", "<cmd>FzfLua lsp_code_actions<cr>", desc = "LSP Code Actions" },
        { "<leader>bl", "<cmd>FzfLua blines<cr>", desc = "Buffer Line Search" },
        { "<leader>ds", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Document Symbols" },
        { "<leader>ss", "<cmd>FzfLua spell_suggest<cr>", desc = "Spell Correction Suggestions" },
        { "<leader>rr", "<cmd>FzfLua resume<cr>", desc = "Resume last search" },
        { "<leader>fc", "<cmd>lua Git_checkout()<cr>", desc = "Custom git checkout" },
        { "gL", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
      },
    },
    {
      "rmagatti/goto-preview",
      config = true,
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
      config = true,
      keys = {
        { "<leader>m", "<CMD>:lua MiniFiles.open()<CR>", desc = "Open mini.files" },
      },
    },
    -------------------------------

    -----------------------------
    -- Dev Environment Plugins --
    -----------------------------
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      event = { "BufRead", "BufNewFile" },
      cmd = { "TSUpdate", "TSUpdateSync" }, -- Needed for headless runs such as: nvim --headless -c "TSUpdateSync" +qa
      config = function()
        require("plugins.treesitter-plugin")
      end,
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
      config = true,
      keys = {
        { "gcc", mode = "n" },
        { "gcc", mode = "x" },
      },
    },
    {
      "danymat/neogen",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      cmd = { "Neogen" },
      config = true,
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
      config = true,
      cmd = { "ColorizerToggle" },
    },
  },
  defaults = { lazy = true },
  ui = { border = "rounded" },
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = false },
  dev = { path = "~/Projects" },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
