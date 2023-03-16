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
keymap("n", "<leader>tt", "<CMD>tabnew<cr>", opts)
keymap("n", "<leader>tc", "<CMD>tabclose<cr>", opts)
keymap("n", "<leader>tn", "<CMD>tabnext<cr>", opts)
keymap("n", "<leader>tp", "<CMD>tabprevious<cr>", opts)

for i = 1, 9 do
  local lhs = "t" .. i
  local rhs = "<CMD>tabn " .. i .. "<CR>"
  keymap("n", lhs, rhs, opts)
end

-- Terminal mode
keymap("t", "<c-\\><c-\\>", "<c-\\><c-n>", opts)

-- Diagnostics
keymap("n", "gl", "<CMD>lua vim.diagnostic.open_float()<CR>", opts)

-- Move between windows
keymap("n", "<c-j>", "<c-w>j", opts)
keymap("n", "<c-k>", "<c-w>k", opts)
keymap("n", "<c-h>", "<c-w>h", opts)
keymap("n", "<c-l>", "<c-w>l", opts)
keymap("t", "<c-j>", "<c-\\><c-n><c-w>j", { silent = true })
keymap("t", "<c-k>", "<c-\\><c-n><c-w>k", { silent = true })
keymap("t", "<c-h>", "<c-\\><c-n><c-w>h", { silent = true })
keymap("t", "<c-l>", "<c-\\><c-n><c-w>l", { silent = true })

for i = 1, 9 do
  local lhs = "<leader>" .. i
  local rhs = i .. "<c-w>w"
  keymap("n", lhs, rhs, opts)
end

-- Bring justice to all window sizes and to cmdheight
keymap("n", "<leader>=", "<CMD>wincmd = | set cmdheight=0<CR>", opts)
