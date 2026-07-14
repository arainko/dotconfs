-- Open `jar:` URIs that Metals produces when you "go to implementation" into a
-- dependency's `-sources.jar` (e.g. `jar:file:/…/foo-sources.jar!/pkg/Foo.scala`).
--
-- Neovim has no reader for the `jar:` scheme, so opening such a buffer directly
-- fails (the URI is treated as a relative path -> ENOENT) or comes up empty.
-- Worse, even if we fill the buffer ourselves, Metals won't attach to a buffer
-- whose name is a `jar:` URI, so you lose hover / go-to inside the source.
--
-- Metals already extracts dependency sources to real files under
-- `<root>/.metals/readonly/dependencies/<jar>/<entry>`, and it attaches its LSP
-- to those normally. So we resolve the `jar:` URI to that real path (asking
-- Metals to decode + write it if it isn't extracted yet) and redirect the edit
-- there. The result is an ordinary on-disk file with full Metals LSP support.

local group = vim.api.nvim_create_augroup("jar_file_open", { clear = true })

--- Recover the raw `jar:` URI from a buffer name that `:edit` may have
--- cwd-prefixed (`/cwd/jar:file:/…` -> `jar:file:/…`).
local function recover_uri(name)
  return (name:gsub("^.-(jar:)", "%1"))
end

--- Map a jar URI to its on-disk `.metals/readonly` path.
--- `jar:file:<…>/<jarbase>.jar!/<entry>` -> `<root>/.metals/readonly/dependencies/<jarbase>.jar/<entry>`
local function readonly_path(root, uri)
  local before, entry = uri:match("^(.-)!/(.*)$")
  if not before then
    return nil
  end
  local jarbase = before:match("([^/]+)$")
  if not jarbase then
    return nil
  end
  return root .. "/.metals/readonly/dependencies/" .. jarbase .. "/" .. entry
end

vim.api.nvim_create_autocmd("BufReadCmd", {
  group = group,
  -- Match the scheme anywhere in the (possibly cwd-prefixed) buffer name.
  pattern = { "jar:*", "*/jar:*" },
  desc = "Redirect jar: URIs to their .metals/readonly file (with LSP)",
  callback = function(ev)
    local uri = recover_uri(ev.file)

    local client = vim.lsp.get_clients({ name = "metals" })[1]
    if not client then
      vim.notify("jar-open: no Metals client attached to resolve " .. uri, vim.log.levels.ERROR)
      return
    end

    local root = client.config.root_dir or vim.fn.getcwd()
    local target = readonly_path(root, uri)
    if not target then
      vim.notify("jar-open: could not parse " .. uri, vim.log.levels.ERROR)
      return
    end

    -- Extract on demand if Metals hasn't written this source yet.
    if vim.fn.filereadable(target) == 0 then
      local resp = client:request_sync(
        "workspace/executeCommand",
        { command = "metals.file-decode", arguments = { "metalsDecode:" .. uri } },
        10000,
        ev.buf
      )
      local result = resp and resp.result
      if not result or not result.value or result.error then
        local reason = (result and result.error) or (resp and resp.err and resp.err.message) or "request failed"
        vim.notify("jar-open: Metals could not decode " .. uri .. "\n" .. tostring(reason), vim.log.levels.ERROR)
        return
      end
      vim.fn.mkdir(vim.fn.fnamemodify(target, ":h"), "p")
      local f, err = io.open(target, "w")
      if not f then
        vim.notify("jar-open: cannot write " .. target .. "\n" .. tostring(err), vim.log.levels.ERROR)
        return
      end
      f:write(result.value)
      f:close()
    end

    -- Redirect this edit to the real file. Do it *outside* the BufReadCmd via
    -- vim.schedule so the normal FileType autocmd fires -- that's what triggers
    -- Metals' initialize_or_attach, giving the source full LSP support.
    local jar_buf = ev.buf
    vim.schedule(function()
      vim.cmd("keepalt edit " .. vim.fn.fnameescape(target))
      if vim.api.nvim_buf_is_valid(jar_buf) and jar_buf ~= vim.api.nvim_get_current_buf() then
        pcall(vim.api.nvim_buf_delete, jar_buf, { force = true })
      end
    end)
  end,
})
