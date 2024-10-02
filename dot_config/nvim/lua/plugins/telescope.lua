return {
  --  Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      'folke/todo-comments.nvim',
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup ({
        defaults = {
          path_display = { "smart" },
          mapping = { 
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
        },
      })

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')

      -- See `:help telescope.builtin`
      local keymap = vim.keymap
      local builtin = require 'telescope.builtin'

      keymap.set('n', '<leader>fk',       builtin.keymaps,         { desc = '[F]earch [K]eymaps' })
      keymap.set('n', '<leader><leader>', builtin.buffers,         { desc = '[ ] Find existing buffers' })
      keymap.set('n', '<leader>ff',       builtin.find_files,      { desc = '[F]ind [F]iles' })
      keymap.set('n', '<leader>fr',       builtin.oldfiles,        { desc = '[F]ind [R]ecent files' })
      keymap.set('n', '<leader>fs',       builtin.live_grep,       { desc = '[F]ind [S]ring - Grep' })
      keymap.set('n', '<leader>fc',       builtin.grep_string,     { desc = '[F]ind [S]ring under cursor in file'})
      keymap.set('n', '<leader>ft',       "<cmd>TodoTelescope<cr>",{ desc = '[F]ind [S]ring under cursor in file'})

      vim.keymap.set('n', '<leader>f/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[F]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>fn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[F]earch [N]eovim (conf)files' })
    end,
}
