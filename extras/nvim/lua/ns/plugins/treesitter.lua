return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-textobjects",
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        main = "ts_context_commentstring",
        opts = {
          enable_autocmd = false,
        },
      },
    },
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
        "styled",
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
      autotag = { enable = true },
    },
  },
}
