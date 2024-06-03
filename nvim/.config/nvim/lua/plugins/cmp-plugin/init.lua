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

local cmp = require("cmp")
local snippy = require("snippy")

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
    ["<S-up>"] = cmp.mapping.scroll_docs(-4),
    ["<S-down>"] = cmp.mapping.scroll_docs(4),
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
    { name = "nvim_lsp" },
    { name = "cmp_tabnine" },
    {
      name = "buffer",
      max_item_count = 3,
      keyword_length = 2,
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end,
      },
    },
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
        cmp_tabnine = "[TAB9]",
      })[entry.source.name]
      return item
    end,
  },
  completion = {
    autocomplete = {
      cmp.TriggerEvent.TextChanged,
      cmp.TriggerEvent.InsertEnter,
    },
    completeopt = "menu,menuone,noselect",
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})
