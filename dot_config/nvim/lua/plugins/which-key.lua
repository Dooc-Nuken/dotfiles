return {
  -- Creer un menu me presentant les keybinds
    'folke/which-key.nvim',
    event = 'VimEnter', 
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup({
    -- Ici, tu peux ajuster les options globales
        plugins = {
          presets = {
            operators = false,  -- Désactiver les raccourcis opérateurs par défaut
            motions = false,    -- Désactiver les raccourcis de mouvement par défaut
            text_objects = false, -- Désactiver les objets de texte par défaut
          },
        },
      })

      require('which-key').add{
      -- Document existing key chains
        { "<leader>c", desc = "[C]ode", mode = "n"},
        { "<leader>d", desc = "[D]ocument" },
        { "<leader>e", group = "[E]xpand TREE" },
        { "<leader>t", group = "[T]ab" },
        { "<leader>f", group = "[F]ind - telescope" },
        { "<leader>n", group = "[N]o highlight" },
        { "<leader>r", desc = "[R]ename" },
        { "<leader>s", group = "[S]plit" },
        { "<leader>w", group = "[W]orkspace - Save - Restore" },
        { "ys", group = "[y]ou [s]urround", mode = "n", hidden = false},
        { "d", desc= "[d]elete [s]urround", mode = "n"},
        { "c", desc= "[c]hange [s]urround", mode = "n"},
      }
    end,
}
