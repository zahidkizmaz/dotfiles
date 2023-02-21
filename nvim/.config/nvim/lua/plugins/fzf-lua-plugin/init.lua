local current_dir_seperated_with_dashes = string.gsub(vim.fn.getcwd(), "/", "-"):sub(2)
local tag_filename = current_dir_seperated_with_dashes .. "-tags"
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
  .. "--color=always "
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
  },
})
