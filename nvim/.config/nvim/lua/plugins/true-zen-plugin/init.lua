local present, true_zen = pcall(require, "true-zen")
if not present then
	return
end

true_zen.setup({
	ui = {
		bottom = {
			laststatus = 0,
			ruler = true,
			showmode = false,
			showcmd = false,
			cmdheight = 1,
		},
		top = {
			showtabline = 0,
		},
		left = {
			number = true,
			relativenumber = true,
			signcolumn = "yes",
		},
	},
	modes = {
		ataraxis = {
			left_padding = 32,
			right_padding = 32,
			top_padding = 1,
			bottom_padding = 0,
			ideal_writing_area_width = { 0 },
			auto_padding = true,
			keep_default_fold_fillchars = true,
			custom_bg = { "none", "" },
			bg_configuration = true,
			quit = "untoggle",
			ignore_floating_windows = true,
			affected_higroups = {
				NonText = true,
				FoldColumn = true,
				ColorColumn = true,
				VertSplit = true,
				StatusLine = true,
				StatusLineNC = true,
				SignColumn = true,
			},
		},
		focus = {
			margin_of_error = 5,
			focus_method = "experimental",
		},
	},
	integrations = {
		vim_gitgutter = false,
		galaxyline = false,
		tmux = false,
		gitsigns = false,
		nvim_bufferline = false,
		limelight = false,
		twilight = false,
		vim_airline = false,
		vim_powerline = false,
		vim_signify = false,
		express_line = false,
		lualine = true,
		lightline = false,
		feline = false,
	},
	misc = {
		on_off_commands = true,
		ui_elements_commands = true,
		cursor_by_mode = true,
	},
})
