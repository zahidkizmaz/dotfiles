vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	---------------------
	-- General Plugins --
	---------------------
	use({ "wbthomason/packer.nvim", event = "VimEnter" }) -- Plugin manager
	use({
		"EdenEast/nightfox.nvim",
		config = function()
			require("plugins.nightfox-plugin")
		end,
	})
	use("tpope/vim-surround")
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = function()
			require("plugins.lualine-plugin")
		end,
	})
	use({
		"voldikss/vim-floaterm",
		config = function()
			require("plugins.floaterm-plugin")
		end,
	})
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("plugins.indent-blankline-plugin")
		end,
	})
	use({
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("plugins.colorizer-plugin")
		end,
	})
	use({
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
	})
	---------------------

	-------------------------
	-- Performance Plugins --
	-------------------------
	use("lewis6991/impatient.nvim")
	use({
		"nathom/filetype.nvim",
		config = function()
			require("plugins.filetype-plugin")
		end,
	})
	-------------------------

	-----------------
	-- Git Plugins --
	-----------------
	use("tpope/vim-fugitive")
	use("tpope/vim-rhubarb") --fugitive and github integration
	use({
		"lewis6991/gitsigns.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("plugins.gitsigns-plugin")
		end,
	})
	-----------------

	---------------------
	-- Auto Completion --
	---------------------
	use({
		"hrsh7th/nvim-cmp",
		config = function()
			require("plugins.comp-plugin")
		end,
	})
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
	use({
		"williamboman/nvim-lsp-installer",
		config = function()
			require("plugins.lspinstall-plugin")
		end,
	})

	-------------------------------
	-- Telescope Related Plugins --
	-------------------------------
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
		config = function()
			require("plugins.telescope-plugin")
		end,
	})
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	-------------------------------

	-----------------------------
	-- Dev Environment Plugins --
	-----------------------------
	use("L3MON4D3/LuaSnip") -- Snippets plugin
	use("editorconfig/editorconfig-vim")
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("plugins.treesitter-plugin")
		end,
	})
	use({
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons", -- optional, for file icon
		},
		config = function()
			require("plugins.nvimtree-plugin")
		end,
	})
	use({
		"SmiteshP/nvim-gps",
		requires = "nvim-treesitter/nvim-treesitter",
		config = function()
			require("plugins.nvim-gps-plugin")
		end,
	})

	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("plugins.null-ls-plugin")
		end,
	})
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
	-----------------------------
end)
