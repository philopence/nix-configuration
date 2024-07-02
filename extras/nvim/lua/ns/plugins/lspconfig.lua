return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {},
    },
    "b0o/schemastore.nvim",
  },
  event = "VeryLazy",
  config = function()
    local lspconfig = require("lspconfig")
    local lspconfig_util = require("lspconfig.util")

    local location = lspconfig_util.find_node_modules_ancestor(vim.fs.joinpath(vim.fn.getenv("XDG_DATA_HOME"), "npm"))

    local capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      require("cmp_nvim_lsp").default_capabilities()
    )

    ---@param config lspconfig.Config?
    local function with_capabilities(config)
      return vim.tbl_deep_extend("force", { capabilities = capabilities }, config or {})
    end

    lspconfig.lua_ls.setup(with_capabilities({
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace",
          },
          workspace = {
            checkThirdParty = false,
          },
        },
      },
    }))

    lspconfig.vtsls.setup(with_capabilities({
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "vue",
      },
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              {
                name = "@vue/typescript-plugin",
                -- location = "~/.local/share/npm/lib/node_modules",
                location = location,
                languages = { "vue" },
                configNamespace = "typescript",
                enableForWorkspaceTypeScriptVersions = true,
              },
            },
          },
        },
      },
    }))

    lspconfig.volar.setup(with_capabilities({
      -- init_options = {
      --   vue = {
      --     hybridMode = false,
      --   },
      -- },
    }))

    lspconfig.jsonls.setup(with_capabilities({
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    }))

    for _, server in ipairs({
      "emmet_language_server",
      "html",
      "cssls",
      "tailwindcss",
      "marksman",
    }) do
      lspconfig[server].setup(with_capabilities())
    end
  end,
}
