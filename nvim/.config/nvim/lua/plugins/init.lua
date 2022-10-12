local packer, packer_bootstrap = require("plugins.init_packer")
return packer.startup(function(use)
	---------------------
	-- General Plugins --
	---------------------
	use({ "wbthomason/packer.nvim" }) -- Plugin manager
	use({
		"catppuccin/nvim",
		as = "catppuccin",
		config = function()
			require("plugins.catpuccin-plugin")
		end,
	})
	use({
		"nvim-lualine/lualine.nvim",
		after = "nvim-web-devicons",
		requires = { { "kyazdani42/nvim-web-devicons", opt = true, event = "BufRead" } },
		config = function()
			require("plugins.lualine-plugin")
		end,
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
		event = "BufWinEnter",
		config = function()
			require("plugins.which-key-plugin")
		end,
	})
	use({
		"kylechui/nvim-surround",
		event = "BufRead",
		config = function()
			require("nvim-surround").setup({})
		end,
	})
	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
	})
	use({
		"sindrets/winshift.nvim",
		event = "BufWinEnter",
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
	use("rhysd/committia.vim") -- nice commit setup
	use({
		"ruifm/gitlinker.nvim", -- Open current working line in remove git host
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("plugins.gitlinker-plugin")
		end,
	})
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
	use({
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		requires = {
			{ "hrsh7th/cmp-path", after = "nvim-cmp" },
			{ "hrsh7th/cmp-buffer", after = "nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" },
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
	use({ "hrsh7th/cmp-nvim-lsp" }) -- LSP source for nvim-cmp
	use({ "neovim/nvim-lspconfig" })
	use({
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	})
	use({
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("lsp")
		end,
	})
	use({
		"ibhagwan/fzf-lua",
		cmd = { "FzfLua" },
		config = function()
			require("plugins.fzf-lua-plugin")
		end,
	})
	-------------------------------

	-----------------------------
	-- Dev Environment Plugins --
	-----------------------------
	use("editorconfig/editorconfig-vim")
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("plugins.treesitter-plugin")
		end,
	})
	use({ "nvim-treesitter/nvim-treesitter-context" })
	use({ "p00f/nvim-ts-rainbow" })
	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		cmd = { "Neotree" },
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "kyazdani42/nvim-web-devicons", opt = true, event = "BufRead" },
			{ "MunifTanjim/nui.nvim" },
		},
		config = function()
			require("plugins.neotree-plugin")
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
			require("Comment").setup({})
		end,
	})
	use({
		"Pocco81/TrueZen.nvim",
		cmd = { "TZAtaraxis", "TZMinimalist", "TZFocus" },
		config = function()
			require("plugins.true-zen-plugin")
		end,
	})
	use({
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		after = "nvim-cmp",
		config = function()
			require("plugins.autopairs-plugin")
		end,
	})
	use({
		"danymat/neogen",
		cmd = { "Neogen" },
		config = function()
			require("neogen").setup({})
		end,
	})
	use({
		"ludovicchabant/vim-gutentags",
		config = function()
			require("plugins.gutentags-plugin")
		end,
	})
	use({
		"j-hui/fidget.nvim",
		event = "InsertEnter",
		config = function()
			require("fidget").setup({})
		end,
	})
	-----------------------------
	if packer_bootstrap then
		require("packer").sync()
	end
end)
