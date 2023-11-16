local M = {}

M.setup = function()
  require("ns.rc").setup()
  require("ns.lazy").setup()

  vim.cmd.colorscheme("catppuccin-mocha")
  -- vim.cmd.colorscheme("kanagawa-dragon")
end
return M
