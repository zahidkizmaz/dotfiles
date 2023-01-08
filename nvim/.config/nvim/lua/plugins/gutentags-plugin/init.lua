vim.g.gutentags_cache_dir = vim.env.HOME .. "/.cache/tags"

vim.cmd([[
let g:gutentags_file_list_command = {
      \   'markers': {
      \     '.git': 'git ls-files --cached --others --exclude-standard',
      \   },
      \ }
    ]])
