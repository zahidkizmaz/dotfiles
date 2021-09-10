vim.cmd([[
if (has("autocmd") && !has("gui_running"))
augroup colorset
  autocmd!
  autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" } })
augroup END
endif


colorscheme onedark
]])