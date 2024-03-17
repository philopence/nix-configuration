return {
  {
    "echasnovski/mini.ai",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    event = { "BufRead", "BufNewFile" },
    opts = function()
      local ai = require("mini.ai")
      return {
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      }
    end,
  },
  { "echasnovski/mini.pairs", event = "InsertEnter", opts = {} },
  {
    "echasnovski/mini.move",
    keys = {
      { "<M-h>", mode = { "n", "x" } },
      { "<M-j>", mode = { "n", "x" } },
      { "<M-k>", mode = { "n", "x" } },
      { "<M-l>", mode = { "n", "x" } },
    },
    opts = {},
  },
  {
    "echasnovski/mini.statusline",
    event = "VeryLazy",
    config = function()
      local statusline = require("mini.statusline")
      statusline.setup({
        set_vim_settings = true,
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local git = MiniStatusline.section_git({ trunc_width = 75 })
            local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
            local filename = MiniStatusline.section_filename({ trunc_width = 140 })
            local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
            -- local location = MiniStatusline.section_location({ trunc_width = 75 })
            local location = "%c/%l:%L %P"
            local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
            local grapple = require("grapple").statusline()

            return MiniStatusline.combine_groups({
              { hl = mode_hl, strings = { mode } },
              { hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
              "%<", -- Mark general truncate point
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=", -- End left alignment
              { hl = "Normal", strings = { grapple } },
              { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
              { hl = mode_hl, strings = { search, location } },
            })
          end,
        },
      })

      ---@diagnostic disable-next-line: duplicate-set-field
      -- statusline.section_location = function()
      --   return "%c/%l:%L %P"
      -- end
    end,
  },
  {
    "echasnovski/mini.operators",
    keys = {
      { "gx", mode = { "n", "x" } },
      { "gm", mode = { "n", "x" } },
    },
    opts = {},
  },
  {
    "echasnovski/mini.splitjoin",
    keys = {
      { "gS", mode = { "n", "x" } },
    },
    opts = {},
  },

  {
    "echasnovski/mini.hipatterns",
    event = { "BufRead", "BufNewFile" },
    opts = function()
      return {
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
        },
      }
    end,
  },

  {
    "echasnovski/mini.align",
    keys = {
      { "ga", mode = { "n", "x" } },
    },
    opts = {},
  },
  {
    "echasnovski/mini.surround",
    keys = {
      { "sa", mode = { "n", "x" } },
      { "sd" },
      { "sr" },
      { "sh" },
      { "sf" },
      { "sF" },
    },
    opts = {},
  },

  {
    "echasnovski/mini.comment",
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        main = "ts_context_commentstring",
        opts = {
          enable_autocmd = false,
        },
      },
    },
    keys = {
      { "gc", mode = { "n", "x" } },
    },
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },
}
