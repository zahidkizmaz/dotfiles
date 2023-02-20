local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap("v", "<leader>y", '"+y', opts)

-- Visual shifting (does not exit Visual mode)
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Resize with arrows
keymap("n", "<leader>j", ":resize +2<CR>", opts)
keymap("n", "<leader>k", ":resize -2<CR>", opts)
keymap("n", "<leader>l", ":vertical resize -2<CR>", opts)
keymap("n", "<leader>h", ":vertical resize +2<CR>", opts)

-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)

-- Keep the register same after pasting in Visual mode
keymap("v", "p", '"_dP', opts)

-- Tabs
keymap("n", "<leader>tt", "<cmd>tabnew<cr>", opts)
keymap("n", "<leader>tc", "<cmd>tabclose<cr>", opts)
keymap("n", "<leader>tn", "<cmd>tabnext<cr>", opts)
keymap("n", "<leader>tp", "<cmd>tabprevious<cr>", opts)

-- Terminal mode
keymap("t", "<c-\\><c-\\>", "<c-\\><c-n>", opts)

-- Diagnostics
keymap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)

-- Move between windows
keymap("n", "<c-j>", "<c-w>j", opts)
keymap("n", "<c-k>", "<c-w>k", opts)
keymap("n", "<c-h>", "<c-w>h", opts)
keymap("n", "<c-l>", "<c-w>l", opts)

for i = 1, 9 do
  local lhs = "<leader>" .. i
  local rhs = i .. "<c-w>w"
  keymap("n", lhs, rhs, opts)
end

-- Bring justice to all window sizes
keymap("n", "<leader>=", "<cmd>wincmd =<cr>", opts)
