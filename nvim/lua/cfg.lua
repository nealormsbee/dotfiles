-- Basic editor configuration

vim.wo.number = true -- show line numbers
vim.opt.guicursor = "" -- use fat block cursor in all cases
vim.opt.hlsearch = false -- don't highlight all match instances of submitted search
vim.opt.incsearch = true -- do highlight next search match while typing the search
vim.opt.mouse = "" -- disable mouse support
vim.opt.smartindent = true -- automatically indent correctly for C-like syntax
vim.opt.swapfile = false -- don't create a .swp file when editing
vim.opt.updatetime = 50 -- run bg tasks 50ms after cursor stops moving; highly responsive so keep it light
vim.opt.signcolumn = "yes" -- reserve space for lint sign markers rather than shifting content when a sign is needed
