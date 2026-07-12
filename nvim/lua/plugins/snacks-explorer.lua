return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          actions = {
            -- takne from: https://github.com/folke/snacks.nvim/discussions/1707#discussioncomment-12775199
            recursive_toggle = function(picker, item)
              local Actions = require("snacks.explorer.actions")
              local Tree = require("snacks.explorer.tree")

              local get_children = function(node)
                local children = {}
                for _, child in pairs(node.children) do
                  table.insert(children, child)
                end
                return children
              end

              local refresh = function()
                Actions.update(picker, { refresh = true })
              end

              ---@param node snacks.picker.explorer.Node
              local function toggle_recursive(node)
                Tree:toggle(node.path)
                refresh()
                vim.schedule(function()
                  local children = get_children(node)
                  if #children ~= 1 then
                    return
                  end
                  local child = children[1]
                  if not child.dir then
                    return
                  end
                  toggle_recursive(child)
                end)
              end

              --

              local node = Tree:node(item.file)
              if not node then
                return
              end

              if node.dir then
                toggle_recursive(node)
              else
                picker:action("confirm")
              end
            end,
          },
          win = {
            list = {
              keys = {
                ["<CR>"] = "recursive_toggle",
              },
            },
          },
        },
      },
    },
  },

  keys = {
    -- taken from: https://github.com/folke/snacks.nvim/discussions/2607#discussioncomment-15211964
    {
      "\\",
      function()
        local explorer = Snacks.picker.get({ source = "explorer" })[1]
        local opts = { cwd = LazyVim.root() }
        if explorer == nil then
          Snacks.picker.explorer(opts)
        elseif explorer:is_focused() then
          Snacks.picker.explorer(opts)
        else
          explorer:focus()
        end
      end,
      desc = "Toggle Explorer",
    },
  },
}
