-- Enable diagnostics
vim.diagnostic.config({
	virtual_text = true, -- Show diagnostics as virtual text
	signs = true, -- show indicators in the sign column
	underline = true, -- underline the bad code
	update_in_insert = false, -- don't update status while writing
	severity_sort = true, -- list worst errors first
})

-- Define diagnostic signs
local signs = { Error = "x", Warn = "!", Hint = "^", Info = "?" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Enable linters
vim.lsp.enable("rust_analyzer")
