-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

local keymap = vim.keymap

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }

	keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
	keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- go to declaration
	keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
	keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
	keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
	keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
	keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show diagnostics for line
	keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
	keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
	keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
	keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
	keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side
	keymap.set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts) -- show function signature/parameters
	keymap.set("i", "<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts) -- same, but in insert mode - <C-k> is already used by nvim-cmp there

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
local signs = { Error = "✘ ", Warn = " ", Hint = "† ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Servers with default config (no extra settings needed)
local simple_servers = {
	"html",
	"cssls",
	"tailwindcss",
	"gopls",
	"rust_analyzer",
	"clangd",
	"elixirls",
	"terraformls",
	"marksman",
	"eslint",
}

for _, server in ipairs(simple_servers) do
	vim.lsp.config(server, {
		capabilities = capabilities,
		on_attach = on_attach,
	})
end
vim.lsp.enable(simple_servers)

-- configure typescript server
local typescript_tools_ok, typescript_tools = pcall(require, "typescript-tools")
if typescript_tools_ok then
	typescript_tools.setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})
end

-- configure emmet language server
vim.lsp.config("emmet_ls", {
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
vim.lsp.enable("emmet_ls")

-- configure pyright
vim.lsp.config("pyright", {
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
vim.lsp.enable("pyright")

-- configure yaml server with kubernetes schema
vim.lsp.config("yamlls", {
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
vim.lsp.enable("yamlls")

-- configure ansible server
vim.lsp.config("ansiblels", {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		ansible = {
			ansible = { useFullyQualifiedCollectionNames = true },
			validation = { enabled = true, lint = { enabled = true } },
		},
	},
})
vim.lsp.enable("ansiblels")

-- configure lua server (with special settings)
vim.lsp.config("lua_ls", {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})
vim.lsp.enable("lua_ls")
