--Set statusbar
vim.g.lightline = {
	colorscheme = "onedark",
	active = { left = { { "mode", "paste" }, { "gitbranch", "readonly", "filename", "modified" } } },
	component_function = { gitbranch = "fugitive#head" },
}
