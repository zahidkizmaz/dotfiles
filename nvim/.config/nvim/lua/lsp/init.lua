local M = {}

M.SERVER_CONFIGURATIONS = {
  ansiblels = { pattern = { "*.yaml", "*.yml" } },
  apex_ls = {
    pattern = { "*.cls", "*.trigger" },
    setup_config = function()
      return {
        apex_enable_semantic_errors = true, -- Whether to allow Apex Language Server to surface semantic errors
        apex_enable_completion_statistics = false, -- Whether to allow Apex Language Server to collect telemetry on code completion usage
        filetypes = { "apexcode", "apex" },
      }
    end,
  },
  bashls = {
    pattern = { "*.sh", "*.zsh", "*rc", "*zsh*" },
    setup_config = function()
      return {
        filetypes = { "sh", "zsh" },
      }
    end,
  },
  cssls = { pattern = { "*.css", "*.scss" } },
  dockerls = { pattern = { "*Dockerfile*" } },
  docker_compose_language_service = { pattern = { "*docker-compose*" } },
  htmx = { pattern = { "*.html" } },
  nixd = { pattern = { "*.nix" } },
  hyprls = { pattern = { "hypr*.conf" } },
  jsonls = {
    pattern = { "*.json" },
    setup_config = function()
      local schemastore = require("schemastore")
      return {
        settings = {
          json = {
            schemas = schemastore.json.schemas(),
            validate = { enable = true },
          },
        },
      }
    end,
  },
  lemminx = { pattern = { "*.xml" } },
  lua_ls = {
    pattern = { "*.lua" },
    setup_config = function()
      return {
        settings = {
          Lua = {
            format = { enable = false },
            workspace = {
              checkThirdParty = false,
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
            },

            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim" },
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false },
          },
        },
      }
    end,
  },
  basedpyright = {
    pattern = { "*.py" },
    setup_config = function()
      return {
        settings = {
          basedpyright = {
            typeCheckingMode = "basic",
          },
        },
      }
    end,
  },
  nushell = { pattern = { "*.nu" } },
  ruff = {
    pattern = { "*.py" },
    setup_config = function()
      return {
        init_options = {
          settings = {
            configurationPreference = "filesystemFirst",
            organizeImports = true,
          },
        },
      }
    end,
  },
  rust_analyzer = {
    pattern = { "*.rs" },
    setup_config = function()
      return {
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
      }
    end,
  },
  taplo = { pattern = { "*.toml" } },
  tailwindcss = { pattern = { "*.css", "*.scss" } },
  ts_ls = { pattern = { "*.js", "*.ts", "*.jsx", "*.tsx" } },
  typos_lsp = { pattern = { "*" } },
  yamlls = {
    pattern = { "*.yaml", "*.yml" },
    setup_config = function()
      local schemastore = require("schemastore")
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
            schemas = schemastore.yaml.schemas(),
          },
        },
      }
    end,
  },
}

M.setup = function()
  local lsp_handlers = require("lsp.handlers")
  local default_setup_config = { capabilities = vim.lsp.protocol.make_client_capabilities() }

  for name, config in pairs(M.SERVER_CONFIGURATIONS) do
    local group = vim.api.nvim_create_augroup("SETUP_LSP_CONFIG_" .. name, { clear = true })
    vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
      group = group,
      pattern = config.pattern,
      callback = function()
        if not vim.tbl_isempty(vim.lsp.get_clients({ name = name })) then
          return -- This server was already setup
        end

        local custom_setup_config = {}
        if config.setup_config then
          custom_setup_config = config.setup_config()
        end
        local setup_config = vim.tbl_extend("force", default_setup_config, custom_setup_config)
        vim.lsp.config(name, setup_config)
        vim.lsp.enable(name)
      end,
    })
  end

  lsp_handlers.setup()
end

return M
