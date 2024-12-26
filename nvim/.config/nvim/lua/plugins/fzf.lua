return {
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      {
        "ludovicchabant/vim-gutentags",
        config = function()
          local cache_dir = vim.env.HOME .. "/.cache/tags/"
          if vim.fn.isdirectory(cache_dir) == 0 then
            print("Creating guten tags cache dir: " .. cache_dir)
            vim.fn.mkdir(cache_dir, "p")
          end

          vim.g.gutentags_cache_dir = cache_dir
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
      {
        "<leader>fc",
        function()
          local checkout_cmd = "git switch "
          local list_branches_cmd = 'git for-each-ref --sort=-committerdate refs/ --format="%(refname:short)"'
          local opts = {
            actions = {
              ["default"] = function(selected, _)
                if string.find(selected[1], "origin/") then
                  checkout_cmd = checkout_cmd .. "--track "
                end
                checkout_cmd = checkout_cmd .. selected[1]
                vim.cmd("!" .. checkout_cmd)
              end,
            },
          }
          require("fzf-lua").fzf_exec(list_branches_cmd, opts)
        end,
        desc = "Custom git checkout",
      },
      { "gL", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
    },
    config = function()
      local current_dir_separated_with_dashes = string.gsub(vim.fn.getcwd(), "/", "-"):sub(2)
      local tag_filename = current_dir_separated_with_dashes .. "-tags"
      local tag_file_location = vim.g.gutentags_cache_dir .. "/" .. tag_filename

      local rg_opts = "--iglob !*.git "
        .. "--iglob !*__pycache__ "
        .. "--iglob !*.direnv "
        .. "--iglob !*node_modules "
        .. "--iglob !*.pytest_cache "
        .. "--iglob !*.mypy_cache "
        .. "--iglob !*target "
        .. "--iglob !tags "
        .. "--column "
        .. "--line-number "
        .. "--no-heading "
        .. "--color=never "
        .. "--smart-case "
        .. "--max-columns=4096 "
        .. "--hidden "

      require("fzf-lua").setup({
        "max-perf",
        height = 0.95,
        fzf_opts = { ["--layout"] = "default" },
        winopts = {
          preview = { layout = "vertical", vertical = "up:70%" },
        },
        tags = { ctags_file = tag_file_location },
        btags = { ctags_file = tag_file_location },
        lsp = { async_or_timeout = 10000 },
        previewers = {
          builtin = {
            -- use `viu` for image previews
            extensions = {
              -- neovim terminal only supports `viu` block output
              ["png"] = { "viu", "-b" },
              ["jpg"] = { "viu", "-b" },
              ["gif"] = { "viu", "-b" },
            },
          },
        },
        grep = {
          rg_opts = rg_opts,
          glob_flag = "--hidden --iglob", -- for case sensitive globs use '--glob'
          actions = {
            ["ctrl-q"] = {
              fn = require("fzf-lua.actions").file_edit_or_qf,
              prefix = "select-all+",
            },
          },
        },
      })
    end,
  },
}
