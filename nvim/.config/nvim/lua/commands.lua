local function git_show(branch)
  local Job = require("plenary.job")

  local file_path = vim.fn.expand("%")
  local file_type = vim.bo.filetype
  local branch_file = branch .. ":" .. file_path
  local git_command = Job:new({
    command = "git",
    args = { "show", branch_file },
  }):sync()

  vim.cmd("vsplit")
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_name(buf, branch_file)
  vim.api.nvim_buf_set_option(buf, "filetype", file_type)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, git_command)
  vim.api.nvim_buf_set_option(buf, "readonly", true)
  vim.api.nvim_win_set_buf(win, buf)
end

vim.api.nvim_create_user_command("Gshow", function(opts)
  local branch = opts.args or "master"
  git_show(branch)
end, {
  nargs = "?",
  complete = function(arg)
    local Job = require("plenary.job")
    local result = Job:new({
      command = "git",
      args = { "for-each-ref", "--sort=-committerdate", "refs/", "--format=%(refname:short)" },
    }):sync()

    if arg then
      local filtered_result = {}
      for _, value in ipairs(result) do
        if vim.startswith(value:lower(), arg:lower()) then
          table.insert(filtered_result, value)
        end
      end
      return filtered_result
    end
    return result
  end,
})
