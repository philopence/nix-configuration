return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      on_highlights = function(hl, _)
        hl.NvimTreeWinSeparator = { link = "WinSeparator"}
        -- hl.FloatBorder = { fg = "#16161e" , bg= "#16161e"} --#27a1b9
      end
      -- NvimTreeWinSeparator
    },
  },
}

