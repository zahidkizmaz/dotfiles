local LSP_SERVERS = {
  "bashls",
  "cssls",
  "dockerls",
  "html",
  "jsonls",
  "pylsp",
  "sumneko_lua",
  "texlab",
  "tsserver",
  "vimls",
  "yamlls",
  "gopls",
  "ansiblels",
  "tailwindcss",
  "rust_analyzer",
}
local CUSTOM_CONFIGURED_SERVERS = { "sumneko_lua", "pylsp", "tsserver", "html", "rust_analyzer" }
require("mason-lspconfig").setup({
  ensure_installed = LSP_SERVERS,
  automatic_installation = true,
})

local on_attach = require("lsp.handlers").on_attach
local on_attach_without_formatting = require("lsp.handlers").on_attach_without_formatting
local capabilities = require("lsp.handlers").capabilities
local lspconfig = require("lspconfig")

for _, server in ipairs(LSP_SERVERS) do
  if not Array_contains(CUSTOM_CONFIGURED_SERVERS, server) then
    lspconfig[server].setup({ on_attach = on_attach, capabilities = capabilities })
  end
end

lspconfig.html.setup({
  on_attach = on_attach_without_formatting,
  capabilities = capabilities,
})
lspconfig.tsserver.setup({
  on_attach = on_attach_without_formatting,
  capabilities = capabilities,
})
lspconfig.sumneko_lua.setup({
  on_attach = on_attach_without_formatting,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      format = { enable = false },
      workspace = {
        checkThirdParty = false,
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
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
        pydocstyle = {
          enabled = true,
        },
        pycodestyle = {
          enabled = false,
        },
        pyflakes = {
          enabled = false,
        },
        rope_autoimport = {
          enabled = false, -- Currently doesn't work!
        },
        jedi_signature_help = {
          enabled = true,
        },
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
require("lsp.handlers").setup()
