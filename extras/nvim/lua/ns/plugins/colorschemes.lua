return {
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
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
    opts = {
      -- on_highlights = function(hl, c)
      --   hl.TelescopeBorder = {
      --     bg = c.bg_dark,
      --     fg = c.bg_dark,
      --   }
      --   hl.TelescopePromptNormal = {
      --     bg = c.bg_highlight,
      --   }
      --   hl.TelescopePromptBorder = {
      --     bg = c.bg_highlight,
      --     fg = c.bg_highlight,
      --   }
      --   hl.TelescopePromptTitle = {
      --     bg = c.blue,
      --     fg = c.bg,
      --   }
      --   hl.TelescopePreviewTitle = {
      --     bg = c.green,
      --     fg = c.bg,
      --   }
      --   hl.TelescopeResultsTitle = {
      --     bg = c.yellow,
      --     fg = c.bg,
      --   }
      -- end,
    },
  },
}
