local with_prettier = { { "prettierd", "prettier" } }

local formatters_by_ft = {
  lua = { "stylua" },
  javascript = with_prettier,
  javascriptreact = with_prettier,
  typescript = with_prettier,
  typescriptreact = with_prettier,
  html = with_prettier,
  css = with_prettier,
  json = with_prettier,
  markdown = with_prettier,
}

return {
  "stevearc/conform.nvim",
  ft = vim.tbl_keys(formatters_by_ft),
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
  keys = {
    {
      "<Leader>cf",
      function()
        require("conform").format()
      end,
    },
  },
  opts = {
    formatters_by_ft = formatters_by_ft,
    -- format_on_save = {
    --   timeout_ms = 1000,
    -- lsp_format = "fallback",
    -- },
  },
}
