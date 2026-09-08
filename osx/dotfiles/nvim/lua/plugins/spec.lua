local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
	-- the colorscheme should be available when starting Neovim
	{
		"folke/tokyonight.nvim",
		lazy = false, -- make sure we load this during startup
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme
			vim.cmd([[colorscheme tokyonight]])
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		lazy = true,
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"hrsh7th/nvim-cmp",
		version = false, -- last official release is super old, so don't bind to a version. Just use latest.
		-- load completions plugin when entering Insert mode.
		event = "InsertEnter",
		-- lazy load deps when autocompletion loads
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		opts = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},

				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
				}, { { name = "buffer" } }),

				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},

				mapping = {
					["<Down>"] = function(fallback)
						if not cmp.select_next_item() then
							if vim.bo.buftype ~= "prompt" and has_words_before() then
								cmp.complete()
							else
								fallback()
							end
						end
					end,
					["<Up>"] = function(fallback)
						if not cmp.select_prev_item() then
							if vim.bo.buftype ~= "prompt" and has_words_before() then
								cmp.complete()
							else
								fallback()
							end
						end
					end,
					["<Tab>"] = function(fallback)
						if not cmp.select_next_item() then
							if vim.bo.buftype ~= "prompt" and has_words_before() then
								cmp.complete()
							else
								fallback()
							end
						end
					end,
					["<S-Tab>"] = function(fallback)
						if not cmp.select_prev_item() then
							if vim.bo.buftype ~= "prompt" and has_words_before() then
								cmp.complete()
							else
								fallback()
							end
						end
					end,
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Insert,
						select = true,
					}),
				},
			})

			-- local capabilities = require("cmp_nvim_lsp").default_capabilities()
			-- vim.lsp.config["lua_ls"].setup({ capabilities = capabilities })
			-- vim.lsp.config["gopls"].setup({ capabilities = capabilities })
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = true,
		event = "BufReadPost",
		config = function(_, servers)
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Enable diagnostics
			vim.diagnostic.config({
				virtual_text = true, -- Show diagnostics as virtual text
				signs = true, -- Show signs in the sign column
				underline = true, -- Underline problematic code
				update_in_insert = false,
				severity_sort = true,
			})

			-- Define diagnostic signs
			local signs = { Error = "✘", Warn = "▲", Hint = "⚑", Info = "»" }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			-- TypeScript/JavaScript

			-- TSServer
			vim.lsp.config.ts_ls = {
				cmd = { "typescript-language-server", "--stdio" },
				filetypes = { "typescript", "typescriptreact" },
				root_markers = { "package.json", "tsconfig.json" },
				capabilities = capabilities,
			}

			-- ESLint
			vim.lsp.config.eslint = {
				cmd = { "vscode-eslint-language-server", "--stdio" },
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				root_markers = {
					".eslintrc",
					".eslintrc.js",
					".eslintrc.ts",
					".eslintrc.json",
					"eslint.config.js",
					"eslint.config.ts",
					"eslint.config.cjs",
					"eslint.config.mjs",
					"eslint.config.cts",
					"eslint.config.mts",
					"package.json",
				},
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.code_action({
								context = { only = { "source.fixAll.eslint" } },
								apply = true,
							})
						end,
					})
				end,
			}

			-- Lua
			vim.lsp.config.lua_ls = {
				cmd = { "stylua", "-" },
				filetypes = { "lua" },
				root_markers = { ".luarc.json", ".stylua.toml", "stylua.toml", ".git" },
				capabilities = capabilities,
			}

			-- Golang

			-- gopls
			vim.lsp.config.gopls = {
				cmd = { "gopls" },
				filetypes = { "go" },
				root_markers = { "go.mod", "go.sum", ".git" },
				capabilities = capabilities,
			}

			-- golangci-lint
			vim.lsp.config.golangci_lint = {
				cmd = { "golangci-lint-langserver" },
				filetypes = { "go" },
				root_markers = { "go.mod", "go.sum", ".git" },
				capabilities = capabilities,
				init_options = {
					command = {
						"golangci-lint",
						"run",
						"--output.json.path",
						"stdout",
						"--show-stats=false",
						"--issues-exit-code=1",
					},
				},
			}

			-- Enable the LSP servers
			vim.lsp.enable("ts_ls")
			vim.lsp.enable("eslint")
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("gopls")
			vim.lsp.enable("golangci_lint")
		end,
	},
	{ "mbbill/undotree", lazy = true },
	{ "tpope/vim-fugitive", lazy = true },
	{ "mhartington/formatter.nvim" },
	{ "folke/lazydev.nvim", lazy = true, ft = "lua" },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "ayu_mirage", -- 'gruvbox', 'tokyonight', etc.
					globalstatus = true, -- use a single statusline at the bottom for all windows
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = {
						{
							require("lazy.status").updates,
							cond = require("lazy.status").has_updates,
							color = { fg = "#ff9e64" },
						},
						"encoding",
						"fileformat",
						"filetype",
					},
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},
}
