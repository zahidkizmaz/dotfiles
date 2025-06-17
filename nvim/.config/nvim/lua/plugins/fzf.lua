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
      { "<leader>fl", require("fzf-lua").builtin, desc = "FzfLua" },
      { "<leader>ff", require("fzf-lua").files, desc = "Find File" },
      { "<leader>fg", require("fzf-lua").git_files, desc = "Find Git File" },
      { "<leader>fs", require("fzf-lua").btags, desc = "Current File Fuzzy Search" },
      { "<leader>fr", require("fzf-lua").lsp_references, desc = "Find References" },
      { "<leader>ft", require("fzf-lua").tags, desc = "FzfLua Tags" },
      { "<leader>fh", require("fzf-lua").help_tags, desc = "FzfLua Help Tags" },
      { "<leader>fb", require("fzf-lua").buffers, desc = "FzfLua Buffers" },
      { "<leader>rg", require("fzf-lua").live_grep_glob, desc = "Ripgrep Search" },
      { "<leader>fw", require("fzf-lua").grep_cword, desc = "Ripgrep Current Word" },
      { "<leader>bl", require("fzf-lua").blines, desc = "Buffer Line Search" },
      { "<leader>ds", require("fzf-lua").lsp_document_symbols, desc = "Document Symbols" },
      { "<leader>ss", require("fzf-lua").spell_suggest, desc = "Spell Correction Suggestions" },
      { "<leader>rr", require("fzf-lua").resume, desc = "Resume last search" },
      { "gL", require("fzf-lua").diagnostics_document, desc = "Document Diagnostics" },
      {
        "<leader>ca",
        function()
          require("fzf-lua").lsp_code_actions({ silent = true })
        end,
        desc = "LSP Code Actions",
      },
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
        .. "--iglob !*.ruff_cache "
        .. "--iglob !*target "
        .. "--iglob !tags "
        .. "--column "
        .. "--line-number "
        .. "--no-heading "
        .. "--color=never "
        .. "--smart-case "
        .. "--max-columns=4096 "
        .. "--hidden "

      local fd_opts = "--color=never "
        .. "--hidden --no-ignore --follow "
        .. "--type f --type l "
        .. "--exclude .git "
        .. "--exclude node_modules "
        .. "--exclude .direnv "
        .. "--exclude result "
        .. "--exclude __pycache__ "
        .. "--exclude .mypy_cache "
        .. "--exclude .pytest_cache "
        .. "--exclude .ruff_cache "
        .. "--exclude result "

      local img_previewer = { "viu", "-b" }

      require("fzf-lua").setup({
        height = 0.95,
        fzf_opts = { ["--layout"] = "default" },
        winopts = { preview = { layout = "vertical", vertical = "up:70%" } },
        tags = { ctags_file = tag_file_location },
        btags = { ctags_file = tag_file_location },
        lsp = { async_or_timeout = 10000 },
        previewers = {
          builtin = {
            extensions = {
              ["png"] = img_previewer,
              ["jpg"] = img_previewer,
              ["jpeg"] = img_previewer,
              ["gif"] = img_previewer,
              ["webp"] = img_previewer,
            },
          },
        },
        files = { fd_opts = fd_opts, file_icons = false },
        git = { files = { file_icons = false } },
        grep = {
          rg_opts = rg_opts,
          glob_flag = "--hidden --iglob", -- for case sensitive globs use '--glob'
          file_icons = false,
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
