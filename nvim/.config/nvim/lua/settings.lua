--------------------------
-- General Vim Settings --
--------------------------
local set = vim.o
local cmd = vim.cmd
local global = vim.g
local buffer_local = vim.bo
local set_opt = vim.opt

vim.g.python3_host_prog = vim.fn.expand("$HOME/.pyenv/versions/nvim-venv-3.10.0/bin/python")

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
set_opt.lazyredraw = true
set_opt.relativenumber = true

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


au TextYankPost * silent! lua vim.highlight.on_yank({timeout=250})


" auto-adjust splits when window is resized
" https://vi.stackexchange.com/questions/201/make-panes-resize-when-host-window-is-resized
autocmd VimResized * wincmd =
]])
