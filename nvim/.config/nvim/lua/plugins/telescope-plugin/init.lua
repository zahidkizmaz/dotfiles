require("telescope").setup({
	defaults = {
        extensions = {
						fzf = {
							fuzzy = true, -- false will only do exact matching
							override_generic_sorter = true, -- override the generic sorter
							override_file_sorter = true, -- override the file sorter
							case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						},
					},
	},
    require("telescope").load_extension("fzf")
})

vim.api.nvim_set_keymap(
	"n",
	"<Leader>ff",
	'<cmd>:lua require("telescope.builtin").find_files()<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<Leader>fg",
	'<cmd>:lua require("telescope.builtin").git_files()<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<Leader>rg",
	'<cmd>:lua require("telescope.builtin").live_grep()<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<Leader>fb",
	'<cmd>:lua require("telescope.builtin").buffers()<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<Leader>fs",
	'<cmd>:lua require("telescope.builtin").current_buffer_fuzzy_find()<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<Leader>fh",
	'<cmd>:lua require("telescope.builtin").help_tags()<CR>',
	{ noremap = true, silent = true }
)
