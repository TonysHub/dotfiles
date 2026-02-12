return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = opts.keymap or {}
      opts.keymap.preset = "default"

      -- next/prev
      opts.keymap["<C-j>"] = { "select_next", "fallback" }
      opts.keymap["<C-k>"] = { "select_prev", "fallback" }

      -- docs scroll (correct blink commands)
      opts.keymap["<C-d>"] = { "scroll_documentation_up", "fallback" }
      opts.keymap["<C-f>"] = { "scroll_documentation_down", "fallback" }

      -- open completion + confirm
      opts.keymap["<C-Space>"] = { "show", "fallback" }
      opts.keymap["<C-y>"] = { "select_and_accept", "fallback" }

      -- disable tab / shift-tab from the preset
      opts.keymap["<Tab>"] = false
      opts.keymap["<S-Tab>"] = false

      opts.completion = opts.completion or {}
      opts.completion.trigger = {
        show_on_keyword = true,
      }

      opts.completion.list = {
        selection = { preselect = false },
      }
      opts.completion.accept = {
        auto_brackets = { enabled = false },
      }

      opts.completion.menu = {
        auto_show = true,
      }
      opts.completion.documentation = {
        auto_show = false,
      }

      -- Lower debounce (important)
      opts.completion.keyword = {
        range = "prefix",
      }
      opts.completion.trigger = {
        show_on_trigger_character = true,
      }

      -- This controls delay
      opts.completion.debounce = 50
    end,
  },
}
