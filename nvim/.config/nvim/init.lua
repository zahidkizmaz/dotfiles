local function prequire(module_str)
  local status_ok, module = pcall(require, module_str)
  if status_ok then
    return module
  else
    print("Could not load:", module_str)
  end
end

prequire("settings")
prequire("plugins")
prequire("commands")
prequire("keymaps")
