return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.python = function(bufnr)
        local info = require("conform").get_formatter_info("ruff_format", bufnr)
        if info and info.available then
          return { "isort", "ruff_format" }
        else
          return { "isort", "black" }
        end
      end
    end,
  },
}
