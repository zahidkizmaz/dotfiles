require("filetype").setup({
  overrides = {
    extensions = {
      crs = "rust",
    },
    literal = {
      ["poetry.lock"] = "toml",
      ["Pipfile"] = "toml",
      ["Pipfile.lock"] = "json",
      [".envrc"] = "sh",
      [".xinitrc"] = "sh",
      [".zshrc"] = "sh",
      [".bash_profile"] = "sh",
      [".direnvrc"] = "sh",
      [".env"] = "sh",
    },
    complex = {
      ["requirements*.txt"] = "requirements",
      ["requirements*.in"] = "requirements",
    },
  },
})
