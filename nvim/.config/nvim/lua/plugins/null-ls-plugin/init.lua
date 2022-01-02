local null_ls = require("null-ls")

null_ls.setup({
	debug = false,
	sources = {
		null_ls.builtins.diagnostics.flake8,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.diagnostics.yamllint,
		null_ls.builtins.formatting.black.with({ extra_args = { "--fast" } }),
		null_ls.builtins.formatting.isort,
		null_ls.builtins.formatting.djhtml.with({
			filetypes = { "django", "jinja.html", "htmldjango", "html" },
			args = function(params)
				return {
					"--tabwidth",
					vim.api.nvim_buf_get_option(params.bufnr, "shiftwidth"),
				}
			end,
		}),
		null_ls.builtins.formatting.rustfmt,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.trim_newlines,
		null_ls.builtins.formatting.shfmt.with({
			filetypes = { "sh", "bash", "zsh" },
			extra_args = { "-i=2", "-ci", "-bn" },
		}),
	},
	debounce = vim.opt.updatetime:get(),
	update_on_insert = false,
	diagnostics_format = "[#{c}] #{m} (#{s})",
})
