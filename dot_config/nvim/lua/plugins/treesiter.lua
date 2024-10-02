return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    local treesitter = require('nvim-treesitter.configs')

    treesitter.setup({
      ensure_installed = {
        'bash', 
        'c', 
        'html', 
        'lua', 
        'luadoc', 
        'markdown', 
        'vim', 
        'vimdoc', 
        'dockerfile',
        'markdown_inline'
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },

      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {enable = true},
      indent = {enable = true},
    })
  end,
}
