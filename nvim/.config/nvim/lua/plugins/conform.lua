return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      -- Add a custom formatter for Swift (previously swiftformat)
      opts.formatters = vim.tbl_extend("force", opts.formatters or {}, {
        swift = {
          command = "swift-format",
          args = function()
            local args = { "format", "--in-place", "$FILENAME" }
            local project_config = vim.fn.getcwd() .. "/.swift-format"
            local user_config = os.getenv("HOME") .. "/.config/.swift-format"

            if vim.fn.filereadable(project_config) == 1 then
              return args
            elseif vim.fn.filereadable(user_config) == 1 then
              table.insert(args, "--configuration")
              table.insert(args, user_config)
            end

            return args
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
