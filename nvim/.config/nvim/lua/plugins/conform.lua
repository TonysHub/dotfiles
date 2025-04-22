return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      -- Add a custom formatter for Swift-Format
      opts.formatters = vim.tbl_extend("force", opts.formatters or {}, {
        swiftformat = {
          command = "swiftformat",
          args = function()
            local cwd = vim.fn.getcwd()
            local config_file = cwd .. "/.swiftformat"
            if vim.fn.filereadable(config_file) == 1 then
              return { "--config", config_file, "$FILENAME" }
            else
              return { "$FILENAME" } -- Use default swiftformat options if no config file is found
            end
          end,
          stdin = false,
          tempfile_postfix = ".swift", -- Ensure temporary files have the correct extension
        },
      })

      -- Extend the formatters_by_ft table with swift-format for Swift files
      opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, {
        lua = { "stylua" },
        python = function(bufnr)
          if require("conform").get_formatter_info("ruff_format", bufnr).available then
            return { "isort", "ruff_format" }
          else
            return { "isort", "black" }
          end
        end,
        go = { "gofumpt" },
        elixir = { "mix" },
        -- javascript = { { "prettierd", "prettier" } },
        -- typescript = { "prettier" },
        -- javascriptreact = { "prettier" },
        -- typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        swift = { "swiftformat" },
      })

      return opts
    end,
  },
}
