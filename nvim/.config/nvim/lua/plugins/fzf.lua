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
      {
        "<leader>fl",
        function()
          require("fzf-lua").builtin()
        end,
        desc = "FzfLua",
      },
      {
        "<leader>ff",
        function()
          require("fzf-lua").files()
        end,
        desc = "Find File",
      },
      {
        "<leader>fg",
        function()
          require("fzf-lua").git_files()
        end,
        desc = "Find Git File",
      },
      {
        "<leader>fs",
        function()
          require("fzf-lua").btags()
        end,
        desc = "Current File Fuzzy Search",
      },
      {
        "<leader>fr",
        function()
          require("fzf-lua").lsp_references()
        end,
        desc = "Find References",
      },
      {
        "<leader>ft",
        function()
          require("fzf-lua").tags()
        end,
        desc = "FzfLua Tags",
      },
      {
        "<leader>fh",
        function()
          require("fzf-lua").help_tags()
        end,
        desc = "FzfLua Help Tags",
      },
      {
        "<leader>fb",
        function()
          require("fzf-lua").buffers()
        end,
        desc = "FzfLua Buffers",
      },
      {
        "<leader>rg",
        function()
          require("fzf-lua").live_grep()
        end,
        desc = "Ripgrep Search",
      },
      {
        "<leader>fw",
        function()
          require("fzf-lua").grep_cword()
        end,
        desc = "Ripgrep Current Word",
      },
      {
        "<leader>bl",
        function()
          require("fzf-lua").blines()
        end,
        desc = "Buffer Line Search",
      },
      {
        "<leader>ds",
        function()
          require("fzf-lua").lsp_document_symbols()
        end,
        desc = "Document Symbols",
      },
      {
        "<leader>fi",
        function()
          require("fzf-lua").lsp_implementations()
        end,
        desc = "Find LSP Implementations",
      },
      {
        "<leader>ss",
        function()
          require("fzf-lua").spell_suggest()
        end,
        desc = "Spell Correction Suggestions",
      },
      {
        "<leader>rr",
        function()
          require("fzf-lua").resume()
        end,
        desc = "Resume last search",
      },
      {
        "gL",
        function()
          require("fzf-lua").diagnostics_document()
        end,
        desc = "Document Diagnostics",
      },
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
