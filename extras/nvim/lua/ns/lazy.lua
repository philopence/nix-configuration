local M = {}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

M.setup = function()
  require("lazy").setup("ns.plugins", {
    defaults = {
      lazy = true,
    },
    install = {
      colorscheme = { "catppuccin-mocha" },
    },
    change_detection = {
      notify = false,
    },
  })
end

return M
