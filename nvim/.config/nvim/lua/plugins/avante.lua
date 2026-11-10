return {
  {
    "avante-corp/avante.nvim",
    tag = "v0.5.0",
    build = function(plugin)
      -- Use upstream's release libraries; no local Rust toolchain is needed.
      local version = dofile(plugin.dir .. "/lua/avante/version.lua")
      local result = vim.system({ "bash", plugin.dir .. "/build.sh", version }, { text = true }):wait()
      assert(result.code == 0, result.stderr)
      if vim.fn.has("mac") == 1 then
        -- v0.5.0's macOS artifacts reference the CI Nix store's libiconv.
        -- The same ABI is supplied by macOS's dyld shared cache.
        for _, lib in ipairs(vim.fn.glob(plugin.dir .. "/lua/avante_*.so", false, true)) do
          local linked = vim.system({ "otool", "-L", lib }, { text = true }):wait()
          assert(linked.code == 0, linked.stderr)
          local iconv = linked.stdout:match("(/nix/store/[^%s]+/lib/libiconv%.2%.dylib)")
          if iconv then
            local fixed = vim
              .system({ "install_name_tool", "-change", iconv, "/usr/lib/libiconv.2.dylib", lib }, { text = true })
              :wait()
            assert(fixed.code == 0, fixed.stderr)
            local signed = vim.system({ "codesign", "--force", "--sign", "-", lib }, { text = true }):wait()
            assert(signed.code == 0, signed.stderr)
          end
        end
      end
    end,
    cmd = {
      "Avante",
      "AvanteAsk",
      "AvanteChat",
      "AvanteChatNew",
      "AvanteEdit",
      "AvanteToggle",
      "AvanteFocus",
      "AvanteStop",
      "AvanteSwitchProvider",
      "AvanteModels",
      "AvanteHistory",
      "AvanteClear",
      "AvanteBuild",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      { "ColinKennedy/mega.cmdparse", dependencies = { "ColinKennedy/mega.logging" } },
    },
    opts = function()
      local bin = vim.fn.stdpath("config") .. "/ai/node_modules/.bin/"
      return {
        provider = "claude-code",
        behaviour = {
          auto_set_keymaps = false,
          auto_suggestions = false,
          auto_approve_tool_permissions = false,
        },
        selection = { hint_display = "none" },
        acp_providers = {
          ["claude-code"] = {
            command = bin .. "claude-agent-acp",
            -- Keep the adapter's normal permission checks.
            env = { ACP_PERMISSION_MODE = "default" },
          },
          codex = { command = bin .. "codex-acp" },
        },
      }
    end,
  },
}
