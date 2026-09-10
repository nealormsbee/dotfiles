local fmt = require("formatter")
local util = require("formatter.util")

fmt.setup({
	filetype = {
		typescript = {
			function()
				return {
					exe = "npx prettier",
					args = {
						"--stdin-filepath",
						util.escape_path(util.get_current_buffer_file_path()),
					},
					stdin = true,
				}
			end,
		},
		typescriptreact = {
			function()
				return {
					exe = "npx prettier",
					args = {
						"--stdin-filepath",
						util.escape_path(util.get_current_buffer_file_path()),
					},
					stdin = true,
				}
			end,
		},
		lua = {
			function()
				return {
					exe = "stylua",
					args = { "-" },
					stdin = true,
				}
			end,
		},
	},
})

local formatGrp = vim.api.nvim_create_augroup("FormatAutogroup", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", { command = "FormatWrite", group = formatGrp })
