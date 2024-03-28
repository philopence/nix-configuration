local M = {}

M.setup = function()
  -- ##### GLOBALS #####
  vim.g.mapleader = " "
  vim.g.maplocalleader = ","

  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  -- ##### OPTIONS #####
  local options = {
    termguicolors = true,
    showcmd = false,
    showmode = false,
    showmatch = false,
    ruler = false,
    cursorline = false,
    list = true,
    listchars = "tab:⭲ ,trail:·,extends:…,precedes:…,nbsp:␣,conceal:…",
    wrap = false,
    linebreak = true,
    breakindent = true,
    ignorecase = true,
    infercase = true,
    smartcase = true,
    splitbelow = true,
    splitright = true,
    scrolloff = 5,
    sidescrolloff = 5,
    expandtab = true,
    tabstop = 2,
    shiftwidth = 0,
    softtabstop = -1,
    updatetime = 300,
    timeoutlen = 500,
    undofile = true,
    -- laststatus = 3,
    -- statusline = "",
    -- statusline = "%F%m%r%=%c/%l:%L %P",
    -- winbar = "%t%m%r",
    mouse = "nvi",
    number = true,
    relativenumber = true,
    signcolumn = "yes",
    cmdheight = 0,
    jumpoptions = "stack",
    -- TODO figure out why the popup window invalid
    completeopt = "menu,menuone,popup,longest,noinsert,noselect",
    pumheight = 7,
    foldtext = "",
    foldmethod = "expr",
    foldexpr = "v:lua.vim.treesitter.foldexpr()",
    -- foldenable = false,
    foldlevel = 1024,
    fillchars = "fold: ",
    -- TODO custom foldcolumn
    -- foldcolumn = "1",
  }

  for k, v in pairs(options) do
    vim.api.nvim_set_option_value(k, v, {})
  end

  -- ##### KEYMAPS #####

  for _, key in ipairs({
    " ",
    "s",
    "S",
    "<BS>",
  }) do
    vim.keymap.set({ "n", "x" }, key, "<NOP>")
  end

  vim.keymap.set({ "n" }, "<Leader>i", "<Cmd>Inspect<CR>")

  vim.keymap.set({ "n", "i", "x" }, "<C-s>", "<Esc><Cmd>write<CR>")

  vim.keymap.set("n", "<C-q>", "<Cmd>quit<CR>")

  -- vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
  -- vim.keymap.set({ "n", "x" }, "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true })

  for _, key in ipairs({ "<Down>", "<Up>" }) do
    vim.keymap.set({ "n", "x" }, key, function()
      return vim.v.count == 0 and "g" .. key or key
    end, { expr = true })
  end

  vim.keymap.set("n", "U", "<Cmd>redo<CR>")
  vim.keymap.set("n", "<Esc>", "<Cmd>nohls<CR>")

  vim.keymap.set({ "n", "x" }, "gy", '"+y')
  vim.keymap.set("n", "gp", '"+p')
  vim.keymap.set("x", "gp", '"+P')

  vim.keymap.set("n", "gQ", "gggqG<C-o>zz", { desc = "Format Current Buffer" })

  vim.keymap.set("n", "gV", '"`[" . strpart(getregtype(), 0, 1) . "`]"', { expr = true })

  vim.keymap.set("x", "g/", "<esc>/\\%V", { silent = false, desc = "Search inside visual selection" })

  vim.keymap.set("n", "go", function()
    vim.fn.append(vim.fn.line(".") or 0, vim.fn["repeat"]({ "" }, vim.v.count1))
  end, {})
  vim.keymap.set("n", "gO", function()
    vim.fn.append(vim.fn.line(".") - 1, vim.fn["repeat"]({ "" }, vim.v.count1))
  end, {})

  -- vim.keymap.set("n", "<C-j>", "<Cmd>wincmd w<CR>")
  -- vim.keymap.set("n", "<C-k>", "<Cmd>wincmd W<CR>")
  -- vim.keymap.set("n", "<C-h>", "<Cmd>tabprevious<CR>")
  -- vim.keymap.set("n", "<C-l>", "<Cmd>tabnext<CR>")
  --
  vim.keymap.set("n", "<C-Down>", "<Cmd>wincmd w<CR>")
  vim.keymap.set("n", "<C-Up>", "<Cmd>wincmd W<CR>")
  vim.keymap.set("n", "<C-Left>", "<Cmd>tabprevious<CR>")
  vim.keymap.set("n", "<C-Right>", "<Cmd>tabnext<CR>")

  vim.keymap.set("n", "<Leader>tc", "<Cmd>tabnew<CR>")
  vim.keymap.set("n", "<Leader>td", "<Cmd>tabclose<CR>")
  -- vim.keymap.set("n", "<Leader>th", "<Cmd>tabmove -1<CR>")
  -- vim.keymap.set("n", "<Leader>tl", "<Cmd>tabmove +1<CR>")

  -- vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

  -- ##### AUTOCMDS #####
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("ns/yank_post", {}),
    desc = "Highlight yanked text",
    callback = function()
      vim.highlight.on_yank()
    end,
  })

  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = vim.api.nvim_create_augroup("ns/last_location", {}),
    desc = "Go to the last location when opening a buffer",
    callback = function()
      vim.fn.setpos(".", vim.fn.getpos([['"]]))
    end,
  })

  -- vim.api.nvim_create_autocmd("BufWritePre", {
  --   group = vim.api.nvim_create_augroup("ns/trim_whitespace", {}),
  --   desc = "Trim trailing whitespace",
  --   callback = function()
  --     local pos = vim.api.nvim_win_get_cursor(0)
  --     vim.cmd([[%s/\s\+$//e]])
  --     vim.api.nvim_win_set_cursor(0, pos)
  --   end,
  -- })

  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("ns/hide_statusline", {}),
    desc = "hide statusline on startup page",
    callback = function()
      vim.opt.laststatus = 0
      vim.api.nvim_create_autocmd("BufUnload", {
        once = true,
        callback = function()
          vim.o.laststatus = 3
        end,
      })
    end,
  })

  -- ##### DIAGNOSTICS #####
  vim.diagnostic.config({
    signs = true,
    severity_sort = true,
    virtual_text = false,
    float = {
      border = "rounded",
      source = true,
    },
  })

  local diag_type_signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
  for type, sign in ipairs(diag_type_signs) do
    local hl_name = "DiagnosticSign" .. type
    vim.fn.sign_define(hl_name, { text = sign, texthl = hl_name, numhl = hl_name })
  end

  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
  vim.keymap.set("n", "<Leader>cd", vim.diagnostic.open_float, { desc = "Code Diagnostics" })
end

-- vim.api.nvim_create_autocmd("CompleteDone", {
--   callback = function(args)
--     local text = vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "completion_item", "insertText")
--     if not text then
--       return
--     end
--
--     local cursor = vim.api.nvim_win_get_cursor(0)
--     vim.api.nvim_buf_set_text(
--       args.buf,
--       cursor[1] - 1,
--       cursor[2] - #vim.v.completed_item.word,
--       cursor[1] - 1,
--       #vim.api.nvim_get_current_line(),
--       { "" }
--     )
--
--     vim.snippet.expand(text)
--   end,
-- })

return M
