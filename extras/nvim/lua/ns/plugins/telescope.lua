return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      enabled = vim.fn.executable("make") == 1,
      build = "make",
    },
    "nvim-telescope/telescope-file-browser.nvim",
  },
  keys = {
    { "<Leader><Space>", "<Cmd>Telescope resume<CR>" },
    { "<Leader>/", "<Cmd>Telescope current_buffer_fuzzy_find<CR>" },
    -- { "<Leader>ff", "<Cmd>Telescope find_files<CR>" },
    { "<Leader>ff", "<Cmd>Telescope find_files hidden=true<CR>" },
    { "<Leader>fw", "<Cmd>Telescope grep_string<CR>" },
    { "<Leader>fs", "<Cmd>Telescope live_grep<CR>" },
    { "<Leader>fb", "<Cmd>Telescope buffers<CR>" },
    { "<Leader>fh", "<Cmd>Telescope help_tags<CR>" },
    {
      "<Leader>fe",
      "<Cmd>Telescope file_browser path=%:p:h select_buffer=true theme=dropdown previewer=false hidden=true grouped=true<CR>",
    },
    --
    { "<Leader>dp", "<Cmd>Telescope diagnostics<CR>" },
    --
    { "gd", "<Cmd>Telescope lsp_definitions<CR>" },
    { "gr", "<Cmd>Telescope lsp_references<CR>" },
    { "gt", "<Cmd>Telescope lsp_type_definitions<CR>" },
    { "gi", "<Cmd>Telescope lsp_implementations<CR>" },
  },
  opts = function()
    local actions = require("telescope.actions")
    local actions_layout = require("telescope.actions.layout")
    return {
      defaults = {
        prompt_prefix = "$ ",
        selection_caret = "▌ ",
        layout_config = {
          horizontal = {
            preview_width = 0.5,
          },
        },
        preview = {
          hide_on_startup = true,
        },
        file_ignore_patterns = { ".git/" },
        mappings = {
          i = {
            ["<C-Down>"] = actions.cycle_history_next,
            ["<C-Up>"] = actions.cycle_history_prev,
            ["<C-f>"] = actions.preview_scrolling_down,
            ["<C-b>"] = actions.preview_scrolling_up,
            ["<C-p>"] = actions_layout.toggle_preview,
          },
        },
      },
    }
  end,
  config = function(_, opts)
    require("telescope").setup(opts)

    for _, extension in ipairs({ "fzf", "file_browser" }) do
      require("telescope").load_extension(extension)
    end
  end,
}
