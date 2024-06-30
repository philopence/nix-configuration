return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    {
      "garymjr/nvim-snippets",
      opts = {
        extended_filetypes = {
          typescriptreact = { "typescript" },
        },
      },
    },
    {
      "Exafunction/codeium.nvim",
      cmd = "Codeium",
      build = ":Codeium Auth",
      opts = {},
    },
  },
  event = { "InsertEnter" },
  config = function()
    local cmp = require("cmp")

    -- local border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }
    local window_border = cmp.config.window.bordered({
      border = "single",
      col_offset = -1,
      winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:IncSearch,Search:None",
      scrollbar = true,
    })

    cmp.setup({
      -- experimental = { ghost_text = true },

      -- NOTE: https://github.com/hrsh7th/nvim-cmp/issues/1809
      -- preselect = cmp.PreselectMode.None,

      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      },

      formatting = {
        expandable_indicator = true,
        fields = { "abbr", "kind", "menu" },
        format = function(entry, vim_item)
          local MAX_ABBR_WIDTH = 30

          if entry.source.name == "buffer" then
            vim_item.kind = "Buffer"
          end

          if vim.api.nvim_strwidth(vim_item.abbr) > MAX_ABBR_WIDTH then
            vim_item.abbr = vim.fn.strcharpart(vim_item.abbr, 0, MAX_ABBR_WIDTH) .. "…"
          end

          -- vim_item.kind = string.format("%s %s", kinds[vim_item.kind], vim_item.kind)
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
        ["<C-j>"] = cmp.mapping(function()
          if vim.snippet.active({ direction = 1 }) then
            vim.snippet.jump(1)
          end
        end, { "i", "s" }),
        ["<C-k>"] = cmp.mapping(function()
          if vim.snippet.active({ direction = -1 }) then
            vim.snippet.jump(-1)
          end
        end, { "i", "s" }),
        -- !!! WARNNING !!!
        ["<C-x>"] = cmp.mapping(
          cmp.mapping.complete({
            config = {
              sources = cmp.config.sources({
                { name = "codeium" },
              }),
            },
          }),
          { "i" }
        ),
      }),

      window = {
        completion = window_border,
        documentation = window_border,
      },

      sources = cmp.config.sources({
        { name = "snippets" },
        { name = "nvim_lsp" },
      }, {
        { name = "buffer", keyword_length = 3 },
      }),
    })

    -- set global highlight
    vim.api.nvim_set_hl(0, "CmpItemKindCodeium", { link = "CmpItemKindCopilot" })
    vim.api.nvim_set_hl(0, "CmpItemKindBuffer", { link = "CmpItemKindText" })
  end,
}
