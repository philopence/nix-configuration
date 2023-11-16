return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    "windwp/nvim-ts-autotag",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  -- ft = filetypes,
  event = { "VeryLazy" },
  build = ":TSUpdate",
  main = "nvim-treesitter.configs",
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "regex",
      "markdown",
      "markdown_inline",
      "json",
      "lua",
      "nix",
      "html",
      "css",
      "javascript",
    },
    highlight = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<CR>",
        node_incremental = "<CR>",
        scope_incremental = false,
        node_decremental = "<BS>",
      },
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    autotag = { enable = true },
  },
}
