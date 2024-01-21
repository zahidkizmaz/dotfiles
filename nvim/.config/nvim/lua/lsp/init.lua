local schemastore = require("schemastore")

local M = {}
M.SERVER_CONFIGURATIONS = {
  ansiblels = { pattern = { "*.yaml", ".yml" } },
  apex_ls = {
    pattern = { "*.cls", "*.trigger" },
    setup_config = {
      apex_jar_path = vim.fn.expand("$HOME/apex-lsp/apex-jorje-lsp.jar"),
      apex_enable_semantic_errors = true, -- Whether to allow Apex Language Server to surface semantic errors
      apex_enable_completion_statistics = false, -- Whether to allow Apex Language Server to collect telemetry on code completion usage
      filetypes = { "apexcode", "apex" },
    },
  },
  bashls = {
    pattern = { "*.sh", "*.zsh", "*rc", "*zsh*" },
    setup_config = {
      filetypes = { "sh", "zsh" },
    },
  },
  cssls = {
    pattern = { "*.css", "*.scss" },
  },
  dockerls = {
    pattern = { "*Dockerfile*" },
  },
  docker_compose_language_service = {
    pattern = { "*docker-compose*" },
  },
  efm = {
    pattern = { "*" },
    setup_config = { init_options = { documentFormatting = true } },
  },
  jsonls = {
    pattern = { "*.json" },
    setup_config = {
      settings = {
        json = {
          schemas = schemastore.json.schemas(),
          validate = { enable = true },
        },
      },
    },
  },
  lemminx = {
    pattern = { "*.xml" },
  },
  lua_ls = {
    pattern = { "*.lua" },
    setup_config = {
      settings = {
        Lua = {
          completion = { callSnippet = "Replace" }, -- comes from folke/neodev
          format = { enable = false },
          workspace = { checkThirdParty = false },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = { enable = false },
        },
      },
    },
  },
  pylsp = {
    pattern = { "*.py" },
    setup_config = {
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
            rope_autoimport = { enabled = false }, -- Currently doesn't work!
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
    },
  },
  rust_analyzer = {
    pattern = { "*.rs" },
    setup_config = {
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = { command = "clippy" },
        },
      },
    },
  },
  tailwindcss = {
    pattern = { "*.css", "*.scss" },
  },
  tsserver = {
    pattern = { "*.js", "*.ts", "*.jsx", "*.tsx" },
  },
  vimls = {
    pattern = { "*.lua" },
  },
  yamlls = {
    pattern = { "*.yaml", "*.yml" },
    setup_config = {
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
    },
  },
}

M.SERVER_NAMES = vim.tbl_keys(M.SERVER_CONFIGURATIONS)

M.setup = function()
  local lspconfig = require("lspconfig")
  local lsp_handlers = require("lsp.handlers")

  for name, config in pairs(M.SERVER_CONFIGURATIONS) do
    local custom_setup_config = config.setup_config or {}
    local default_setup_config = { capabilities = lsp_handlers.capabilities, handlers = lsp_handlers.handlers }
    local setup_config = vim.tbl_extend("force", default_setup_config, custom_setup_config)

    local group = vim.api.nvim_create_augroup("setup_lsp_config_" .. name, { clear = true })
    vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
      group = group,
      pattern = config.pattern,
      callback = function()
        if not vim.tbl_isempty(vim.lsp.get_clients({ name = name })) then
          return
        end

        if name == "lua_ls" then
          require("neodev").setup({})
        end

        lspconfig[name].setup(setup_config)
      end,
    })
  end

  lsp_handlers.setup()
  require("lspconfig.ui.windows").default_options.border = "rounded"
end

return M
