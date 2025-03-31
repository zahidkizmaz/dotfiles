local M = {}

M.capabilities = require("blink.cmp").get_lsp_capabilities()

M.handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

M.setup_inlay_hint = function()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("InlayHintConfig", {}),
    callback = function(ev)
      if vim.fn.has("nvim-0.10") == 1 then
        local lsp_client = vim.lsp.get_client_by_id(ev.data.client_id)
        if lsp_client and lsp_client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true)
        end
      end
    end,
  })
end

M.setup = function()
  local signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  }

  local config = {
    virtual_text = false,
    signs = signs,
    update_in_insert = true,
    underline = false,
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
  M.setup_inlay_hint()
  require("lspconfig.ui.windows").default_options.border = "rounded"
end

return M
