return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua, -- Install stylua Formatter using :Mason command

				-- Ruby
				null_ls.builtins.diagnostics.rubocop, -- Install rubocop Linter using :Mason command
				null_ls.builtins.formatting.rubocop,

				-- Javascript
				require("none-ls.diagnostics.eslint_d"), -- Install Eslint_d Linter using :Mason command
				null_ls.builtins.formatting.prettierd, -- Install Prettier Formatter using :Mason command
			},

			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({
						group = augroup,
						buffer = bufnr,
					})

					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ bufnr = bufnr })
						end,
					})
				end
			end,
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
