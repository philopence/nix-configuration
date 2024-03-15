return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "windwp/nvim-ts-autotag",
    },
    event = { "BufRead", "BufNewFile" },
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "vim",
        "vimdoc",
        "lua",
        "nix",
        "bash",
        "c",
        "regex",
        "markdown",
        "markdown_inline",
        "json",
        "html",
        "css",
        "styled",
        "javascript",
        "typescript",
        "tsx",
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
      autotag = { enable = true },
    },
  },
}
