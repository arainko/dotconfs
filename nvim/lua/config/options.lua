-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Register the `jar:` BufReadCmd early so it's in place before any jar buffer
-- (e.g. Metals "go to implementation" into dependency sources) is opened.
require("config.jar-open")
