-- DONE https://github.com/hrsh7th/nvim-cmp/pull/1734

local winhighlight = "Normal:Normal,FloatBorder:Comment,CursorLine:CursorLine,Search:None"

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
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
      window = {
        completion = cmp.config.window.bordered({
          col_offset = -1,
          winhighlight = winhighlight,
        }),
        documentation = cmp.config.window.bordered({
          col_offset = -1,
          winhighlight = winhighlight,
        }),
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
        ["<C-u>"] = cmp.mapping.scroll_docs(-1),
        ["<C-d>"] = cmp.mapping.scroll_docs(1),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif vim.snippet.jumpable(1) then
            vim.snippet.jump(1)
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.jumpable(-1) then
            vim.snippet.jump(-1)
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" },
      }),
    })
  end,
}
