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
        require("plugins.indent-blankline-plugin")
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
      "akinsho/toggleterm.nvim",
      config = function()
        require("plugins.toggleterm-plugin")
      end,
      keys = {
        { "<leader>nt", "<cmd>ToggleTerm<cr>", desc = "Openn Terminal" },
        { "<leader>gg", "<cmd>lua Toggle_lazygit()<CR>", desc = "Open lazygit" },
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
        vim.keymap.set("n", "cc", "<Plug>(git-conflict-ours)")
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
        { "hrsh7th/cmp-nvim-lua" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lsp-signature-help" },
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
      "williamboman/mason-lspconfig.nvim",
      event = "VeryLazy",
      config = function()
        require("lsp")
      end,
      dependencies = {
        { "neovim/nvim-lspconfig" },
        { "williamboman/mason.nvim", opts = { ui = { border = "rounded" } } },
      },
    },
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
        { "<leader>rg", "<cmd>FzfLua live_grep<cr>", desc = "Ripgrep Search" },
        { "<leader>gs", "<cmd>FzfLua grep_cword<cr>", desc = "Ripgrep Current Word" },
        { "<leader>ca", "<cmd>FzfLua lsp_code_actions<cr>", desc = "LSP Code Actions" },
        { "<leader>bl", "<cmd>FzfLua blines<cr>", desc = "Buffer Line Search" },
        { "<leader>ds", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Document Symbols" },
        { "<leader>gL", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
      },
    },
    -------------------------------

    -----------------------------
    -- Dev Environment Plugins --
    -----------------------------
    { "gpanders/editorconfig.nvim", event = "VeryLazy" },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      event = "UIEnter",
      config = function()
        require("plugins.treesitter-plugin")
      end,
      dependencies = {
        { "nvim-treesitter/nvim-treesitter-refactor" },
        { "nvim-treesitter/nvim-treesitter-context", config = true },
      },
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v2.x",
      dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "kyazdani42/nvim-web-devicons" },
        { "MunifTanjim/nui.nvim" },
      },
      config = function()
        require("plugins.neotree-plugin")
      end,
      keys = {
        { "<C-n>", "<cmd>Neotree toggle<cr>", desc = "Toggle Neotree" },
      },
    },
    {
      "jose-elias-alvarez/null-ls.nvim",
      event = "VeryLazy",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("plugins.null-ls-plugin")
      end,
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
      "Pocco81/TrueZen.nvim",
      config = function()
        require("plugins.true-zen-plugin")
      end,
      keys = {
        { "<leader>zm", "<cmd>TZAtaraxis<cr>", desc = "Toggle Zen Mode" },
      },
    },
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = function()
        require("plugins.autopairs-plugin")
      end,
    },
    {
      "danymat/neogen",
      cmd = { "Neogen" },
      config = function()
        require("plugins.neogen-plugin")
      end,
    },
    {
      "j-hui/fidget.nvim",
      event = "VeryLazy",
      config = function()
        require("plugins.fidget-plugin")
      end,
    },
    {
      "klen/nvim-test",
      config = true,
      opts = { silent = true },
      keys = {
        { "<leader>tl", "<cmd>TestLast<cr>", desc = "Run the last ran test" },
        { "<leader>tf", "<cmd>TestFile<cr>", desc = "Run all tests for the current file" },
        { "<leader>tr", "<cmd>TestNearest<cr>", desc = "Run the test nearest to the cursor" },
      },
    },
  },
  defaults = { lazy = true },
  ui = { border = "rounded" },
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
