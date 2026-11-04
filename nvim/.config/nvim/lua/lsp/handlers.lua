local M = {}

M.setup_inlay_hint = function()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("InlayHintConfig", {}),
    callback = function(ev)
      local lsp_client = vim.lsp.get_client_by_id(ev.data.client_id)
      if not (lsp_client and lsp_client.server_capabilities and lsp_client.server_capabilities.inlayHintProvider) then
        return
      end
      -- Skip virtual/unnamed buffers. Servers like nixd (clangd-based) reject
      -- non-file URIs, e.g. "fugitive://", "oil://", or bare "file://".
      if not vim.uri_from_bufnr(ev.buf):match("^file:///") then
        return
      end
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end,
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("DisableSemanticHighlighting", {}),
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client and client.server_capabilities then
        -- Using tree-sitter for semantic highlighting instead
        client.server_capabilities.semanticTokensProvider = nil
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
