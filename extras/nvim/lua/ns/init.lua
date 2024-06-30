local M = {}

function M.setup()
  require("ns.rc").setup()
  require("ns.lsp").setup()
  require("ns.lazy").setup()

  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function(ev)
      if ev.match == "default" then
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = "NvimDarkGrey3" })
        vim.api.nvim_set_hl(0, "FloatBorder", { fg = "NvimLightGrey4" })
        vim.api.nvim_set_hl(0, "SnippetTabstop", { link = "NONE" })
        vim.api.nvim_set_hl(0, "TelescopeBorder", { link = "FloatBorder" })
        -- patch_hl("IblIndent", { fg = "NvimDarkGrey3" })
        vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "NvimLightYellow", bold = true })
      end

      if ev.match == "gruvbox-material" then
        vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "#1d2021" })
        vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { link = "NvimTreeNormal" })
      end
    end,
  })

  vim.cmd.colorscheme("tokyonight-night")

  vim.filetype.add({
    extension = {
      ["http"] = "http",
    },
  })
end
return M
