return {
  "b0o/incline.nvim",
  event = "VeryLazy",
  opts = {
    render = function(props)
      local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")

      if #filename == 0 then
        return
      end

      local extension = vim.fn.fnamemodify(filename, ":e")
      local icon, hl = require("nvim-web-devicons").get_icon(filename, extension, { default = true })
      local modified = vim.bo[props.buf].modified

      return {
        " ",
        icon,
        " ",
        filename,
        modified and " 󰛄" or "",
        " ",
        -- guibg = "#111111",
        -- guifg = "#eeeeee",
      }
    end,
    highlight = {
      groups = {
        InclineNormal = {
          default = true,
          group = "CurSearch",
        },
        InclineNormalNC = {
          default = true,
          group = "Visual",
        },
      },
    },
  },
}
