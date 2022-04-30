vim.g.gutentags_cache_dir = "~/.cache/tags/"

vim.cmd([[
let g:gutentags_file_list_command = {
      \   'markers': {
      \     '.git': 'git ls-files --cached --others --exclude-standard',
      \   },
      \ }
    ]])
