require("nvim-lsp-installer").on_server_ready(function(server)
	local opts = {
		on_attach = require("lsp.handlers").on_attach,
		capabilities = require("lsp.handlers").capabilities,
	}

	-- Setup server specific settings.
	if server.name == "sumneko_lua" then
		opts.settings = {
			Lua = {
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { "vim" },
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
		}
	elseif server.name == "pylsp" then
		opts.settings = {
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
					jedi_signature_help = {
						enabled = false,
					},
					pylsp_mypy = {
						enabled = true,
						live_mode = false,
						dmypy = true,
					},
				},
			},
		}
	end

	server:setup(opts)
end)

require("lsp.handlers").setup()
