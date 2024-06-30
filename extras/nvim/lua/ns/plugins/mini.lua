return {
  { "echasnovski/mini.starter", event = "VimEnter", opts = {} },

  {
    "echasnovski/mini.animate",
    event = { "BufRead", "BufNewFile" },
    opts = {
      open = { enable = false },
      close = { enable = false },
    },
  },

  {
    "echasnovski/mini.hipatterns",
    event = { "BufRead", "BufNewFile" },
    opts = function()
      local hipatterns = require("mini.hipatterns")
      return {
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      }
    end,
  },

  {
    "echasnovski/mini.ai",
    event = { "BufRead", "BufNewFile" },
    opts = {},
  },

  {
    "echasnovski/mini.statusline",
    event = "BufWinEnter",
    -- event = "VeryLazy",
    opts = {}
  },

  {
    "echasnovski/mini.operators",
    keys = {
      { "g=", mode = { "n", "x" } },
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
      { "gcc" },
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
