--------------------------
-- General Vim Settings --
--------------------------
local set = vim.o
local cmd = vim.cmd
local global = vim.g
local buffer_local = vim.bo
local set_opt = vim.opt

global.python3_host_prog = vim.fn.getenv("PIPX_HOME") .. "python-lsp-server/bin/python"
global.mapleader = ","
global.did_load_filetypes = 1 -- filetype.nvim setting

set.mouse = "a"
set.hlsearch = false
set.smartcase = true
set.ignorecase = true
set.breakindent = true
set.termguicolors = true
set.splitright = true

set_opt.number = true
set_opt.undofile = true
set_opt.updatetime = 300
set_opt.lazyredraw = true
set_opt.relativenumber = true
set_opt.clipboard = "unnamedplus"

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
]])

vim.api.nvim_create_autocmd("VimResized", { pattern = "*", command = "wincmd =" })
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		require("vim.highlight").on_yank({ timeout = 250 })
	end,
})
