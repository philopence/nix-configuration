return {
  {
    "craftzdog/solarized-osaka.nvim",
    priority = 1000,
    opts = {},
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      custom_highlights = function(colors)
        return {
          StatusLine = { bg = colors.base },
          FloatBorder = { fg = colors.overlay0 },
          -- TelescopeSelection = { fg = colors.flamingo },
          TelescopeSelectionCaret = { bg = colors.surface0 },
        }
      end,
    },
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {},
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    opts = {
      theme = "wave",
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },
    },
  },
}
