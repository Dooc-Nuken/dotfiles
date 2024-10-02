return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    local mason = require("mason")
    local masonlsp = require("mason-lspconfig")
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })
    masonlsp.setup({
      ensure_installed = {
        "lua_ls",
        "html",
        "cssls",
        "pyright",
      },
    })
  end,
}
