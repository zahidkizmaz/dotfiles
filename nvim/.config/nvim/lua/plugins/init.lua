require("plugins.init_lazy")
require("lazy").setup({
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
      dependencies = { "kyazdani42/nvim-web-devicons" },
      event = "VeryLazy",
      config = function()
        require("plugins.lualine-plugin")
      end,
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      event = "UIEnter",
      config = function()
        require("ibl").setup()
      end,
    },
    {
      "echasnovski/mini.surround",
      event = "InsertEnter",
      config = function()
        require("mini.surround").setup()
      end,
    },
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
      "j-hui/fidget.nvim",
      event = "BufReadPost",
      opts = { notification = { window = { winblend = 0 } } },
    },
    {
      "ThePrimeagen/harpoon",
      dependencies = { "nvim-lua/plenary.nvim" },
      branch = "harpoon2",
      config = true,
      keys = {
        {
          "<leader>jj",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "View all project marks",
          mode = "n",
        },
        {
          "<leader>ja",
          function()
            local harpoon = require("harpoon")
            harpoon:list():append()
          end,
          desc = "Mark files you want to revisit later on",
          mode = "n",
        },
        {
          "<leader>jl",
          function()
            local harpoon = require("harpoon")
            harpoon:list():next()
          end,
          desc = "Navigates to next mark",
          mode = "n",
        },
        {
          "<leader>jh",
          function()
            local harpoon = require("harpoon")
            harpoon:list():prev()
          end,
          desc = "Navigates to prev mark",
          mode = "n",
        },
      },
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
    { "rhysd/committia.vim", lazy = false }, -- nice commit setup
    {
      "ruifm/gitlinker.nvim", -- Open current working line in remove git host
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("plugins.gitlinker-plugin")
      end,
      keys = {
        {
          "<leader>hh",
          '<cmd>lua require"gitlinker".get_buf_range_url("n")<cr>',
          desc = "Create VCS remote link for line",
          mode = "n",
        },
        {
          "<leader>hh",
          '<cmd>lua require"gitlinker".get_buf_range_url("v")<cr>',
          desc = "Create VCS remote link for line",
          mode = "v",
        },
      },
    },
    {
      "lewis6991/gitsigns.nvim",
      event = "UIEnter",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("plugins.gitsigns-plugin")
      end,
    },
    {
      "akinsho/git-conflict.nvim",
      event = "VeryLazy",
      config = function()
        require("git-conflict").setup({ default_mappings = false })
        vim.keymap.set("n", "co", "<Plug>(git-conflict-ours)")
        vim.keymap.set("n", "cr", "<Plug>(git-conflict-theirs)")
        vim.keymap.set("n", "cb", "<Plug>(git-conflict-both)")
        vim.keymap.set("n", "c0", "<Plug>(git-conflict-none)")
        vim.keymap.set("n", "[x", "<Plug>(git-conflict-prev-conflict)")
        vim.keymap.set("n", "]x", "<Plug>(git-conflict-next-conflict)")
      end,
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
      lazy = false,
      config = function()
        require("lsp")
      end,
      dependencies = {
        { "williamboman/mason-lspconfig.nvim" },
        { "williamboman/mason.nvim", opts = { ui = { border = "rounded" } } },
      },
    },
    { "folke/neodev.nvim" },
    {
      "ibhagwan/fzf-lua",
      config = function()
        require("plugins.fzf-lua-plugin")
      end,
      dependencies = {
        {
          "ludovicchabant/vim-gutentags",
          config = function()
            require("plugins.gutentags-plugin")
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
      "rmagatti/goto-preview",
      config = true,
      opts = { border = "rounded" },
      keys = {
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
      config = true,
      keys = {
        { "<leader>-", "<CMD>tabnew | Oil<CR>", desc = "Open parent directory" },
      },
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    -------------------------------

    -----------------------------
    -- Dev Environment Plugins --
    -----------------------------
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      event = "UIEnter",
      cmd = { "TSUpdate", "TSUpdateSync" }, -- Needed for headless runs such as: nvim --headless -c "TSUpdateSync" +qa
      config = function()
        require("plugins.treesitter-plugin")
      end,
      dependencies = {
        { "nvim-treesitter/nvim-treesitter-refactor" },
        { "nvim-treesitter/nvim-treesitter-context", config = true },
        {
          "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
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
        {
          "gcc",
          mode = "n",
        },
        {
          "gcc",
          mode = "x",
        },
      },
    },
    {
      "folke/zen-mode.nvim",
      opts = {
        plugins = {
          tmux = { enabled = true }, -- disables the tmux statusline
          twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
        },
      },
      keys = {
        { "<leader>zm", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
      },
    },
    {
      "danymat/neogen",
      cmd = { "Neogen" },
      config = function()
        require("plugins.neogen-plugin")
      end,
    },
    {
      "klen/nvim-test",
      config = function()
        require("nvim-test.runners.pytest"):setup({
          args = { "--disable-warnings" }, -- Warnings can create a lot of clutter in small buffers.
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
    {
      "epwalsh/obsidian.nvim",
      event = { "BufReadPre " .. vim.fn.expand("~") .. "/Notes/obsidian/**.md" },
      cmd = { "ObsidianNew" },
      dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
        "ibhagwan/fzf-lua",
      },
      opts = {
        dir = "~/Notes/obisidian", -- no need to call 'vim.fn.expand' here
        finder = "fzf-lua",
      },
      keys = {
        { "<leader>nc", "<cmd>ObsidianNew<cr>", desc = "Create new note" },
        { "<leader>nd", "<cmd>ObsidianToday<cr>", desc = "Create todays note" },
        { "<leader>ny", "<cmd>ObsidianYesterday<cr>", desc = "Open yesterdays note" },
        { "<leader>nf", "<cmd>ObsidianQuickSwitch<cr>", desc = "Search notes" },
        { "<leader>ng", "<cmd>ObsidianSearch<cr>", desc = "Grep notes" },
      },
      config = function(_, opts)
        require("obsidian").setup(opts)

        vim.keymap.set("n", "gf", function()
          if require("obsidian").util.cursor_on_markdown_link() then
            return "<cmd>ObsidianFollowLink<CR>"
          else
            return "gf"
          end
        end, { noremap = false, expr = true })
      end,
    },
    {
      "zahidkizmaz/sf.nvim",
      dev = true,
      config = true,
      keys = {
        { "<leader>sfd", "<cmd>SFDeploy<cr>", desc = "Deploy current buffer to default sf org" },
        { "<leader>sft", "<cmd>SFTest<cr>", desc = "Run test class in current buffer" },
        { "<leader>sfT", "<cmd>SFDeployTest<cr>", desc = "Deploy and run tests of the current buffer" },
        { "<leader>sfs", "<cmd>SFShow<cr>", desc = "Show sf.nvim split" },
        { "<leader>sfh", "<cmd>SFHide<cr>", desc = "Hide sf.nvim split" },
      },
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
