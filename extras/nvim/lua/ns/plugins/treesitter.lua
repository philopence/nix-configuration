return {
  {
    "windwp/nvim-ts-autotag",
    event = { "BufRead", "BufNewFile" },
    opts = {},
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufRead", "BufNewFile" },
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "http",
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
        "prisma",
        "vue",
        -- ready go
        "go",
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
    },
  },
}
