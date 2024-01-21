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
  vim.api.nvim_set_option_value("filetype", file_type, { buf = buf })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, git_command)
  vim.api.nvim_set_option_value("readonly", true, { buf = buf })
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

function Gitui()
  local cmd = "gitui"
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")
  local window_options = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = 0,
    col = 0,
    border = "rounded",
    noautocmd = true,
  }

  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(bufnr, true, window_options)

  vim.api.nvim_del_keymap("t", "<Esc>")
  vim.fn.termopen(cmd, {
    on_exit = function()
      vim.api.nvim_set_keymap("t", "<Esc>", "<c-\\><c-n>", { silent = true })
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end,
  })
  vim.cmd([[startinsert!]])
end
