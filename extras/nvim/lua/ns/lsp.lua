local M = {}

local methods = vim.lsp.protocol.Methods

vim.lsp.handlers[methods.textDocument_hover] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })

vim.lsp.handlers[methods.textDocument_signatureHelp] =
  vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })

function M.setup()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("ns/lsp", {}),
    callback = function(ev)
      -- :help lsp-defaults

      local client = vim.lsp.get_client_by_id(ev.data.client_id)

      assert(client, "lsp client not found")

      local opts = { buffer = ev.buf }


      vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts)

      vim.keymap.set({ "n" }, "<Leader>cr", vim.lsp.buf.rename, opts)
      vim.keymap.set({ "n", "x" }, "<Leader>ca", vim.lsp.buf.code_action, opts)
    end,
  })
end

return M
