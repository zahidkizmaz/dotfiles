function Prequire(module_str)
  local status_ok, module = pcall(require, module_str)
  if status_ok then
    return module
  else
    print("Could not load:", module_str)
  end
end

function Array_contains(array, value)
  for _, element in ipairs(array) do
    if element == value then
      return true
    end
  end
  return false
end

Prequire("settings")
Prequire("plugins")
Prequire("keybindings")
