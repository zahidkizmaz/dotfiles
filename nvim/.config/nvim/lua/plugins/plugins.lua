vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    use "wbthomason/packer.nvim"
    use 'tpope/vim-commentary'
    use 'tpope/vim-fugitive'
    use 'itchyny/lightline.vim'
    use 'joshdick/onedark.vim'

    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/vim-vsnip",
            "hrsh7th/cmp-buffer",
        }
    }
    use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
    use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
    use 'L3MON4D3/LuaSnip' -- Snippets plugin
    use 'glepnir/lspsaga.nvim'
    use 'neovim/nvim-lspconfig'
    use 'kabouzeid/nvim-lspinstall'
    use 'tpope/vim-surround'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use { 'nvim-telescope/telescope.nvim', requires = { {'nvim-lua/plenary.nvim'} } }

end)
