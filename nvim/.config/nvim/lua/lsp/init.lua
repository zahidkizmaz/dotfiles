local M = {}

M.SERVER_CONFIGURATIONS = {
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
  basedpyright = {
    on_attach = function(client, _bufnr)
      -- is handled by `ty`
      client.server_capabilities.definitionProvider = false
    end,
    settings = {
      basedpyright = {
        disableOrganizeImports = true, -- covered by ruff
        typeCheckingMode = "off",
        analysis = {
          inlayHints = {
            -- https://github.com/astral-sh/ty/issues/472
            variableTypes = false, -- conflicts with ty
            callArgumentNames = false, -- conflicts with ty
            functionReturnTypes = false, -- conflicts with ty
            genericTypes = false, -- conflicts with ty
          },
          diagnosticSeverityOverrides = {
            -- rule names:
            -- https://docs.basedpyright.com/latest/configuration/config-files/
            -- -> section: "Type Check Rule Overrides"
            reportUnreachable = "none", -- lint has annoying false positives

            -- lints covered by ruff, would appear twice.
            -- also when using `noqa` comments, these would be respected by
            -- ruff, but not by pyright.
            reportUnusedImport = "none",
            reportUnusedVariable = "none",
            reportUndefinedVariable = "none",
          },
        },
      },
    },
  },
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
  vacuum = {},
  tailwindcss = {},
  taplo = {},
  terraformls = {},
  ts_ls = {},
  ty = {},
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
