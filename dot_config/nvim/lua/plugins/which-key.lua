return {
    'folke/which-key.nvim',
    event = 'VimEnter', 
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()
      require('which-key').add{
      -- Document existing key chains
        { "<leader>c", desc = "[C]ode", mode = "n"},
        { "<leader>d", desc = "[D]ocument" },
        { "<leader>e", group = "[E]xpand TREE" },
        { "<leader>f", group = "[F]ind - telescope" },
        { "<leader>n", group = "[N]o highlight" },
        { "<leader>r", desc = "[R]ename" },
        { "<leader>s", group = "[S]plit" },
      }
    end,
}
