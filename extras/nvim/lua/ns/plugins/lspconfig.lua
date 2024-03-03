vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    assert(client ~= nil)

    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }

    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<Leader>cr", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "x" }, "<Leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "S", vim.lsp.buf.signature_help, opts)

    if client.supports_method("textDocument/formatting") then
      vim.keymap.set({ "n", "x" }, "<Leader>cf", vim.lsp.buf.format, opts)
    end
  end,
})

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "folke/neodev.nvim", opts = {} },
    "b0o/schemastore.nvim",
  },
  event = "VeryLazy",
  config = function()
    -- local capabilities = require("cmp_nvim_lsp").default_capabilities()
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
      eslint = {},
      tsserver = {},
      html = {},
      cssls = {},
      jsonls = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
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
