local linters_by_ft = {
  javascript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescript = { "eslint_d" },
  typescriptreact = { "eslint_d" },
}
return {
  "mfussenegger/nvim-lint",
  ft = vim.tbl_keys(linters_by_ft),
  config = function()
    require("lint").linters_by_ft = linters_by_ft

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      group = vim.api.nvim_create_augroup("ns/lint_after_writed", {}),
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
