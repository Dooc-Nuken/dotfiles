return {
  "rmagatti/auto-session",
  dependencies = {
      'nvim-telescope/telescope.nvim', -- Only needed if you want to use session lens
  },
  config = function()
    local auto_session = require("auto-session")

    auto_session.setup({
      auto_restore_enabled = false,
      auto_session_suppress_dirs = {"~/","~/Docmuments","~/Downloads","~/Desktop/"},
      bypass_save_filetypes = { 'alpha', 'dashboard' }, -- or whatever dashboard you use
    })

    local keymap = vim.keymap
    -- Will use Telescope if installed or a vim.ui.select picker otherwise
  keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = 'Restore la session cwd' })
  keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = 'Save session' })
  end,
}
