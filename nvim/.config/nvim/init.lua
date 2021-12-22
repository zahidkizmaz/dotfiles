function Prequire(module_str)
	local status_ok, module = pcall(require, module_str)
	if status_ok then
		return module
	else
		print("Couldn't load ", module_str)
		print(error)
		return
	end
end

Prequire("impatient")
Prequire("settings")
Prequire("keybindings")
Prequire("plugins")
Prequire("lsp")
