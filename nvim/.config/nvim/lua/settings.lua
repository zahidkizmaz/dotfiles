--------------------------
-- General Vim Settings --
--------------------------
local o = vim.o
local cmd = vim.cmd
local g = vim.g
local bo = vim.bo
local opt = vim.opt

g.python3_host_prog = vim.fn.getenv("PIPX_HOME") .. "venvs/python-lsp-server/bin/python"
g.mapleader = " "

o.mouse = "a"
o.spell = true
o.spelloptions = "camel"
o.hlsearch = false
o.smartcase = true
o.ignorecase = true
o.breakindent = true
o.termguicolors = true
o.splitright = true
o.cmdheight = 0

opt.number = true
opt.backup = false
opt.undofile = true
opt.swapfile = false
opt.updatetime = 300
opt.tagcase = "smart"
opt.lazyredraw = true
opt.relativenumber = true
opt.clipboard = "unnamedplus"
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
-- search files into subfolders
-- provides tab-complete for all files
-- by default we had `/usr/include` in here, which we don't need
opt.path = { ".", "**" }
-- vim wildignore. Used for path autocomplete and `gf`.
opt.wildignore:append({
  "*/.git/",
  "*/__pycache__/",
  "*/.direnv/",
  "*/node_modules/",
  "*/.pytest_cache/",
  "*/.mypy_cache/",
  "*/target/", -- rust target directory
  "tags",
})

bo.shiftwidth = 4
bo.softtabstop = 4
bo.expandtab = true

cmd([[
cnoreabbrev E e
cnoreabbrev W w
cnoreabbrev WQ wq
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev WA wa
cnoreabbrev Q q
cnoreabbrev QA qa
cnoreabbrev Qa qa
cnoreabbrev q1 q!
cnoreabbrev Q1 q!
cnoreabbrev qa1 qa!
cnoreabbrev qA! qa!
cnoreabbrev Qa! qa!
cnoreabbrev QA! qa!
cnoreabbrev Qa1 qa!
cnoreabbrev QA1 qa!

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=99
]])

vim.api.nvim_create_autocmd("VimResized", { pattern = "*", command = "wincmd =" })
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    require("vim.highlight").on_yank({ timeout = 250 })
  end,
})
