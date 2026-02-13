return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
  config = function()
    require("oil").setup({
      default_file_explorer = false,
      view_options = {
        show_hidden = true,
      },
    })
    vim.keymap.set("n", "-", "<cmd>Oil<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>-", require("oil").toggle_float, { noremap = true, silent = true })
  end,
}
