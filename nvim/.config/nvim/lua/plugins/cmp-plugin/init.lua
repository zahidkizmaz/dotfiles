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

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

local cmp = require("cmp")
local snippy = require("snippy")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      snippy.expand_snippet(args.body)
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
      select = false,
      { "i", "c" },
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif snippy.can_expand_or_advance() then
        snippy.expand_or_advance()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif snippy.can_jump(-1) then
        snippy.previous()
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = "snippy", max_item_count = 3 },
    { name = "nvim_lua" },
    { name = "nvim_lsp", max_item_count = 10 },
    { name = "nvim_lsp_signature_help" },
    { name = "cmp_tabnine", max_item_count = 5 },
    { name = "buffer", keyword_length = 2 },
    { name = "path" },
  },
  formatting = {
    format = function(entry, item)
      item.kind = lsp_symbols[item.kind]
      item.menu = ({
        path = "[PATH]",
        buffer = "[BUF]",
        snippy = "[SNIP]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[API]",
        cmp_tabnine = "[TAB9]",
      })[entry.source.name]
      return item
    end,
  },
  window = {
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
  },
  view = {
    entries = "native",
  },
  experimental = {
    ghost_text = true,
  },
})

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
