-- return {
--   "nvim-treesitter/nvim-treesitter",
--   version = false, -- last release is way too old and doesn't work on Windows
--   build = ":TSUpdate",
--   event = { "LazyFile", "VeryLazy" },
--   lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
--   init = function(plugin)
--     -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
--     -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
--     -- no longer trigger the **nvim-treesitter** module to be loaded in time.
--     -- Luckily, the only things that those plugins need are the custom queries, which we make available
--     -- during startup.
--     require("lazy.core.loader").add_to_rtp(plugin)
--     require("nvim-treesitter.query_predicates")
--   end,
--   cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
--   keys = {
--     { "<c-space>", desc = "Increment Selection" },
--     { "<bs>", desc = "Decrement Selection", mode = "x" },
--   },
--   opts_extend = { "ensure_installed" },
--   ---@type TSConfig
--   ---@diagnostic disable-next-line: missing-fields
--   opts = {
--     highlight = { enable = true },
--     indent = { enable = true },
--     ensure_installed = {
--       "bash",
--       "c",
--       "diff",
--       "graphql",
--       "html",
--       "http",
--       "javascript",
--       "jsdoc",
--       "json",
--       "jsonc",
--       "lua",
--       "luadoc",
--       "luap",
--       "markdown",
--       "markdown_inline",
--       "printf",
--       "python",
--       "query",
--       "regex",
--       "swift",
--       "toml",
--       "tsx",
--       "typescript",
--       "vim",
--       "vimdoc",
--       "xml",
--       "yaml",
--     },
--     incremental_selection = {
--       enable = true,
--       keymaps = {
--         init_selection = "<C-space>",
--         node_incremental = "<C-space>",
--         scope_incremental = false,
--         node_decremental = "<bs>",
--       },
--     },
--     textobjects = {
--       move = {
--         enable = true,
--         goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
--         goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
--         goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
--         goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
--       },
--     },
--   },
--   ---@param opts TSConfig
--   config = function(_, opts)
--     if type(opts.ensure_installed) == "table" then
--       opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)
--     end
--     require("nvim-treesitter.configs").setup(opts)
--   end,
-- }

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master", -- use the stable branch; fine for parser files
  lazy = false, -- load eagerly
  build = ":TSUpdate",

  config = function()
    -- Make sure the plugin module exists
    local ok, _ = pcall(require, "nvim-treesitter")
    if not ok then
      vim.notify("nvim-treesitter not found", vim.log.levels.ERROR)
      return
    end

    -- 1) Auto-attach Treesitter to every buffer where a parser exists
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
      group = vim.api.nvim_create_augroup("ts_auto_attach", { clear = true }),
      callback = function(args)
        local buf = args.buf
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end

        local ft = vim.bo[buf].filetype
        if not ft or ft == "" then
          return
        end

        -- Try to map filetype -> TS language (e.g. typescriptreact -> tsx)
        local ok_lang, lang = pcall(vim.treesitter.language.get_lang, ft)
        if not ok_lang or not lang then
          -- fallback: try using the filetype directly
          lang = ft
        end

        -- Silently try to start TS for this buffer
        pcall(vim.treesitter.start, buf, lang)
      end,
    })

    -- 2) Helper: check if TS is attached to the current buffer
    vim.api.nvim_create_user_command("TSCurrentLang", function()
      local hi = require("vim.treesitter.highlighter").active[vim.api.nvim_get_current_buf()]
      if hi and hi.tree then
        print("Treesitter lang:", hi.tree:lang())
      else
        print("Treesitter not active for this buffer")
      end
    end, {})
  end,
}
