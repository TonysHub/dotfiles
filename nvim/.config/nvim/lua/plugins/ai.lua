return {
  {
    "folke/sidekick.nvim",
    cmd = "Sidekick",
    opts = {
      -- CLI integration only; preserve existing Copilot/completion and Tab keys.
      nes = { enabled = false },
      cli = {
        mux = { enabled = true, backend = "tmux" },
        tools = {
          codex = { cmd = { "codex", "--no-alt-screen" } },
        },
      },
    },
    -- Commands add AI access without taking over any existing key bindings.
    init = function()
      for _, name in ipairs({ "claude", "codex" }) do
        vim.api.nvim_create_user_command(name == "claude" and "Claude" or "Codex", function()
          require("sidekick.cli").toggle({ name = name, focus = true })
        end, { desc = "Toggle " .. name .. " CLI" })
      end
    end,
  },
}
