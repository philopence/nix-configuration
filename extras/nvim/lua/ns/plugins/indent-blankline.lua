return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufRead", "BufNewFile" },
  main = "ibl",
  opts = {
    scope = { enabled = false },
    indent = { char = "▏" },
  },
  config = function(_, opts)
    require("ibl").setup(opts)
    -- local hooks = require("ibl.hooks")
    -- hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
  end,
}
