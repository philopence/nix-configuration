return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  -- enable = false,
  -- lazy = false,
  dependencies = {
    { "antosha417/nvim-lsp-file-operations", opts = {} },
  },
  keys = {
    { "<C-e>", "<Cmd>NvimTreeToggle<CR>" },
    { "<Leader>tf", "<Cmd>NvimTreeFindFile<CR>" },
  },
  opts = function()
    local function on_attach(bufnr)
      local api = require("nvim-tree.api")

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      vim.keymap.del("n", "<C-k>", opts(""))
      vim.keymap.del("n", "<C-e>", opts(""))
    end
    return {
      on_attach = on_attach,
      git = { enable = false },
      renderer = {
        root_folder_label = ":t:s?$?/..?",
        icons = {
          -- padding = "  ",
          -- show = {
          --   folder = false,
          --   file = false,
          -- },
          glyphs = {
            folder = {
              arrow_closed = "",
              arrow_open = "",
            },
          },
        },
      },
      actions = { open_file = { quit_on_open = true } },
    }
  end,
}
