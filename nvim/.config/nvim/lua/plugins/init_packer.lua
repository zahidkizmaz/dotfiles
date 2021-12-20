local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer please restart Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

local packer = Prequire("packer")
if packer then
	packer.init({
		display = {
			open_fn = function()
				return require("packer.util").float({ border = "rounded" })
			end,
		},
	})
	return packer, PACKER_BOOTSTRAP
else
	return
end
