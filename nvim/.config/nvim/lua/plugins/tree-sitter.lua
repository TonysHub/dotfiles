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
  branch = "main",
  lazy = false, -- load eagerly; this avoids rtp / timing weirdness
  build = ":TSUpdate",

  config = function()
    -- List of languages / filetypes you care about
    local parsers = {
      "bash",
      "c",
      "diff",
      "graphql",
      "html",
      "http",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "printf",
      "python",
      "query",
      "regex",
      "swift",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    }

    local ts = require("nvim-treesitter")

    -- 1) Initialize nvim-treesitter (main-branch API)
    ts.setup()

    -- 2) Ensure parsers are installed / updated (async-ish, with timeout)
    vim.defer_fn(function()
      ts.install(parsers):wait(300000) -- up to 5 minutes, returns early when done
    end, 0)

    -- 3) Attach Treesitter when opening files of those types
    vim.api.nvim_create_autocmd("FileType", {
      pattern = parsers,
      callback = function()
        -- No args: use current buffer + its filetype → correct parser
        vim.treesitter.start()
      end,
    })

    -- (Optional) Tiny helper to debug whether TS is attached
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
