-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- lua/config/autocmds.lua
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "scala", "sbt" },
  callback = function(args)
    local bufnr = args.buf
    local buf_root = vim.fn.expand("#" .. bufnr .. ":p:h")

    for _, client in ipairs(vim.lsp.get_clients({ name = "metals" })) do
      for _, folder in ipairs(client.workspace_folders or {}) do
        if buf_root:find(vim.pesc(folder.name), 1, true) == 1 then
          vim.lsp.buf_attach_client(bufnr, client.id)
          return
        end
      end
    end
  end,
})
