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
    cmdheight = 0,
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
    updatetime = 100,
    timeoutlen = 500,
    undofile = true,
    laststatus = 3,
    statusline = "%F",
    winbar = "%t%m%r",
    mouse = "",
    number = true,
    relativenumber = true,
    signcolumn = "yes",
    fillchars = "fold: ",
    completeopt = "menu,menuone,noinsert,noselect",
    pumheight = 7,
    foldtext = "v:lua.vim.treesitter.foldtext()",
  }

  for k, v in pairs(options) do
    vim.api.nvim_set_option_value(k, v, {})
  end

  local function format(hl_group)
    return function(content)
      return string.format("%%#%s#%s%%*", hl_group or "Normal", content or "")
    end
  end

  function _G.winbar()
    local cur_win = vim.api.nvim_get_current_win()
    local cur_buf = vim.api.nvim_win_get_buf(cur_win)
    local buf_name = vim.api.nvim_buf_get_name(cur_buf)

    if #buf_name == 0 then
      return ""
    end

    local relative_path = vim.fn.fnamemodify(buf_name, ":.:h")
    local fname = vim.fn.fnamemodify(buf_name, ":t")
    local icon, hl_icon = require("nvim-web-devicons").get_icon(buf_name)

    return table.concat({
      format("Directory")(" " .. relative_path),
      format()(" 󰮺 "),
      format(hl_icon)(icon .. " "),
      format()(fname),
      format()("%m"),
    })
  end

  vim.api.nvim_set_option_value("winbar", "%{%v:lua.winbar()%}", {})

  local function Diags()
    local sign_diags = { "E", "W", "I", "H" }
    local type_diags = { "Error", "Warn", "Info", "Hint" }
    local diags = {}
    for i, sign in ipairs(sign_diags) do
      local num = #vim.diagnostic.get(0, { severity = i })
      if num ~= 0 then
        table.insert(diags, format("DiagnosticSign" .. type_diags[i])(sign .. num))
      end
    end
    return table.concat(diags, " ")
  end

  local function Git()
    local git = ""
    if vim.b.gitsigns_head then
      git = format("NeogitBranch")(" " .. vim.b.gitsigns_head)
    end
    if vim.b.gitsigns_status then
      git = git .. " " .. format("Comment")(vim.b.gitsigns_status)
    end
    return git
  end

  local function Workspace()
    local ws_dir = vim.fn.fnamemodify(vim.loop.cwd(), ":t")
    return format("Directory")(" " .. ws_dir)
  end

  function _G.statusline()
    return table.concat({
      Workspace(),
      "  ",
      Git(),
      "  ",
      Diags(),
      "%=",
      "%c/%l:%L %P",
    })
  end

  vim.api.nvim_set_option_value("statusline", "%{%v:lua.statusline()%}", {})

  function _G.tabline()
    local tabpages = vim.api.nvim_list_tabpages()
    local current_tabpage = vim.api.nvim_get_current_tabpage()
    local items = {}

    for _, tabpage in ipairs(tabpages) do
      local win = vim.api.nvim_tabpage_get_win(tabpage)
      local buf = vim.api.nvim_win_get_buf(win)
      local name = vim.api.nvim_buf_get_name(buf)
      name = #name == 0 and "[No Name]" or name

      local icon = require("nvim-web-devicons").get_icon(name)

      local hl_tabpage = tabpage == current_tabpage and "TabLineSel" or "TabLine"

      local modified = vim.api.nvim_get_option_value("modified", { buf = buf })
      modified = modified and "[+]" or ""
      local readonly = vim.api.nvim_get_option_value("readonly", { buf = buf })
      readonly = readonly and "[-]" or ""

      local item = string.format("%%#%s# %s %s%s%s %%*", hl_tabpage, icon, vim.fs.basename(name), modified, readonly)
      table.insert(items, item)
    end
    return table.concat(items, "")
  end

  -- vim.api.nvim_set_option_value("showtabline", 2, {})
  -- vim.api.nvim_set_option_value("tabline", "%{%v:lua.tabline()%}", {})

  -- ##### KEYMAPS #####
  vim.keymap.set({ "n" }, "<Leader>i", "<Cmd>Inspect<CR>")

  vim.keymap.set({ "n", "v", "o" }, " ", "<NOP>")

  vim.keymap.set({ "n", "x" }, "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true })
  vim.keymap.set({ "n", "x" }, "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true })

  vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<Esc><Cmd>write | redrawstatus<CR>")

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

  vim.keymap.set("n", "<C-q>", "<Esc><Cmd>quit<CR>")
  vim.keymap.set("n", "<C-j>", "<Cmd>wincmd w<CR>")
  vim.keymap.set("n", "<C-k>", "<Cmd>wincmd W<CR>")

  vim.keymap.set("n", "<C-h>", "<Cmd>tabprevious<CR>")
  vim.keymap.set("n", "<C-l>", "<Cmd>tabnext<CR>")
  vim.keymap.set("n", "<C-t>n", "<Cmd>tabnew<CR>")
  vim.keymap.set("n", "<C-t>c", "<Cmd>tabclose<CR>")
  vim.keymap.set("n", "<C-t>h", "<Cmd>tabmove -1<CR>")
  vim.keymap.set("n", "<C-t>l", "<Cmd>tabmove +1<CR>")

  --
  vim.keymap.set("n", "<C-Down>", "<Cmd>wincmd w<CR>")
  vim.keymap.set("n", "<C-Up>", "<Cmd>wincmd W<CR>")
  vim.keymap.set("n", "<C-Left>", "<Cmd>tabprevious<CR>")
  vim.keymap.set("n", "<C-Right>", "<Cmd>tabnext<CR>")
  --

  vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

  vim.keymap.set("n", "<C-n>", "<Cmd>cnext<CR>")
  vim.keymap.set("n", "<C-p>", "<Cmd>cprev<CR>")

  -- ##### AUTOCMDS #####
  local def_group = vim.api.nvim_create_augroup("DEFAULTS", {})
  -- Highlight yanked text
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = def_group,
    callback = function()
      vim.highlight.on_yank()
    end,
  })
  -- Restore cursor
  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = def_group,
    callback = function()
      vim.fn.setpos(".", vim.fn.getpos([['"]]))
    end,
  })
  -- Trim trailing whitespace
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = def_group,
    callback = function()
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd([[%s/\s\+$//e]])
      vim.api.nvim_win_set_cursor(0, pos)
    end,
  })
  -- Start builtin terminal in Insert mode
  vim.api.nvim_create_autocmd("TermOpen", {
    group = def_group,
    command = "startinsert",
  })

  -- ##### DIAGNOSTICS #####
  vim.diagnostic.config({
    signs = true,
    severity_sort = true,
    float = {
      border = "single",
    },
  })

  vim.g.diag_severities = {
    { type = "Error", sign = "" },
    { type = "Warn", sign = "" },
    { type = "Info", sign = "" },
    { type = "Hint", sign = "" },
  }
  for _, diag_severity in ipairs(vim.g.diag_severities) do
    local name = "DiagnosticSign" .. diag_severity.type
    local hl_group = name
    vim.fn.sign_define({ { name = name, text = diag_severity.sign, texthl = hl_group, numhl = hl_group } })
  end

  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
  vim.keymap.set("n", "<Leader>dp", vim.diagnostic.open_float)
end

return M
