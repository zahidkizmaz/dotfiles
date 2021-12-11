vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use("tpope/vim-commentary")
	use("tpope/vim-fugitive")
	use("tpope/vim-rhubarb") --fugitive and github integration
	use("joshdick/onedark.vim")

	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/vim-vsnip",
			"hrsh7th/cmp-buffer",
		},
	})
	use("hrsh7th/cmp-nvim-lsp") -- LSP source for nvim-cmp
	use("saadparwaiz1/cmp_luasnip") -- Snippets source for nvim-cmp
	use("L3MON4D3/LuaSnip") -- Snippets plugin
	use("neovim/nvim-lspconfig")
	use("williamboman/nvim-lsp-installer")
	use("tpope/vim-surround")
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use({ "nvim-telescope/telescope.nvim", requires = { { "nvim-lua/plenary.nvim" } } })
	use({
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			require("null-ls").config({})
			require("lspconfig")["null-ls"].setup({})
		end,
		requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	})
	use({
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons", -- optional, for file icon
		},
	})
	use({
		"SmiteshP/nvim-gps",
		requires = "nvim-treesitter/nvim-treesitter",
	})
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})
	use("editorconfig/editorconfig-vim")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({
		"lewis6991/gitsigns.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
		},
	})
end)
