return {
  {
    "scalameta/nvim-metals",
    opts = {
      settings = {
        showImplicitArguments = false,
        showImplicitConversionsAndClasses = false,
        showInferredType = false,
      },
    },
    keys = {
      {
        "<leader>mi",
        function()
          require("metals").toggle_setting("showImplicitArguments")
        end,
        desc = "Toggle implicit arguments",
      },
    },
  },
}
