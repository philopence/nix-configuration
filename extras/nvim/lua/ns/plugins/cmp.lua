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
        enable_chat = true,
        -- tools = {
        --   language_server = vim.env.CODEIUM,
        -- },
      },
    },
  },
  event = { "InsertEnter" },
  config = function()
    local cmp = require("cmp")

    local window_border = cmp.config.window.bordered({
      border = "rounded",
      col_offset = -1,
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:IncSearch,Search:None",
      scrollbar = false,
    })

    cmp.setup({
      -- experimental = { ghost_text = true },
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
          if entry.source.name == "codeium" then
            vim.print(vim_item)
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

      window = {
        completion = window_border,
        documentation = window_border,
      },

      sources = cmp.config.sources({
        { name = "codeium" },
        { name = "nvim_lsp" },
      }, {
        { name = "buffer", keyword_length = 3 },
      }),
    })

    -- set global highlight
    vim.api.nvim_set_hl(0, "CmpItemKindCodeium", { link = "CmpItemKindCopilot" })
  end,
}
