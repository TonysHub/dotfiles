return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- One autocmd for all buffers
      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function(args)
          local bufnr = args.buf

          -- Only if at least one LSP client is attached and supports code actions
          local clients = vim.lsp.get_clients({ bufnr = bufnr })
          if #clients == 0 then
            return
          end

          local has_code_action = false
          for _, c in ipairs(clients) do
            if c.supports_method("textDocument/codeAction") then
              has_code_action = true
              break
            end
          end
          if not has_code_action then
            return
          end

          -- Request & apply "organize imports" if supported
          vim.lsp.buf.code_action({
            apply = true,
            context = { only = { "source.organizeImports" } },
          })
        end,
      })

      return opts
    end,
  },
}
