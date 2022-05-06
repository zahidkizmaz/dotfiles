local LSP_SERVERS = {
	"bashls",
	"cssls",
	"dockerls",
	"grammarly",
	"html",
	"jsonls",
	"pylsp",
	"pylsp_mypy",
	"sumneko_lua",
	"texlab",
	"tsserver",
	"vimls",
	"yamlls",
	"gopls",
	"ansiblels",
}

require("nvim-lsp-installer").setup({
	ensure_installed = LSP_SERVERS,
	automatic_installation = true,
})
local lspconfig = require("lspconfig")
local on_attach = require("lsp.handlers").on_attach
local capabilities = require("lsp.handlers").capabilities

for _, server in ipairs(LSP_SERVERS) do
	if not (server == "sumneko_lua" or server == "pylsp") then
		lspconfig[server].setup({ on_attach = on_attach, capabilities = capabilities })
	end
end
lspconfig.sumneko_lua.setup({
	on_attach = on_attach,
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
	on_attach = on_attach,
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
