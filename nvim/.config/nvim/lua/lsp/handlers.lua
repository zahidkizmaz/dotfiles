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
end

M.handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

M.on_attach = function(_)
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "<buffer>",
    callback = function()
      vim.lsp.buf.format({ timeout_ms = 3000 })
    end,
  })
end

M.on_attach_without_formatting = function(client)
  M.on_attach(client)
  client.server_capabilities.document_formatting = false
end

return M
