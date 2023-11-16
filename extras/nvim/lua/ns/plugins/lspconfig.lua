-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })

-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })

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

    vim.keymap.set("n", "g?", vim.lsp.buf.hover, opts)
    -- vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, opts)
    -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    -- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    -- vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
    -- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<Leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<Leader>cr", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<Leader>ca", vim.lsp.buf.code_action, opts)

    if client.supports_method("textDocument/formatting") then
      vim.keymap.set({ "n", "v" }, "<Leader>cf", vim.lsp.buf.format, opts)
    end
  end,
})

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "folke/neodev.nvim",
    "b0o/schemastore.nvim",
  },
  event = "VeryLazy",
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    require("neodev").setup({})

    require("lspconfig").lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace",
          },
          workspace = {
            checkThirdParty = false,
          },
        },
      },
    })

    require("lspconfig").tsserver.setup({
      capabilities = capabilities,
    })

    require("lspconfig").html.setup({
      capabilities = capabilities,
    })

    require("lspconfig").cssls.setup({
      capabilities = capabilities,
    })

    require("lspconfig").emmet_language_server.setup({
      capabilities = capabilities,
      -- filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" },
    })

    require("lspconfig").jsonls.setup({
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    })
  end,
}
