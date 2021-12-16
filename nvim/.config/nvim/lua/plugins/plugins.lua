vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	---------------------
	-- General Plugins --
	---------------------
	use("wbthomason/packer.nvim") -- Plugin manager
	use("L3MON4D3/LuaSnip") -- Snippets plugin
	use("joshdick/onedark.vim") -- Colorscheme
	use("tpope/vim-surround")
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})
	use("voldikss/vim-floaterm")
	use("lukas-reineke/indent-blankline.nvim")
	---------------------

	-----------------
	-- Git Plugins --
	-----------------
	use("tpope/vim-commentary")
	use("tpope/vim-fugitive")
	use("tpope/vim-rhubarb") --fugitive and github integration
	use({
		"lewis6991/gitsigns.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
		},
	})
	-----------------

	---------------------
	-- Auto Completion --
	---------------------
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-nvim-lsp") -- LSP source for nvim-cmp
	use("saadparwaiz1/cmp_luasnip")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-nvim-lua")
	use("onsails/lspkind-nvim") -- Prettier completion menu
	---------------------

	-------------------------
	-- LSP Related Plugins --
	-------------------------
	use("neovim/nvim-lspconfig")
	use("williamboman/nvim-lsp-installer")

	-------------------------------
	-- Telescope Related Plugins --
	-------------------------------
	use({ "nvim-telescope/telescope.nvim", requires = { { "nvim-lua/plenary.nvim" } } })
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	-------------------------------

	-----------------------------
	-- Dev Environment Plugins --
	-----------------------------
	use("editorconfig/editorconfig-vim")
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
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
		"jose-elias-alvarez/null-ls.nvim",
		requires = { "nvim-lua/plenary.nvim" },
	})
	-----------------------------
end)
