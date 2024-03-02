local M = {}

M.setup = function()
  -- ##### GLOBALS #####
  vim.g.mapleader = " "
  vim.g.maplocalleader = ","

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
    wrap = true,
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
    -- laststatus = 0,
    -- statusline = "",
    -- statusline = "%F%m%r%=%c/%l:%L %P",
    -- winbar = "%t%m%r",
    mouse = "",
    number = true,
    relativenumber = true,
    signcolumn = "yes",
    cmdheight = 0,
    jumpoptions = "stack",
    completeopt = "menu,menuone,noinsert,noselect",
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
  }) do
    vim.keymap.set({ "n", "x" }, key, "<NOP>")
  end

  -- tmp.
  vim.keymap.set({ "n" }, "<Leader>i", "<Cmd>Inspect<CR>")

  vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<Esc><Cmd>silent write<CR>")
  vim.keymap.set({ "n", "v" }, "<C-q>", "<Esc><Cmd>quit<CR>")

  vim.keymap.set({ "n", "x" }, "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true })
  vim.keymap.set({ "n", "x" }, "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true })
  --
  vim.keymap.set({ "n", "x" }, "<Down>", [[v:count == 0 ? 'gj' : 'j']], { expr = true })
  vim.keymap.set({ "n", "x" }, "<Up>", [[v:count == 0 ? 'gk' : 'k']], { expr = true })

  vim.keymap.set("n", "U", "<Cmd>redo<CR>")
  vim.keymap.set("n", "<Esc>", "<Cmd>nohls<CR>")

  vim.keymap.set({ "n", "x" }, "gy", '"+y')
  vim.keymap.set("n", "gp", '"+p')
  vim.keymap.set("x", "gp", '"+P')

  vim.keymap.set("n", "gV", '"`[" . strpart(getregtype(), 0, 1) . "`]"', { expr = true })

  vim.keymap.set("x", "g/", "<esc>/\\%V", { silent = false, desc = "Search inside visual selection" })

  vim.keymap.set("n", "go", function()
    vim.fn.append(vim.fn.line(".") or 0, vim.fn["repeat"]({ "" }, vim.v.count1))
  end, {})
  vim.keymap.set("n", "gO", function()
    vim.fn.append(vim.fn.line(".") - 1, vim.fn["repeat"]({ "" }, vim.v.count1))
  end, {})

  vim.keymap.set("n", "<C-j>", "<Cmd>wincmd w<CR>")
  vim.keymap.set("n", "<C-k>", "<Cmd>wincmd W<CR>")
  vim.keymap.set("n", "<C-h>", "<Cmd>tabprevious<CR>")
  vim.keymap.set("n", "<C-l>", "<Cmd>tabnext<CR>")
  --
  vim.keymap.set("n", "<C-Down>", "<Cmd>wincmd w<CR>")
  vim.keymap.set("n", "<C-Up>", "<Cmd>wincmd W<CR>")
  vim.keymap.set("n", "<C-Left>", "<Cmd>tabprevious<CR>")
  vim.keymap.set("n", "<C-Right>", "<Cmd>tabnext<CR>")

  vim.keymap.set("n", "<Leader>tn", "<Cmd>tabnew<CR>")
  vim.keymap.set("n", "<Leader>tc", "<Cmd>tabclose<CR>")
  vim.keymap.set("n", "<Leader>th", "<Cmd>tabmove -1<CR>")
  vim.keymap.set("n", "<Leader>tl", "<Cmd>tabmove +1<CR>")

  vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

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

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("ns/trim_whitespace", {}),
    desc = "Trim trailing whitespace",
    callback = function()
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd([[%s/\s\+$//e]])
      vim.api.nvim_win_set_cursor(0, pos)
    end,
  })

  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("ns/statusline", {}),
    desc = "hide statusline on startup page",
    callback = function()
      vim.opt.laststatus = 0
      -- vim.api.nvim_create_autocmd("BufUnload", {
      --   once = true,
      --   callback = function()
      --     vim.o.laststatus = 3
      --   end,
      -- })
    end,
  })

  -- ##### DIAGNOSTICS #####
  vim.diagnostic.config({
    signs = true,
    severity_sort = true,
    virtual_text = false,
    float = {
      border = "single",
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
  vim.keymap.set("n", "<Leader>d", vim.diagnostic.open_float)
end

return M
