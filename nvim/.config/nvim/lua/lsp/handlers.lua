local M = {}

M.setup_inlay_hint = function()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("InlayHintConfig", {}),
    callback = function(ev)
      local lsp_client = vim.lsp.get_client_by_id(ev.data.client_id)
      if lsp_client and lsp_client.server_capabilities.inlayHintProvider and not vim.lsp.inlay_hint.is_enabled() then
        vim.lsp.inlay_hint.enable(true)
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
end

return M
