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
        -- Keep Jedi/pylsp from answering the same navigation requests.
        pylsp = { enabled = false },
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
