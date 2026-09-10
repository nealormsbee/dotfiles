-- Basic editor keymappings - not specific to any extensions

-- set leaders
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local function comment()
	local filetype = vim.bo.filetype
	local keys
	if
		filetype == "typescriptreact"
		or filetype == "typescript"
		or filetype == "go"
		or filetype == "c"
		or filetype == "rust"
		or filetype == "javascript"
	then
		keys = "I// <ESC>"
	elseif filetype == "python" or filetype == "sh" then
		keys = "I# <ESC>"
	elseif filetype == "lua" then
		keys = "I-- <ESC>"
	end
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), "n", false)
end

-- general keymaps
vim.keymap.set("n", "<leader>pv", "<cmd>Ex<cr>") -- open NetRW
vim.keymap.set("n", "<leader>/", comment) -- comment the current line

-- lsp keymaps
vim.keymap.set("n", "gd", vim.lsp.buf.definition) -- gd => go to symbol definition
vim.keymap.set("n", "gi", vim.lsp.buf.implementation) -- gi => go to symbol implementation
vim.keymap.set("n", "gl", vim.diagnostic.open_float) -- gl => open floating diagnostic window
