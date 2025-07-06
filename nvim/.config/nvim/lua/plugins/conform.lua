return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      -- Add a custom formatter for Swift (previously swiftformat)
      opts.formatters = vim.tbl_extend("force", opts.formatters or {}, {
        swift = {
          command = "swift-format",
          args = function()
            return { "format", "--in-place", "$FILENAME" }
          end,
          stdin = false,
          tempfile_postfix = ".swift",
        },
      })

      -- Extend the formatters_by_ft table with swift for Swift files
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
        swift = { "swift" },
      })

      return opts
    end,
  },
}
