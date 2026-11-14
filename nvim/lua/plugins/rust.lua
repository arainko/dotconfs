--  ref: https://rust-analyzer.github.io/book/configuration.html?highlight=inlay%20hints#configuration
return {
  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            inlayHints = {
              -- typeHints = { enable = false },
              -- parameterHints = { enable = false },
              -- chainingHints = { enable = false },
              -- closingBraceHints = { enable = false },
              -- bindingModeHints = { enable = false },
              -- lifetimeElisionHints = { enable = "never" },
              -- closureReturnTypeHints = { enable = "never" },
              -- discriminantHints = { enable = "never" },
            },
          },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { exclude = { "rust" } },
    },
  },
}
