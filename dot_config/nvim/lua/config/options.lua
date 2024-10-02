-- [[ Netrw config]]
vim.cmd 'let g:netrw_liststyle = 3'

local opt = vim.opt

-- [[ Basic options ]]
opt.relativenumber = true
opt.number = true

-- [[ Tabs ]]
opt.tabstop = 2 -- 2 spaces for tabs
opt.shiftwidth = 2
opt.expandtab = true -- tab to spaces
opt.autoindent = true -- copy indent

-- [[ search settting ]]
opt.ignorecase = true -- ignorecase when searching e
opt.smartcase = true -- If mixcase in search will trigger smartcase
opt.cursorline = true

-- [[ Backgroud option]]
opt.background = 'dark' -- default to dark mode
opt.signcolumn = 'yes'

-- [[clipboard]]
opt.clipboard = 'unnamedplus'

opt.mouse = 'a'
opt.showmode = false
opt.breakindent = true
opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true

-- Je ne sais pas si c'est vraiment utile.
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.inccommand = 'split'
opt.scrolloff = 10
opt.hlsearch = true -- Set highlight on search, but clear on pressing <Esc> in normal mode

vim.g.have_nerd_font = true

-- [[ Basic Autocommands ]] See `:help lua-guide-autocommands`
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

