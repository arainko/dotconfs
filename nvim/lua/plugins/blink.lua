-- lua/plugins/blink.lua
return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
      accept = {
        auto_brackets = { enabled = false },
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
    })

    opts.signature = vim.tbl_deep_extend("force", opts.signature or {}, {
      enabled = true,
      trigger = {
        show_on_trigger_character = false,
        show_on_insert_on_trigger_character = false,
        show_on_insert = false,
      },
    })

    opts.keymap = vim.tbl_deep_extend("force", opts.keymap or {}, {
      ["<C-u>"] = { "scroll_signature_up", "fallback" },
      ["<C-d>"] = { "scroll_signature_down", "fallback" },

      -- default in all keymap presets
      ["<C-p>"] = { "show_signature", "hide_signature", "fallback" },
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
    })

    opts.sources.default = { "lsp", "path" }

    return opts
  end,
}
