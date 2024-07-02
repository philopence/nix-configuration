-- TODO https://github.com/vuejs/language-tools/discussions/4495

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

    -- check if in start tag
    local function is_in_start_tag()
      local ts_utils = require("nvim-treesitter.ts_utils")
      local node = ts_utils.get_node_at_cursor()
      if not node then
        return false
      end
      return node:type() == "start_tag"
    end

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
        {
          name = "nvim_lsp",

          entry_filter = function(entry, ctx)
            if ctx.filetype ~= "vue" then
              return true
            end

            -- Use a buffer-local variable to cache the result of the Treesitter check
            local bufnr = ctx.bufnr
            local cached_is_in_start_tag = vim.b[bufnr]._vue_ts_cached_is_in_start_tag
            if cached_is_in_start_tag == nil then
              vim.b[bufnr]._vue_ts_cached_is_in_start_tag = is_in_start_tag()
            end
            -- If not in start tag, return true
            if vim.b[bufnr]._vue_ts_cached_is_in_start_tag == false then
              return true
            end

            local cursor_before_line = ctx.cursor_before_line
            -- For events
            if cursor_before_line:sub(-1) == "@" then
              return entry.completion_item.label:match("^@")
            -- For props also exclude events with `:on-` prefix
            elseif cursor_before_line:sub(-1) == ":" then
              return entry.completion_item.label:match("^:") and not entry.completion_item.label:match("^:on-")
            else
              return true
            end
          end,
        },
      }, {
        { name = "buffer", keyword_length = 3 },
      }),
    })

    cmp.event:on("menu_closed", function()
      local bufnr = vim.api.nvim_get_current_buf()
      vim.b[bufnr]._vue_ts_cached_is_in_start_tag = nil
    end)

    -- set global highlight
    vim.api.nvim_set_hl(0, "CmpItemKindCodeium", { link = "CmpItemKindCopilot" })
    vim.api.nvim_set_hl(0, "CmpItemKindBuffer", { link = "CmpItemKindText" })
  end,
}
