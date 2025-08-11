local M = {}

M.SERVER_CONFIGURATIONS = {
  ansiblels = {},
  apex_ls = {
    apex_enable_semantic_errors = true, -- Whether to allow Apex Language Server to surface semantic errors
    apex_enable_completion_statistics = false, -- Whether to allow Apex Language Server to collect telemetry on code completion usage
    cmd = "apex.jorje.lsp.ApexLanguageServerLauncher",
    filetypes = { "apexcode", "apex" },
  },
  bashls = { filetypes = { "sh", "zsh" } },
  cssls = {},
  docker_compose_language_service = {},
  dockerls = {},
  emmylua_ls = {},
  htmx = {},
  nixd = {},
  hyprls = {},
  jsonls = function()
    return {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    }
  end,
  lemminx = {},
  basedpyright = { settings = { basedpyright = { typeCheckingMode = "basic" } } },
  nushell = {},
  ruff = {
    init_options = {
      settings = {
        configurationPreference = "filesystemFirst",
        organizeImports = true,
      },
    },
  },
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = { command = "clippy" },
        assist = {
          importMergeBehavior = "last",
          importPrefix = "by_self",
        },
        files = {
          excludeDirs = { "target" },
        },
        workspace = {
          symbol = { search = { limit = 3000 } },
        },
        procMacro = {
          enable = true,
        },
        diagnostics = {
          enable = true,
          disabled = { "unresolved-proc-macro" },
          enableExperimental = true,
        },
        cargo = {
          features = "all",
          loadOutDirsFromCheck = true,
        },
      },
    },
  },
  taplo = {},
  tailwindcss = {},
  terraformls = {},
  ts_ls = {},
  typos_lsp = {},
  yamlls = function()
    return {
      settings = {
        yaml = {
          keyOrdering = false,
          schemaStore = {
            -- disable built-in schemaStore support if you want to use
            -- schemastore plugin and its advanced options like `ignore`.
            enable = false,
            -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
            url = "",
          },
          schemas = require("schemastore").yaml.schemas(),
        },
      },
    }
  end,
}

M.setup = function()
  for name, config in pairs(M.SERVER_CONFIGURATIONS) do
    local custom_setup_config = {}
    if type(config) == "function" then
      custom_setup_config = config()
    elseif type(config) == "table" then
      custom_setup_config = config
    end
    vim.lsp.config(name, custom_setup_config)
    vim.lsp.enable(name)
  end

  require("lsp.handlers").setup()
end

return M
