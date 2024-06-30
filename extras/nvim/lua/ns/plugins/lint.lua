-- BUG
-- eslint_d: Could not parse linter output due to: Expected value but found invalid token at character 1
-- output: Error: No ESLint configuration found in <root>
local lint = "eslint"
local linters_by_ft = {
  javascript = { lint },
  javascriptreact = { lint },
  typescript = { lint },
  typescriptreact = { lint },
}
return {
  "mfussenegger/nvim-lint",
  ft = vim.tbl_keys(linters_by_ft),
  config = function()
    require("lint").linters_by_ft = linters_by_ft

    vim.api.nvim_create_autocmd({ "BufWritePost", "TextChanged" }, {
      group = vim.api.nvim_create_augroup("ns/lint_after_writed", {}),
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
