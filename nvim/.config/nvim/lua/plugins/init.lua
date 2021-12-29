local packer, packer_bootstrap = require("plugins.init_packer")
return packer.startup(function(use)
	---------------------
	-- General Plugins --
	---------------------
	use({ "wbthomason/packer.nvim" }) -- Plugin manager
	use({
		"EdenEast/nightfox.nvim",
		config = function()
			require("plugins.nightfox-plugin")
		end,
	})
	use({
		"nvim-lualine/lualine.nvim",
		after = "nvim-web-devicons",
		requires = {
			{ "kyazdani42/nvim-web-devicons", opt = true, after = "nvim-gps" },
			{
				"SmiteshP/nvim-gps",
				event = "BufRead",
				requires = "nvim-treesitter/nvim-treesitter",
				config = function()
					require("plugins.nvim-gps-plugin")
				end,
			},
		},
		config = function()
			require("plugins.lualine-plugin")
		end,
	})
	use({
		"voldikss/vim-floaterm",
		cmd = { "FloatermToggle" },
	})
	use({
		"lukas-reineke/indent-blankline.nvim",
		event = "BufRead",
		config = function()
			require("plugins.indent-blankline-plugin")
		end,
	})
	use({
		"norcalli/nvim-colorizer.lua",
		event = "BufRead",
		config = function()
			require("colorizer").setup()
		end,
	})
	use({
		"folke/which-key.nvim",
		config = function()
			require("plugins.which-key-plugin")
		end,
	})
	use({ "tpope/vim-surround", event = "BufRead" })
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
	use("rhysd/committia.vim") -- nice commit setup
	use({ "tpope/vim-fugitive", cmd = { "Git", "Gbrowse", "GBrowse" } })
	use({ "tpope/vim-rhubarb", after = { "vim-fugitive" } }) --fugitive and github integration
	use({
		"lewis6991/gitsigns.nvim",
		event = "BufRead",
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
	use({ "hrsh7th/cmp-nvim-lsp" }) -- LSP source for nvim-cmp, Can not lazy load!
	use({
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		requires = {
			{ "hrsh7th/cmp-path", after = "nvim-cmp" },
			{ "hrsh7th/cmp-buffer", after = "nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
			{ "saadparwaiz1/cmp_luasnip", after = "LuaSnip" },
			{
				"tzachar/cmp-tabnine",
				run = "./install.sh",
				after = "nvim-cmp",
				config = function()
					require("plugins.comp-plugin.tabnine")
				end,
			},
		},
		config = function()
			require("plugins.comp-plugin")
		end,
	})
	use({
		"L3MON4D3/LuaSnip",
		after = "nvim-cmp",
		config = function()
			require("luasnip.loaders.from_vscode").load({})
		end,
	})
	use({ "rafamadriz/friendly-snippets" })
	---------------------

	-------------------------
	-- LSP Related Plugins --
	-------------------------
	use({ "neovim/nvim-lspconfig" })
	use({ "williamboman/nvim-lsp-installer" })
	use({
		"ray-x/lsp_signature.nvim",
		config = function()
			require("lsp_signature").setup()
		end,
	})

	-------------------------------
	-- Telescope Related Plugins --
	-------------------------------
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
		cmd = "Telescope",
		config = function()
			require("plugins.telescope-plugin")
		end,
	})
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	-------------------------------

	-----------------------------
	-- Dev Environment Plugins --
	-----------------------------
	use("editorconfig/editorconfig-vim")
	use({
		"nvim-treesitter/nvim-treesitter",
		event = "BufRead",
		run = ":TSUpdate",
		config = function()
			require("plugins.treesitter-plugin")
		end,
	})
	use({
		"p00f/nvim-ts-rainbow",
		after = "nvim-treesitter",
	})
	use({
		"kyazdani42/nvim-tree.lua",
		cmd = { "NvimTreeToggle" },
		requires = {
			"kyazdani42/nvim-web-devicons", -- optional, for file icon
		},
		config = function()
			require("plugins.nvimtree-plugin")
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
		keys = { "gcc", "gc" },
		config = function()
			require("Comment").setup()
		end,
	})
	use({
		"Pocco81/TrueZen.nvim",
		cmd = { "TZAtaraxis", "TZMinimalist", "TZFocus" },
		config = function()
			require("plugins.true-zen-plugin")
		end,
	})
	-----------------------------
	if packer_bootstrap then
		require("packer").sync()
	end
end)
