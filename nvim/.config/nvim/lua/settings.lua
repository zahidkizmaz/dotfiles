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
g.mapleader = " "

-- neovide
g.neovide_position_animation_length = 0
g.neovide_cursor_animation_length = 0.00
g.neovide_cursor_trail_size = 0
g.neovide_cursor_animate_in_insert_mode = false
g.neovide_cursor_animate_command_line = false
g.neovide_scroll_animation_far_lines = 0
g.neovide_scroll_animation_length = 0.00

-- netrw settings
g.netrw_liststyle = 3 -- tree style view in netrw
g.netrw_altv = 1 -- change from left splitting to right splitting

o.mouse = "a"
o.hlsearch = false
o.incsearch = true
o.smartcase = true
o.ignorecase = true
o.breakindent = true
o.termguicolors = true
o.splitright = true
o.splitbelow = true

opt.wrap = true
opt.number = true
opt.backup = false
opt.undofile = true
opt.swapfile = false
opt.updatetime = 50
opt.tagcase = "smart"
opt.autoindent = true
opt.smartindent = true
opt.relativenumber = true
opt.clipboard = "unnamedplus"
opt.undodir = vim.fn.stdpath("cache") .. "/undodir"
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

-- spell checker
opt.spell = true
opt.spelllang = "en_us"

bo.shiftwidth = 4
bo.softtabstop = 4
bo.expandtab = true

cmd([[
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevelstart=99
]])

vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.hl.on_yank({ timeout = 250 })
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

vim.filetype.add({
  extension = {
    cls = "apex",
    apex = "apex",
    trigger = "apex",
    soql = "soql",
    sosl = "sosl",

    typ = "typst",
    edi = "edi",
  },
  filename = { justfile = "just" },
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})

vim.filetype.add({
  pattern = {
    ["openapi.*%.ya?ml"] = "yaml.openapi",
    ["openapi.*%.json"] = "json.openapi",
  },
})
