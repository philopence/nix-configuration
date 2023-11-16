-- DONE https://github.com/hrsh7th/nvim-cmp/pull/1734

local kind_icons = {
  Method = "",
  Function = "",
  Constructor = "",
  Variable = "",
  Field = "",
  TypeParameter = "",
  Constant = "",
  Class = "",
  Interface = "",
  Struct = "",
  Event = "",
  Operator = "",
  Module = "",
  Property = "",
  Value = "",
  Enum = "",
  Reference = "",
  Keyword = "",
  File = "",
  Folder = "",
  Color = "",
  Unit = "",
  Snippet = "",
  EnumMember = "",
  Text = "",
}

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local winhighlight = "Normal:Normal,FloatBorder:Comment,CursorLine:CursorLine,Search:None"

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    -- "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-vsnip",
    "hrsh7th/vim-vsnip",
    "rafamadriz/friendly-snippets",
  },
  event = { "InsertEnter" },
  config = function()
    local cmp = require("cmp")

    ---@diagnostic disable-next-line missing-fields
    cmp.setup({
      experimental = { ghost_text = true },
      -- completion = {
      --   autocomplete = false,
      -- },
      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered({
          col_offset = -1,
          winhighlight = winhighlight,
          -- border = "single",
        }),
        documentation = cmp.config.window.bordered({
          col_offset = -1,
          winhighlight = winhighlight,
          -- border = "single",
        }),
      },
      ---@diagnostic disable-next-line missing-fields
      formatting = {
        -- fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          -- local origin_kind = vim_item.kind
          -- vim_item.menu = origin_kind
          -- vim_item.kind = kind_icons[origin_kind] .. " "

          if entry.source.name == "buffer" then
            vim_item.kind = "Buffer"
          end
          return vim_item
        end,
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-1),
        ["<C-f>"] = cmp.mapping.scroll_docs(1),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif vim.fn["vsnip#available"](1) == 1 then
            feedkey("<Plug>(vsnip-expand-or-jump)", "")
          elseif has_words_before() then
            cmp.complete()
          else
            fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.fn["vsnip#jumpable"](-1) == 1 then
            feedkey("<Plug>(vsnip-jump-prev)", "")
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "vsnip" },
        { name = "nvim_lsp" },
        { name = "buffer" },
      }),
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    ---@diagnostic disable-next-line missing-fields
    -- cmp.setup.cmdline({ "/", "?" }, {
    --   mapping = cmp.mapping.preset.cmdline(),
    --   sources = cmp.config.sources({
    --     { name = "buffer" },
    --   }),
    -- })

    -- Use cmdline source for ':' (if you enabled `native_menu`, this won't work anymore).
    ---@diagnostic disable-next-line missing-fields
    -- cmp.setup.cmdline(":", {
    --   mapping = cmp.mapping.preset.cmdline(),
    --   sources = cmp.config.sources({
    --     { name = "cmdline" },
    --   }),
    -- })
  end,
}
