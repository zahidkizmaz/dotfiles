local LSP_SERVERS = {
  "ansiblels",
  "apex_ls",
  "bashls",
  "cssls",
  "dockerls",
  "efm",
  "jsonls",
  "lemminx",
  "lua_ls",
  "pylsp",
  "rust_analyzer",
  "tailwindcss",
  "texlab",
  "tsserver",
  "vimls",
  "yamlls",
}
local CUSTOM_CONFIGURED_SERVERS = { "lua_ls", "pylsp", "tsserver", "rust_analyzer", "yamlls", "apex_ls", "efm" }
require("mason-lspconfig").setup({
  ensure_installed = LSP_SERVERS,
  automatic_installation = true,
})

local lspconfig = require("lspconfig")
local lsp_handlers = require("lsp.handlers")
local on_attach = lsp_handlers.on_attach
local capabilities = lsp_handlers.capabilities
local on_attach_without_formatting = lsp_handlers.on_attach_without_formatting
local on_attach_with_formatting = lsp_handlers.on_attach

for _, server in ipairs(LSP_SERVERS) do
  if not Array_contains(CUSTOM_CONFIGURED_SERVERS, server) then
    lspconfig[server].setup({ on_attach = on_attach, capabilities = capabilities })
  end
end

lspconfig.yamlls.setup({
  on_attach = on_attach_with_formatting,
  capabilities = capabilities,
  settings = {
    yaml = {
      keyOrdering = false,
    },
  },
})
lspconfig.tsserver.setup({
  on_attach = on_attach_without_formatting,
  capabilities = capabilities,
})
lspconfig.lua_ls.setup({
  on_attach = on_attach_without_formatting,
  capabilities = capabilities,
  settings = {
    Lua = {
      completion = { callSnippet = "Replace" }, -- comes from folke/neodev
      format = { enable = false },
      workspace = { checkThirdParty = false },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = { enable = false },
    },
  },
})
lspconfig.pylsp.setup({
  on_attach = on_attach_without_formatting,
  capabilities = capabilities,
  settings = {
    format = {
      enable = false,
    },
    pylsp = {
      plugins = {
        yapf = { enabled = false },
        mccabe = { enabled = false },
        pyflakes = { enabled = false },
        autopep8 = { enabled = false },
        pydocstyle = { enabled = false },
        pycodestyle = { enabled = false },
        rope_autoimport = { enabled = false }, -- Currently doesn't work!
        jedi_signature_help = { enabled = true },
        pylsp_mypy = {
          dmypy = true,
          enabled = true,
          live_mode = false,
          report_progress = true,
        },
      },
    },
  },
})
lspconfig.rust_analyzer.setup({
  capabilities = capabilities,
  on_attach = on_attach_without_formatting,
})
lspconfig.apex_ls.setup({
  apex_jar_path = vim.fn.expand("$HOME/apex-lsp/apex-jorje-lsp.jar"),
  apex_enable_semantic_errors = true, -- Whether to allow Apex Language Server to surface semantic errors
  apex_enable_completion_statistics = false, -- Whether to allow Apex Language Server to collect telemetry on code completion usage
})
lspconfig.efm.setup({
  init_options = { documentFormatting = true },
})

lsp_handlers.setup()
