local M = {}

M.capabilities = require("cmp_nvim_lsp").default_capabilities()
M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    virtual_text = false,
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }
  vim.diagnostic.config(config)

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspFormattingConfig", {}),
    callback = function()
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "<buffer>",
        callback = function()
          vim.lsp.buf.format({
            filter = function(client)
              local disable_formating = { "tsserver", "lua_ls", "pylsp", "rust_analyzer" }
              return not vim.tbl_contains(disable_formating, client.name)
            end,
            timeout_ms = 3000,
          })
        end,
      })
    end,
  })
end

M.handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

return M
