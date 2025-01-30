return {
  -- Main vim-dadbod plugin
  {
    "tpope/vim-dadbod",
    lazy = true,
    cmd = { "DB", "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
  },

  -- UI for vim-dadbod
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = { "tpope/vim-dadbod" },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  -- Completion for SQL queries
  {
    "kristijanhusak/vim-dadbod-completion",
    dependencies = { "tpope/vim-dadbod" },
    ft = { "sql", "mysql", "plsql" },
  },
}
