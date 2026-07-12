-- lua/plugins/blink.lua
return {
  "saghen/blink.cmp",
  opts = {
    completion = {
      accept = {
        auto_brackets = { enabled = false },
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
    },
    signature = { enabled = true },
    keymap = {
      ["<C-u>"] = { "scroll_signature_up", "fallback" },
      ["<C-d>"] = { "scroll_signature_down", "fallback" },

      -- default in all keymap presets
      ["<C-p>"] = { "show_signature", "hide_signature", "fallback" },
    },
  },
}
