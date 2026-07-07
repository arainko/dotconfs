return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.sources.default = { "lsp", "path", "snippets" }
    return opts
  end,
}
