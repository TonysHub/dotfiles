return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    win = {
      layout = "classic",
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
