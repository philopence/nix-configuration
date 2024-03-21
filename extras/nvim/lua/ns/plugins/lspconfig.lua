vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local opts = { buffer = ev.buf }

    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<Leader>cr", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "x" }, "<Leader>ca", vim.lsp.buf.code_action, opts)
  end,
})

local methods = vim.lsp.protocol.Methods

vim.lsp.handlers[methods.textDocument_hover] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "folke/neodev.nvim", opts = {} },
    "b0o/schemastore.nvim",
    {
      "pmizio/typescript-tools.nvim",
      opts = {
        settings = {
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all",
            includeInlayVariableTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
          },
        },
      },
    },
  },
  event = "VeryLazy",
  config = function()
    local capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      require("cmp_nvim_lsp").default_capabilities()
    )

    local server_settings = {
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
      prismals = {},
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

    local lspconfig = require("lspconfig")

    for server, settings in pairs(server_settings) do
      lspconfig[server].setup({
        capabilities = capabilities,
        settings = settings,
      })
    end
  end,
}
