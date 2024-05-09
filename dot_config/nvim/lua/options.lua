-- [[ Setting options ]]
local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- [[ Tabs ]]
opt.tabstop = 4 -- 4 spaces for tabs
opt.shiftwidth = 4
opt.expandtab = true -- tab to spaces
opt.autoindent = true -- copy indent

-- [[ search settting ]]
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = true

opt.mouse = 'a'
opt.showmode = false
opt.clipboard = 'unnamedplus'
opt.breakindent = true
opt.undofile = true
opt.signcolumn = 'yes'
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.inccommand = 'split'
opt.scrolloff = 10
opt.hlsearch = true -- Set highlight on search, but clear on pressing <Esc> in normal mode
