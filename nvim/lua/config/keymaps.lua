-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("n", "]t", "gt", { desc = "Next tab" })
map("n", "[t", "gT", { desc = "Previous tab" })

-- Ctrl+Z / Ctrl+Shift+Z: undo/redo without leaving insert mode
map("i", "<C-z>", "<C-o>u")
map("i", "<C-S-z>", "<C-o><C-r>")

-- Shift+Enter (IntelliJ "start new line" from anywhere in the current line)
map("i", "<S-CR>", "<End><CR>")

-- Ctrl+D: duplicate current line (IntelliJ-style), stay in insert mode
map("i", "<C-d>", "<C-o>yy<C-o>p")

-- Ctrl+/: toggle comment on current line from insert mode
map("i", "<C-/>", function()
  vim.cmd("normal gcc")
end)

--TODO: move the insert mode sig-help to use this instead of the blink one too?
map("n", "<C-p>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

map("x", "<C-/>", "gc", { desc = "Toggle comment (selection)", remap = true })
map("n", "<C-/>", "gcc", { desc = "Toggle comment", remap = true })

-- move line down/up, explanation:
-- <esc>
-- Drops out of insert mode into normal mode. This is necessary because :m (the move command) is an Ex command — it needs normal/command-line mode context to run, not insert mode.
-- <cmd>m .-2<cr>
-- This is the actual move. A couple of things worth unpacking:
--
-- <cmd>...<cr> is a special way of running a command silently without it interacting with the jump list or leaving artifacts in your command history the way a plain : would — it's the modern, cleaner way to embed an Ex command inside a keymap.
-- m is the :move command — it takes the current line (or a range) and relocates it to just after a target line.
-- .-2 is that target, expressed as a relative line reference: . means "the current line," so .-2 means "two lines above the current line."
map("i", "<C-S-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down" })
map("i", "<C-S-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up" })

-- Normal mode
map("n", "<C-S-Down>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Line Down" })
map("n", "<C-S-Up>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Line Up" })

-- Visual mode (move a whole selection block)
map("v", "<C-S-Down>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Selection Down" })
map("v", "<C-S-Up>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Selection Up" })

map("n", "<leader>awf", vim.lsp.buf.add_workspace_folder)

-- new workspace
map("n", "<leader>wn", function()
  local buf_dir = vim.fn.getcwd(-1)
  vim.ui.input({ prompt = "Open repo in new tab: ", default = buf_dir, completion = "dir" }, function(path)
    if not path or path == "" then
      return
    end
    local escaped_path = vim.fn.fnameescape(path)
    vim.lsp.buf.add_workspace_folder(escaped_path)

    vim.cmd("tabnew")
    vim.cmd("tcd " .. escaped_path)
  end)
end, { desc = "Open folder in new tab" })

local function get_tab_dirs()
  local dirs = {}
  for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
    local tabnr = vim.api.nvim_tabpage_get_number(tabpage)
    local dir = vim.fn.getcwd(-1, tabnr)
    if dir ~= "" and not vim.tbl_contains(dirs, dir) then
      table.insert(dirs, dir)
    end
  end
  return dirs
end

map("n", "<leader>wf", function()
  require("telescope.builtin").find_files({ search_dirs = get_tab_dirs() })
end, { desc = "Find Files (all open tabs)" })

map("n", "<leader>wg", function()
  require("telescope.builtin").live_grep({ search_dirs = get_tab_dirs() })
end, { desc = "Live Grep (all open tabs)" })
