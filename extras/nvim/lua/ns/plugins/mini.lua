return {
  {
    "echasnovski/mini.ai",
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
  -- { "echasnovski/mini.pairs", event = "InsertEnter", opts = {} },
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
    event = "BufRead",
    opts = {},
    config = function()
      local statusline = require("mini.statusline")
      statusline.setup({})

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return "%c/%l:%L %P"
      end
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
