require("cmp_tabnine.config"):setup({
  sort = true,
  max_num_results = 10,
  run_on_every_keystroke = true,
})

local function cmp_prefetch_git_files()
  local root_git_dir = vim.fn.systemlist({ "git", "rev-parse", "--show-toplevel" }) or {}
  if not vim.tbl_isempty(root_git_dir) then
    local root_git_dir_path = root_git_dir[1]

    local git_files = vim.fn.systemlist({ "git", "ls-files" }) or {}
    for _, file in ipairs(git_files) do
      local file_path = root_git_dir_path .. "/" .. file
      require("cmp_tabnine"):prefetch(vim.fn.expand(file_path))
    end
  end
end
vim.schedule(cmp_prefetch_git_files)
