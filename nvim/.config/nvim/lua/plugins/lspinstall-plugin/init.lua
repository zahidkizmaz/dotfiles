-- LSP settings
local lsp_installer = require("nvim-lsp-installer")

local cfg = {}

function cfg.lsp_on_attach(client, bufnr)
	-- generic on_attach, should be passed to all language servers.

	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")

	local opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "fr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>fo", "<cmd>lua vim.lsp.buf.formatting_sync(nil, 1000)<CR>", opts)

	if client.resolved_capabilities.document_formatting then
		vim.cmd([[
                augroup AutoFormatOnSave
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)
                augroup END
        ]])
	end
end

function cfg.lsp_on_attach_without_formatting(client, bufnr)
	cfg.lsp_on_attach(client, bufnr)
	client.resolved_capabilities.document_formatting = false
	client.resolved_capabilities.document_range_formatting = false
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

lsp_installer.on_server_ready(function(server)
	local opts = {
		on_attach = cfg.lsp_on_attach,
		capabilities = capabilities,
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
		opts.on_attach = cfg.lsp_on_attach_without_formatting
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
