return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    {
      "Exafunction/codeium.nvim",
      cmd = "Codeium",
      build = ":Codeium Auth",
      opts = {
        -- tools = {
        --   language_server = vim.env.CODEIUM,
        -- },
      },
    },
  },
  event = { "InsertEnter" },
  config = function()
    local cmp = require("cmp")

    cmp.setup({
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      },
      ---@diagnostic disable-next-line missing-fields
      formatting = {
        format = function(entry, vim_item)
          if entry.source.name == "buffer" then
            vim_item.kind = "Buffer"
          end
          return vim_item
        end,
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-u>"] = cmp.mapping.scroll_docs(-3),
        ["<C-d>"] = cmp.mapping.scroll_docs(3),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-l>"] = cmp.mapping(function()
          if vim.snippet.jumpable(1) then
            vim.snippet.jump(1)
          end
        end, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(function()
          if vim.snippet.jumpable(-1) then
            vim.snippet.jump(-1)
          end
        end, { "i", "s" }),
      }),

      sources = cmp.config.sources({
        { name = "codeium" },
        { name = "nvim_lsp" },
        { name = "buffer" },
      }),
    })
  end,
}

-- local winhighlight = "Normal:Normal,FloatBorder:Comment,CursorLine:CursorLine,Search:None"
-- window = {
--   completion = cmp.config.window.bordered({
--     col_offset = -1,
--     winhighlight = winhighlight,
--   }),
--   documentation = cmp.config.window.bordered({
--     col_offset = -1,
--     winhighlight = winhighlight,
--   }),
-- },
