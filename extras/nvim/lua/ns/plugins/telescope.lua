return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      enabled = vim.fn.executable("make") == 1,
      build = "make",
    },
  },
  keys = {
    -- { "<Leader>fr", "<Cmd>Telescope resume<CR>" },
    --
    { "<Leader>/", "<Cmd>Telescope current_buffer_fuzzy_find<CR>" },
    { "<Leader>ff", "<Cmd>Telescope find_files<CR>" },
    { "<Leader>fw", "<Cmd>Telescope grep_string<CR>", mode = { "n", "x" } },
    { "<Leader>fg", "<Cmd>Telescope live_grep<CR>" },
    { "<Leader>fb", "<Cmd>Telescope buffers<CR>" },
    { "<Leader>fh", "<Cmd>Telescope help_tags<CR>" },
    { "<Leader>hl", "<Cmd>Telescope highlights<CR>" },
    { "<Leader>fd", "<Cmd>Telescope diagnostics<CR>" },
    { "<Leader>fm", "<Cmd>Telescope file_browser<CR>" },
    { "<Leader>fM", "<Cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>" },

    --
    { "gd", "<Cmd>Telescope lsp_definitions<CR>" },
    { "gr", "<Cmd>Telescope lsp_references<CR>" },
    { "gt", "<Cmd>Telescope lsp_type_definitions<CR>" },
    { "gi", "<Cmd>Telescope lsp_implementations<CR>" },
    { "<Leader>cs", "<Cmd>Telescope lsp_document_symbols<CR>" },
  },
  opts = function()
    local actions = require("telescope.actions")
    return {
      defaults = {
        prompt_prefix = "$ ",
        selection_caret = "▌ ",
        sorting_strategy = "ascending",
        path_display = {
          filename_first = true,
        },
        layout_strategy = "vertical",
        layout_config = {
          horizontal = {
            preview_width = 0.5,
            -- prompt_position = "top",
          },
          vertical = {
            height = 0.9,
            preview_cutoff = -1,
            prompt_position = "top",
            width = 0.7,
            mirror = true,
          },
        },
        -- preview = {
        --   hide_on_startup = true,
        -- },
        -- file_ignore_patterns = { ".git/" },
        mappings = {
          i = {
            ["<C-Down>"] = actions.cycle_history_next,
            ["<C-Up>"] = actions.cycle_history_prev,
            -- ["<C-p>"] = actions_layout.toggle_preview,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          no_ignore = true,
          file_ignore_patterns = { "node_modules/", ".git/" },
        },
        current_buffer_fuzzy_find = {
          previewer = false,
        },
      },
      extensions = {
        file_browser = {
          dir_icon = "",
          dir_icon_hl = "Directory",
          -- hidden = { file_browser = true, folder_browser = true },
          git_status = false,
        },
      },
    }
  end,
  config = function(_, opts)
    require("telescope").setup(opts)

    for _, extension in ipairs({
      "fzf",
      "file_browser",
    }) do
      require("telescope").load_extension(extension)
    end
  end,
}
