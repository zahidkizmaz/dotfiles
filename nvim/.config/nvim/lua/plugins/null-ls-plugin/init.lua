local null_ls = require("null-ls")

null_ls.setup({
  debug = false,
  sources = {
    null_ls.builtins.diagnostics.pmd.with({
      filetypes = { "apexcode" },
      args = { "pmd", "--dir", "$ROOT/force-app", "--format", "json" },
      extra_args = { "-R", "pmd-apex-ruleset.xml", "--cache", vim.fn.expand("$HOME/.cache/pmd") },
    }),
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
