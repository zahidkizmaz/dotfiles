local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Visual shifting (does not exit Visual mode)
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Resize with arrows
keymap("n", "<leader>J", ":resize +2<CR>", opts)
keymap("n", "<leader>K", ":resize -2<CR>", opts)
keymap("n", "<leader>L", ":vertical resize -2<CR>", opts)
keymap("n", "<leader>H", ":vertical resize +2<CR>", opts)

-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv=gv", opts)
keymap("x", "K", ":move '<-2<CR>gv=gv", opts)

-- Quickfix
keymap("n", "<leader>co", ":copen <CR>", opts)
keymap("n", "<leader>cn", ":cnext <CR>", opts)
keymap("n", "<leader>cq", ":cclose <CR>", opts)
keymap("n", "<leader>cp", ":cprevious <CR>", opts)

-- Keep the register same after pasting in Visual mode
keymap("v", "p", '"_dP', opts)

keymap("n", "Q", "<nop>", opts)

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

-- Diagnostics
keymap("n", "gl", vim.diagnostic.open_float, opts)

-- Format
keymap("n", "<leader>jq", "<CMD>%!jq .<CR>", opts)
keymap("n", "<leader>fo", vim.lsp.buf.format, opts)

-- Move between windows
keymap("n", "<c-j>", "<c-w>j", opts)
keymap("n", "<c-k>", "<c-w>k", opts)
keymap("n", "<c-h>", "<c-w>h", opts)
keymap("n", "<c-l>", "<c-w>l", opts)
keymap("t", "<Esc>", "<c-\\><c-n>", { silent = true })

for i = 1, 9 do
  local lhs = "<leader>" .. i
  local rhs = i .. "<c-w>w"
  keymap("n", lhs, rhs, opts)
end

-- Bring justice to all window sizes and to cmdheight
keymap("n", "<leader>=", "<CMD>wincmd = | set cmdheight=0<CR>", opts)
keymap("n", "<leader>sw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {})

-- Open Git helpers
keymap("n", "<leader>gu", Gitui, opts)
keymap("n", "<leader>gg", "<CMD>tab Git<CR>", opts)

-- Open terminal in split
keymap("n", "<leader>T", ":sp<CR>:terminal<CR>i<CR>", opts)
keymap("n", "<leader>vt", ":vsp<CR>:terminal<CR>i<CR>", opts)

-- Open netrw
keymap("n", "<c-n>", "<CMD>Explore<CR><CR>", opts)

-- LSP
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local lsp_keymap_opts = { buffer = ev.buf, noremap = true, silent = true }

    vim.keymap.set("n", "K", vim.lsp.buf.hover, lsp_keymap_opts)
    vim.keymap.set("n", "H", vim.lsp.buf.signature_help, lsp_keymap_opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, lsp_keymap_opts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, lsp_keymap_opts)
  end,
})
