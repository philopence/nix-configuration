return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufRead", "BufNewFile" },
  main = "ibl",
  opts = {
    scope = { enabled = false },
    indent = { char = "▏" },
  },
}
