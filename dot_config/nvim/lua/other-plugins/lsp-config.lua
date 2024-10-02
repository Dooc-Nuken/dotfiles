return {
  'neovim/nvim-lspconfig',
  event = {"BufReadPre", "BufNewFile"},
  config = function()
    local lspconfig = require("lspconfig")
    local keymap = vim.keymap
    
    lspconfig.lua_ls.setup({})

    keymap.set('n', 'gd', vim.lsp.buf.definition)
    keymap.set('n', 'K', vim.lsp.buf.hover)
  end,
}
