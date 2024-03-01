local M = {}

M.setup = function()
  require("ns.rc").setup()
  require("ns.lazy").setup()

  vim.cmd.colorscheme("tokyonight-night")
  -- vim.cmd.colorscheme("catppuccin-mocha")
  --
end
return M
