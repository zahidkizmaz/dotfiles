
local opts = { noremap = true, silent = true }
vim.api.nvim_buf_set_keymap('n', '<leader>ca', '<Cmd>Lspsaga code_action<CR>', opts)
vim.api.nvim_buf_set_keymap('v', '<leader>ca', '<Cmd>Lspsaga range_code_action<CR>', opts)

vim.api.nvim_buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

local saga = require 'lspsaga'

saga.init_lsp_saga()
