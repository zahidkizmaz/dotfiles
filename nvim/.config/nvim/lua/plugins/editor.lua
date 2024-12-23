return {
  {
    "echasnovski/mini.surround",
    event = { "BufReadPost", "BufNewFile", "InsertEnter" },
    config = true,
  },
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "v0.8.1",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = {
        preset = "none",
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<Tab>"] = {
          "snippet_forward",
          "select_next",
          "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      sources = { default = { "lsp", "buffer", "path", "snippets" } },
      signature = {
        enabled = true,
        window = { border = "rounded" },
      },
      completion = {
        -- Insert completion item on selection, don't select by default
        list = { selection = "auto_insert" },
        menu = {
          -- nvim-cmp style menu
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind" },
            },
          },
          border = "rounded",
        },
        documentation = { auto_show = true, window = { border = "rounded" } },
      },
    },
    opts_extend = { "sources.default" },
  },
}
