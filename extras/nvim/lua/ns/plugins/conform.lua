local formatters_by_ft = {
  lua = { "stylua" },
  nix = { "nixpkgs_fmt" },
  javascript = { { "prettierd", "prettier" } },
  javascriptreact = { { "prettierd", "prettierd" } },
  typescript = { { "prettierd", "prettier" } },
  typescriptreact = { { "prettierd", "prettier" } },
  html = { { "prettierd", "prettier" } },
  css = { { "prettierd", "prettier" } },
  json = { { "prettierd", "prettier" } },
  markdown = { { "prettierd", "prettier" } },
  ["_"] = { "trim_whitespace" },
}

return {
  "stevearc/conform.nvim",
  ft = vim.tbl_keys(formatters_by_ft),
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
  opts = {
    formatters_by_ft = formatters_by_ft,
  },
}
