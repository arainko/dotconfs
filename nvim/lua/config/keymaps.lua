-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("n", "]t", "gt", { desc = "Next tab" })
map("n", "[t", "gT", { desc = "Previous tab" })

-- Ctrl+Z / Ctrl+Shift+Z: undo/redo without leaving insert mode
map("i", "<C-z>", "<C-o>u")
map("i", "<C-S-z>", "<C-o><C-r>")

--TODO: move the insert mode sig-help to use this instead of the blink one too?
map("n", "<C-p>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

map("n", "<leader>awf", vim.lsp.buf.add_workspace_folder)
-- map("n", "<leader>ul", function()
--   local enabled = vim.lsp.codelens.is_enabled()
--   vim.lsp.codelens.enable(not enabled)
--   vim.notify("CodeLens " .. (enabled and "disabled" or "enabled"))
-- end, { desc = "Toggle CodeLens" })

Snacks.toggle({
  name = "CodeLens",
  get = function()
    return vim.lsp.codelens.is_enabled()
  end,
  set = function(enabled)
    vim.lsp.codelens.enable(enabled)
  end,
}):map("<leader>ul")
