local null_ls = require("null-ls")

null_ls.config({
	debug = true,
	sources = {
		null_ls.builtins.code_actions.gitsigns,
		null_ls.builtins.code_actions.proselint,
		null_ls.builtins.diagnostics.flake8,
		null_ls.builtins.diagnostics.hadolint,
		null_ls.builtins.diagnostics.luacheck.with({ command = "luacheck --globals vim" }),
		null_ls.builtins.diagnostics.markdownlint,
		null_ls.builtins.diagnostics.proselint,
		null_ls.builtins.diagnostics.shellcheck,
		null_ls.builtins.diagnostics.vint,
		null_ls.builtins.diagnostics.write_good,
		null_ls.builtins.diagnostics.yamllint,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.isort,
		null_ls.builtins.formatting.rustfmt,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.taplo,
		null_ls.builtins.formatting.trim_newlines,
	},
	debounce = vim.opt.updatetime:get(),
	update_on_insert = false,
	diagnostics_format = "[#{c}] #{m} (#{s})",
})