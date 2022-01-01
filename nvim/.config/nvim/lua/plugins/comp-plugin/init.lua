-- symbols for autocomplete
local lsp_symbols = {
	Class = "   Class",
	Color = "   Color",
	Constant = "   Constant",
	Constructor = "   Constructor",
	Enum = " ❐  Enum",
	EnumMember = "   EnumMember",
	Event = "   Event",
	Field = " ﴲ  Field",
	File = "   File",
	Folder = "   Folder",
	Function = "   Function",
	Interface = " ﰮ  Interface",
	Keyword = "   Keyword",
	Method = "   Method",
	Module = "   Module",
	Operator = "   Operator",
	Property = "   Property",
	Reference = "   Reference",
	Snippet = " ﬌  Snippet",
	Struct = " ﳤ  Struct",
	Text = "   Text",
	TypeParameter = "   TypeParameter",
	Unit = "   Unit",
	Value = "   Value",
	Variable = "[] Variable",
}

local check_backspace = function()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

local cmp = require("cmp")
local luasnip = require("luasnip")
cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
		["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
			{ "i", "c" },
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expandable() then
				luasnip.expand()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif check_backspace() then
				fallback()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	},
	sources = {
		{ name = "nvim_lua" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "cmp_tabnine" },
		{ name = "buffer", keyword_length = 2 },
		{ name = "path" },
	},
	formatting = {
		format = function(entry, item)
			item.kind = lsp_symbols[item.kind]
			item.menu = ({
				buffer = "[Buf]",
				nvim_lsp = "[LSP]",
				nvim_lua = "[Api]",
				path = "[Path]",
				luasnip = "[Snip]",
				cmp_tabnine = "[Tab9]",
			})[entry.source.name]
			return item
		end,
	},
	documentation = {
		border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
	},
	experimental = {
		ghost_text = true,
		native_menu = true,
	},
})
