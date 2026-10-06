return {
  {
    "scalameta/nvim-metals",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    opts = function()
      local metals_config = require("metals").bare_config()

      -- Ref: https://github.com/scalameta/metals/blob/a1a789a6f4921dd363d7bb0cb58f2a48aed241fb/metals/src/main/scala/scala/meta/internal/metals/UserConfiguration.scala#L30
      metals_config.settings = {
        showImplicitArguments = false,
        showImplicitConversionsAndClasses = false,
        showInferredType = false,
        defaultBspToBuildTool = true,
        startMcpServer = false,
        -- mcpClient = "claude"
      }

      metals_config.on_attach = function(client, bufnr)
        require("metals").setup_dap()
      end

      return metals_config
    end,
    keys = {
      {
        "<leader>mia",
        function()
          require("metals").toggle_setting("showImplicitArguments")
        end,
        desc = "Toggle implicit arguments",
      },
      {
        "<leader>mic",
        function()
          require("metals").toggle_setting("showImplicitConversionsAndClasses")
        end,
        desc = "Toggle implicit conversions and classes",
      },
      {
        "<leader>mti",
        function()
          require("metals").toggle_setting("showInferredType")
        end,
        desc = "Toggle inferred types",
      },

    },
  },
  {
    "rcarriga/nvim-dap-ui",
    -- added to disable some annoying ass behavior like jumping UI when running the 'run' codelens
    config = function(_, opts)
      require("dapui").setup(opts)
    end,
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      dap.configurations.scala = {
        {
          type = "scala",
          request = "launch",
          name = "Run or test with input",
          metals = {
            runType = "runOrTestFile",
            args = function()
              local args_string = vim.fn.input("Arguments: ")
              return vim.split(args_string, " +")
            end,
          },
        },
        {
          type = "scala",
          request = "launch",
          name = "Run or Test",
          metals = {
            runType = "runOrTestFile",
          },
        },
        {
          type = "scala",
          request = "launch",
          name = "Test Target",
          metals = {
            runType = "testTarget",
          },
        },
      }
    end,
  },
}
