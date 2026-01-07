return {
  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require("notify")
      notify.setup({
        fps = 120,
        render = "minimal",
        timeout = 500,
      })

      -- Make nvim-notify the global notifier
      vim.notify = notify
    end,
  },

  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        -- 👇 turn off Noice's own notify override
        notify = {
          enabled = false,
        },

        cmdline = {
          format = {
            bash = {
              kind = "bash",
              pattern = "^:!",
              icon = "$",
              lang = "bash",
            },
            search_and_replace = {
              kind = "replace",
              pattern = "^:%%?s/",
              icon = " ",
              lang = "regex",
            },
            search_and_replace_range = {
              kind = "replace",
              pattern = "^:'<,'>%%?s/",
              icon = " ",
              lang = "regex",
            },
          },
        },

        lsp = {
          enabled = true,
          progress = {
            enabled = false,
          },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          icons_enabled = true,
        },

        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        },

        throttle = 1000 / 120,

        routes = {
          {
            filter = {
              event = "msg_show",
              kind = "",
              find = "more line",
            },
            opts = { skip = true },
          },
        },

        views = {
          cmdline_popup = {
            position = { row = vim.o.lines * 0.32, col = "50%" },
            size = { width = 60, height = "auto" },
          },
          popupmenu = {
            position = { row = vim.o.lines * 0.32 + 3, col = "50%" },
            size = { width = 60, height = 10 },
            border = { style = "rounded", padding = { 0, 1 } },
            win_options = {
              winhighlight = {
                Normal = "Normal",
              },
            },
          },
        },
      })
    end,
  },
}
