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

function TabnewGitcommit()
  -- A helper function that ties up vim-fugitive and committia.vim together
  -- When called create a new tab with committia's commit setup
  vim.g.committia_open_only_vim_starting = 0
  vim.cmd("tab Git commit")
  vim.g.committia_open_only_vim_starting = 1
end

-- FormatEnable - FormatDisable commands
vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, { desc = "Re-enable autoformat-on-save" })

-- Snacks nvim commands
-- mini.files rename integration
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesActionRename",
  callback = function(event)
    Snacks.rename.on_rename_file(event.data.from, event.data.to)
  end,
})

-- oil.nvim rename integration
vim.api.nvim_create_autocmd("User", {
  pattern = "OilActionsPost",
  callback = function(event)
    if event.data.actions[1].type == "move" then
      Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
    end
  end,
})

-- auto reload helpers
vim.api.nvim_create_autocmd("FocusGained", {
  desc = "Reload files from disk when we focus vim",
  pattern = "*",
  command = "if getcmdwintype() == '' | checktime | endif",
})
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Every time we enter an unmodified buffer, check if it changed on disk",
  pattern = "*",
  command = "if &buftype == '' && !&modified && expand('%') != '' | exec 'checktime ' . expand('<abuf>') | endif",
})
