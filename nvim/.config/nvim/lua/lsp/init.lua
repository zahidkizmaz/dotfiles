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
local CUSTOM_CONFIGURED_SERVERS = { "lua_ls", "pylsp", "yamlls", "apex_ls", "efm" }

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = LSP_SERVERS,
  automatic_installation = true,
})

require("neodev").setup({})
local lspconfig = require("lspconfig")
local lsp_handlers = require("lsp.handlers")
local capabilities = lsp_handlers.capabilities

require("lspconfig.ui.windows").default_options.border = "rounded"

for _, server in ipairs(LSP_SERVERS) do
  if not vim.tbl_contains(CUSTOM_CONFIGURED_SERVERS, server) then
    lspconfig[server].setup({ capabilities = capabilities, handlers = lsp_handlers.handlers })
  end
end

lspconfig.yamlls.setup({
  capabilities = capabilities,
  handlers = lsp_handlers.handlers,
  settings = {
    yaml = {
      keyOrdering = false,
    },
  },
})
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  handlers = lsp_handlers.handlers,
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
  capabilities = capabilities,
  handlers = lsp_handlers.handlers,
  settings = {
    format = { enable = false },
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
lspconfig.apex_ls.setup({
  apex_jar_path = vim.fn.expand("$HOME/apex-lsp/apex-jorje-lsp.jar"),
  apex_enable_semantic_errors = true, -- Whether to allow Apex Language Server to surface semantic errors
  apex_enable_completion_statistics = false, -- Whether to allow Apex Language Server to collect telemetry on code completion usage
  filetypes = { "apexcode", "apex" },
})
lspconfig.efm.setup({
  handlers = lsp_handlers.handlers,
  init_options = { documentFormatting = true },
})

lsp_handlers.setup()
