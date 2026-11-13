return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        basedpyright = function()
          Snacks.util.lsp.on({ name = "basedpyright" }, function(_, client)
            -- Keep navigation/completion without displaying type-checking noise.
            for _, is_pull in ipairs({ false, true }) do
              local ns = vim.lsp.diagnostic.get_namespace(client.id, is_pull)
              vim.diagnostic.enable(false, { ns_id = ns })
            end
          end)
        end,
      },
      servers = {
        -- LazyVim's Python extra enables BasedPyright and Ruff.
        -- Jedi can resolve Django queryset results that BasedPyright cannot.
        pylsp = {
          before_init = function(_, config)
            config.settings = config.settings or {}
            config.settings.pylsp = config.settings.pylsp or {}
            config.settings.pylsp.plugins = config.settings.pylsp.plugins or {}
            config.settings.pylsp.plugins.jedi = {
              environment = require("config.python").interpreter(config.root_dir),
            }
          end,
          on_init = function(client)
            -- Use pylsp only for definitions; avoid duplicate completion/hover.
            for capability in pairs(client.server_capabilities) do
              if capability:match("Provider$") and capability ~= "definitionProvider" then
                client.server_capabilities[capability] = nil
              end
            end
          end,
          settings = {
            pylsp = {
              plugins = {
                pycodestyle = { enabled = false },
                pyflakes = { enabled = false },
                mccabe = { enabled = false },
                flake8 = { enabled = false },
                pylint = { enabled = false },
                pydocstyle = { enabled = false },
                autopep8 = { enabled = false },
                yapf = { enabled = false },
              },
            },
          },
        },
        ruff = {
          init_options = {
            settings = {
              lint = {
                -- Django models commonly declare mutable class attributes.
                ignore = { "RUF012" },
              },
            },
          },
        },
        basedpyright = {
          before_init = function(_, config)
            local python = require("config.python").interpreter(config.root_dir)
            config.settings = config.settings or {}
            config.settings.python = config.settings.python or {}
            -- Respect an explicitly configured interpreter (including VenvSelect).
            config.settings.python.pythonPath = config.settings.python.pythonPath or python
          end,
          settings = {
            basedpyright = {
              -- Ruff owns import cleanup; leave navigation/type analysis here.
              disableOrganizeImports = true,
              analysis = {
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "standard",
                -- Suppress diagnostics at the source so pickers stay quiet too.
                -- Analysis still powers completion, hover, and navigation.
                ignore = { "**" },
              },
            },
          },
        },
      },
    },
  },
}
