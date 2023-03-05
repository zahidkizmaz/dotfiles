local null_ls = require("null-ls")

null_ls.setup({
  debug = false,
  sources = {
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.diagnostics.ruff,
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.diagnostics.yamllint,
    null_ls.builtins.diagnostics.curlylint,
    null_ls.builtins.diagnostics.ansiblelint,
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.formatting.black.with({ extra_args = { "--fast" } }),
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.djhtml.with({
      extra_args = function(params)
        local file_name = vim.api.nvim_buf_get_name(params.bufnr)
        local tabwidth = vim.api.nvim_buf_get_option(params.bufnr, "shiftwidth")
        return {
          "--tabwidth",
          tabwidth,
          file_name,
        }
      end,
    }),
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.rustfmt,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.trim_newlines,
    null_ls.builtins.formatting.shfmt.with({
      filetypes = { "sh", "bash", "zsh" },
      extra_args = { "-i=2", "-ci", "-bn" },
    }),
    null_ls.builtins.formatting.sqlfluff.with({
      extra_args = { "--dialect", "postgres" },
    }),
    null_ls.builtins.formatting.rustfmt,
  },
  debounce = vim.opt.updatetime:get(),
  update_on_insert = false,
  diagnostics_format = "[#{c}] #{m} (#{s})",
  should_attach = function()
    local filetype = vim.bo.filetype
    if filetype == "go" or filetype == "json" or filetype == "tex" then
      return false
    else
      return true
    end
  end,
})
