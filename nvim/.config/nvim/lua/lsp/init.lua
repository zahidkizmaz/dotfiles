local M = {}

M.SERVER_CONFIGURATIONS = {
  ansiblels = { pattern = { "*.yaml", "*.yml" } },
  apex_ls = {
    pattern = { "*.cls", "*.trigger" },
    setup_config = function()
      return {
        apex_jar_path = vim.fn.expand("$HOME/apex-lsp/apex-jorje-lsp.jar"),
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
  efm = {
    pattern = { "*" },
    setup_config = function()
      return { init_options = { documentFormatting = true } }
    end,
  },
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
      require("neodev").setup({})
      return {
        settings = {
          Lua = {
            completion = { callSnippet = "Replace" }, -- comes from folke/neodev
            format = { enable = false },
            workspace = { checkThirdParty = false },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false },
          },
        },
      }
    end,
  },
  pylsp = {
    pattern = { "*.py" },
    setup_config = function()
      return {
        settings = {
          format = { enable = false },
          pylsp = {
            plugins = {
              yapf = { enabled = false },
              mccabe = { enabled = false },
              pyflakes = { enabled = false },
              autopep8 = { enabled = false },
              pydocstyle = { enabled = false },
              pycodestyle = { enabled = false },
              rope_autoimport = { enabled = true },
              jedi_signature_help = { enabled = true },
              pylsp_mypy = {
                dmypy = true,
                enabled = true,
                live_mode = false,
                report_progress = true,
              },
            },
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
          },
        },
      }
    end,
  },
  taplo = { pattern = { "*.toml" } },
  tailwindcss = { pattern = { "*.css", "*.scss" } },
  tsserver = { pattern = { "*.js", "*.ts", "*.jsx", "*.tsx" } },
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
  local lspconfig = require("lspconfig")
  local lsp_handlers = require("lsp.handlers")
  local default_setup_config = { capabilities = lsp_handlers.capabilities, handlers = lsp_handlers.handlers }

  for name, config in pairs(M.SERVER_CONFIGURATIONS) do
    local group = vim.api.nvim_create_augroup("SETUP_LSP_CONFIG_" .. name, { clear = true })
    vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
      group = group,
      pattern = config.pattern,
      callback = function()
        if not vim.tbl_isempty(vim.lsp.get_clients({ name = name })) then
          -- This server was already setup
          return
        end

        local custom_setup_config = {}
        if config.setup_config then
          custom_setup_config = config.setup_config()
        end
        local setup_config = vim.tbl_extend("force", default_setup_config, custom_setup_config)
        lspconfig[name].setup(setup_config)
      end,
    })
  end

  lsp_handlers.setup()
  require("lspconfig.ui.windows").default_options.border = "rounded"
end

return M
