function Prequire(module_str)
	local status_ok, module = pcall(require, module_str)
	if status_ok then
		return module
	else
		print("Could not load:", module_str)
	end
end

function Print_table(table)
	for k, v in pairs(table) do
		print(k, v)
	end
end

Prequire("impatient")
Prequire("settings")
Prequire("keybindings")
Prequire("plugins")
