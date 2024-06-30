return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {},
    },
    "b0o/schemastore.nvim",
  },
  event = "VeryLazy",
  config = function()
    local server_settings = {
      vtsls = {},
      volar = {},
      lua_ls = {
        Lua = {
          completion = {
            callSnippet = "Replace",
          },
          workspace = {
            checkThirdParty = false,
          },
        },
      },
      tailwindcss = {},
      emmet_language_server = {},
      -- prismals = {},
      html = {},
      cssls = {},
      jsonls = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
      marksman = {},
    }

    local capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      require("cmp_nvim_lsp").default_capabilities()
    )

    local lspconfig = require("lspconfig")

    for server, settings in pairs(server_settings) do
      lspconfig[server].setup({
        capabilities = capabilities,
        settings = settings,
      })
    end
  end,
}
