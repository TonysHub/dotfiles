return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- disable pyright
        pyright = false,

        -- enable python lsp server
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                -- formatting
                mccabe = { enabled = true, threshold = 20 },
                black = { enabled = false },
                autopep8 = { enabled = false },
                yapf = { enabled = false },

                -- linting
                pycodestyle = { enabled = true, ignore = { "E501", "W503" } },
                flake8 = { enabled = true, ignore = { "E501", "W503" } },
                pylint = { enabled = false },
                pyflakes = { enabled = false },
              },
            },
          },
        },
      },
    },
  },
}
