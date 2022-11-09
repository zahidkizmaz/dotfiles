--------------------------
-- General Vim Settings --
--------------------------
local set = vim.o
local cmd = vim.cmd
local global = vim.g
local buffer_local = vim.bo
local set_opt = vim.opt

global.python3_host_prog = vim.fn.getenv("PIPX_HOME") .. "venvs/python-lsp-server/bin/python"
global.mapleader = " "

set.mouse = "a"
set.spell = true
set.spelloptions = "camel"
set.hlsearch = false
set.smartcase = true
set.ignorecase = true
set.breakindent = true
set.termguicolors = true
set.splitright = true
set.cmdheight = 0

set_opt.number = true
set_opt.undofile = true
set_opt.updatetime = 300
set_opt.lazyredraw = true
set_opt.relativenumber = true
set_opt.tagcase = "smart"
set_opt.clipboard = "unnamedplus"
-- search files into subfolders
-- provides tab-complete for all files
-- by default we had `/usr/include` in here, which we don't need
set_opt.path = { ".", "**" }
-- vim wildignore. Used for path autocomplete and `gf`.
set_opt.wildignore:append({
	"*/.git/", -- I might have to remove this when fugitive has problems
	"*/__pycache__/",
	"*/.direnv/",
	"*/node_modules/",
	"*/.pytest_cache/",
	"*/.mypy_cache/",
	"*/target/", -- rust target directory
	"tags",
})

buffer_local.shiftwidth = 4
buffer_local.softtabstop = 4
buffer_local.expandtab = true

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
