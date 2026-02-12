return {
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.lsp = opts.lsp or {}
      opts.lsp.progress = { enabled = false }
      opts.notify = { enabled = false }
      opts.messages = { enabled = true }
      opts.cmdline = { enabled = true }
      opts.popupmenu = { enabled = true }
      opts.lsp.signature = { enabled = false }
      opts.lsp.hover = { enabled = false }
    end,
  },
}
