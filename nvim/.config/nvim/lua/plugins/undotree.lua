return {
  "mbbill/undotree",
  dependencies = "nvim-lua/plenary.nvim",
  config = true,
  keys = {
    { "<leader>uu", "<cmd>UndotreeToggle<cr>", { desc = "Toggle undotree" } },
  },
}
