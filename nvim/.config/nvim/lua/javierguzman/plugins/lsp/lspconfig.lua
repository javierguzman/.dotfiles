-- import lspconfig plugin safely
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end


local keymap = vim.keymap -- for conciseness

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
	-- keybind options
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- set keybinds
	keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
	keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
	keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
	keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
	keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
	keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
	keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
	keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
	keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
	keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
	keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
	keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side

	-- typescript specific keymaps
	if client.name == "typescript-tools" then
		keymap.set("n", "<leader>rf", ":TSToolsRenameFile<CR>")
		keymap.set("n", "<leader>oi", ":TSToolsOrganizeImports<CR>")
		keymap.set("n", "<leader>ru", ":TSToolsRemoveUnusedImports<CR>")
	end
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = "✘ ", Warn = " ", Hint = "† ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- configure html server
lspconfig["html"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure typescript server
local typescript_tools_ok, typescript_tools = pcall(require, "typescript-tools")
if typescript_tools_ok then
	typescript_tools.setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})
end

-- configure css server
lspconfig["cssls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure tailwindcss server
lspconfig["tailwindcss"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure pyright
lspconfig["pyright"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "off",
			},
		},
	},
})

-- configure emmet language server
lspconfig["emmet_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = {
		"html",
		"typescript",
		"javascript",
		"typescript.tsx",
		"javascript.jsx",
		"typescriptreact",
		"javascriptreact",
		"css",
		"sass",
		"scss",
		"less",
		"svelte",
	},
})

-- configure go server
lspconfig["gopls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure rust server
lspconfig["rust_analyzer"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure c/c++ server
lspconfig["clangd"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure yaml server with kubernetes schema
lspconfig["yamlls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		yaml = {
			schemas = {
				["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.29.0-standalone-strict/all.json"] = {
					"**/k8s/**/*.yaml",
					"**/kubernetes/**/*.yaml",
					"**/manifests/**/*.yaml",
					"**/helm/**/*.yaml",
				},
			},
			validate = true,
			completion = true,
			hover = true,
		},
	},
})

-- configure elixir server
lspconfig["elixirls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure terraform server
lspconfig["terraformls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure ansible server
lspconfig["ansiblels"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		ansible = {
			ansible = { useFullyQualifiedCollectionNames = true },
			validation = { enabled = true, lint = { enabled = true } },
		},
	},
})

-- configure markdown server
lspconfig["marksman"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure lua server (with special settings)
lspconfig["lua_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = { -- custom settings for lua
		Lua = {
			-- make the language server recognize "vim" global
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- make language server aware of runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})
