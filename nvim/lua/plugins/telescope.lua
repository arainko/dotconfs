return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      path_display = { "smart" },
    },
    pickers = {
      live_grep = { additional_args = { "--follow" } },
      grep_string = { additional_args = { "--follow" } },
    },
  },
}
