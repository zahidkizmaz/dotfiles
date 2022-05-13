local LSP_SERVERS = {
	"bashls",
	"cssls",
	"dockerls",
	"grammarly",
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
	"sourcery",
}
local CUSTOM_CONFIGURED_SERVERS = { "sumneko_lua", "pylsp", "tsserver", "html" }

require("nvim-lsp-installer").setup({
	ensure_installed = LSP_SERVERS,
	automatic_installation = true,
})
local lspconfig = require("lspconfig")
local on_attach = require("lsp.handlers").on_attach
local on_attach_without_formatting = require("lsp.handlers").on_attach_without_formatting
local capabilities = require("lsp.handlers").capabilities

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
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			format = {
				enable = false,
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
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
					enabled = false,
				},
				pycodestyle = {
					enabled = false,
				},
				pyflakes = {
					enabled = false,
				},
				pylsp_mypy = {
					enabled = true,
					live_mode = false,
					dmypy = true,
				},
			},
		},
	},
})
require("lsp.handlers").setup()
