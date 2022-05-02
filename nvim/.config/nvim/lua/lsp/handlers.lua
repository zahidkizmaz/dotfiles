local M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

M.setup = function()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		virtual_text = false,
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
		vim.lsp.handlers.signature_help,
		{ border = "rounded" }
	)
end

local function lsp_highlight_document(client)
	if client.resolved_capabilities.document_highlight then
		local lsp_document_highlight_group = vim.api.nvim_create_augroup("LSPDocumentHighlight", { clear = true })
		vim.api.nvim_create_autocmd("CursorHold", {
			group = lsp_document_highlight_group,
			pattern = "<buffer>",
			callback = function()
				require("vim.lsp.buf").document_highlight()
			end,
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			group = lsp_document_highlight_group,
			pattern = "<buffer>",
			callback = function()
				require("vim.lsp.buf").clear_references()
			end,
		})
	end
end

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }

	vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>fo", "<cmd>lua vim.lsp.buf.formatting_sync(nil, 2500)<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
end

M.on_attach = function(client, bufnr)
	lsp_keymaps(bufnr)
	lsp_highlight_document(client)
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "<buffer>",
		callback = function()
			vim.lsp.buf.formatting_sync(nil, 2500)
		end,
	})

	if client.name == "pylsp" or client.name == "sumneko_lua" or client.name == "html" or client.name == "tsserver" then
		client.resolved_capabilities.document_formatting = false
	end
end

return M
