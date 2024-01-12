--------------------------
-- General Vim Settings --
--------------------------
local o = vim.o
local cmd = vim.cmd
local g = vim.g
local bo = vim.bo
local opt = vim.opt

g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
g.python3_host_prog = vim.fn.getenv("PIPX_HOME") .. "venvs/python-lsp-server/bin/python"
g.mapleader = " "

o.mouse = "a"
o.hlsearch = false
o.incsearch = true
o.smartcase = true
o.ignorecase = true
o.breakindent = true
o.termguicolors = true
o.splitright = true
o.cmdheight = 0

opt.wrap = true
opt.number = true
opt.backup = false
opt.undofile = true
opt.swapfile = false
opt.updatetime = 50
opt.tagcase = "smart"
opt.smartindent = true
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

vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    require("vim.highlight").on_yank({ timeout = 250 })
  end,
})
vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("win_autoresize", { clear = true }),
  desc = "Auto resize windows on resizing",
  command = "wincmd =",
})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function()
    -- get rid of auto commenting next line
    vim.cmd("set formatoptions-=cro")
  end,
})

-- Extra filetypes
vim.filetype.add({
  filename = {
    ["Pipfile"] = "toml",
    ["Pipfile.lock"] = "json",
    ["poetry.lock"] = "toml",
    [".env"] = "sh",
    [".envrc"] = "sh",
    ["direnvrc"] = "sh",
    [".xinitrc"] = "sh",
    [".bash_profile"] = "sh",
  },
  pattern = {
    ["requirements*.in"] = "requirements",
    ["requirements*.txt"] = "requirements",
    ["main.y[a]?ml"] = "yaml.ansible",
    ["install.y[a]?ml"] = "yaml.ansible",
    ["update.y[a]?ml"] = "yaml.ansible",
    ["playbook.y[a]?ml"] = "yaml.ansible",
    [".*/roles/.*/*.y[a]?ml"] = "yaml.ansible",
    [".*/tasks/.*/*.y[a]?ml"] = "yaml.ansible",
    [".*/handlers/.*/*.y[a]?ml"] = "yaml.ansible",
  },
})

-- Apex file types
vim.filetype.add({
  extension = {
    cls = "apex",
    apex = "apex",
    trigger = "apex",
    soql = "soql",
    sosl = "sosl",
  },
})
