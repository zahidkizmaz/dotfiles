local keymap = vim.api.nvim_set_keymap

keymap("v", "<leader>y", '"+y', { noremap = true })
keymap("n", "<c-j>", "<c-w>j", { noremap = true })
keymap("n", "<c-k>", "<c-w>k", { noremap = true })
keymap("n", "<c-h>", "<c-w>h", { noremap = true })
keymap("n", "<c-l>", "<c-w>l", { noremap = true })
