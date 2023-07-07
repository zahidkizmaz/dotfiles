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
        { "<leader>nt", "<cmd>ToggleTerm<cr>", desc = "Open Terminal" },
        { "<leader>gg", "<cmd>lua Toggle_lazygit()<CR>", desc = "Open lazygit" },
        { "<leader>tl", "<cmd>lua Toggle_lines()<CR>", desc = "Show/Hide Status and Tab bars" },
      },
    },
    {
      "folke/noice.nvim",
      event = "UIEnter",
      opts = {
        popupmenu = { enabled = false },
        cmdline = { view = "cmdline" },
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["cmp.entry.get_documentation"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          },
        },
        presets = {
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          bottom_search = true, -- use a classic bottom cmdline for search
          lsp_doc_border = true, -- add a border to hover docs and signature help
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
        },
        routes = {
          {
            view = "mini",
            filter = { event = "msg_showmode" },
          },
        },
        views = {
          mini = { win_options = { winblend = 0 } }, -- Transparent background
        },
      },
      dependencies = { "MunifTanjim/nui.nvim" },
    },
    {
      "ThePrimeagen/harpoon",
      dependencies = { "nvim-lua/plenary.nvim" },
      keys = {
        {
          "<leader>jj",
          '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>',
          desc = "View all project marks",
          mode = "n",
        },
        {
          "<leader>ja",
          '<cmd>lua require("harpoon.mark").add_file()<cr>',
          desc = "Mark files you want to revisit later on",
          mode = "n",
        },
        {
          "<leader>jn",
          '<cmd>lua require("harpoon.ui").nav_next()<cr>',
          desc = "Navigates to next mark",
          mode = "n",
        },
        {
          "<leader>jp",
          '<cmd>lua require("harpoon.ui").nav_prev()<cr>',
          desc = "Navigates to prev mark",
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
      "dnlhc/glance.nvim",
      config = function()
        local glance = require("glance")
        local actions = glance.actions
        glance.setup({
          height = 30,
          border = { enable = true },
          mappings = {
            list = {
              ["<S-up>"] = actions.preview_scroll_win(5),
              ["<S-down>"] = actions.preview_scroll_win(-5),
            },
          },
        })
      end,
      keys = {
        { "gR", "<CMD>Glance references<CR>", desc = "Glance References" },
        { "gD", "<CMD>Glance definitions<CR>", desc = "Glance Definitions" },
        { "gM", "<CMD>Glance implementations<CR>", desc = "Glance implementations" },
        { "gY", "<CMD>Glance type_definitions<CR>", desc = "Glance Type Definitions" },
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
        { "mrjones2014/nvim-ts-rainbow" },
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
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
