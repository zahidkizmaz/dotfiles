vim.g.neo_tree_remove_legacy_commands = 1

require("neo-tree").setup({
  enable_diagnostics = false,
  indent = {
    indent_size = 2,
    padding = 0, -- no extra padding on left hand side
  },
  filesystem = {
    filtered_items = {
      hide_hidden = false,
      hide_dotfiles = false,
      hide_gitignored = true,
    },
    group_empty_dirs = true,
    use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes instead of relying on nvim autocmd events.
  },
  window = {
    mappings = {
      ["<space>"] = {
        "toggle_node",
        nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
      },
      ["<2-LeftMouse>"] = "open",
      ["<cr>"] = "open",
      ["S"] = "open_split",
      ["s"] = "open_vsplit",
      ["t"] = "open_tabnew",
      ["C"] = "close_node",
      ["a"] = {
        "add",
        config = {
          show_path = "relative", -- "none", "relative", "absolute"
        },
      },
      ["A"] = "add_directory", -- also accepts the config.show_path option.
      ["d"] = "delete",
      ["r"] = "rename",
      ["y"] = "copy_to_clipboard",
      ["x"] = "cut_to_clipboard",
      ["p"] = "paste_from_clipboard",
      ["c"] = "copy", -- takes text input for destination
      ["m"] = "move", -- takes text input for destination
      ["q"] = "close_window",
      ["R"] = "refresh",
      ["?"] = "show_help",
      ["z"] = "",
      ["w"] = "",
    },
  },
})
