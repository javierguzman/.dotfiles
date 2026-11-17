local mason_status, mason = pcall(require, "mason")

if not mason_status then
	return
end

local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
	return
end

local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status then
	return
end



mason.setup()

mason_lspconfig.setup({
	ensure_installed = {
		"ts_ls",
		"html",
		"cssls",
		"tailwindcss",
		"dockerls",
		"eslint",
		"lua_ls",
		"pyright",
		"gopls",
		"rust_analyzer",
		"clangd",
		"elixirls",
		"yamlls",
		"terraformls",
		"ansiblels",
		"marksman",
		"helm_ls",
		"docker_compose_language_service",
		"jsonls",
		"bashls",
	},
	-- lspconfig.lua enables each server explicitly. Automatic enable also starts
	-- servers that are not configured there (for example stylua --lsp, remark_ls).
	automatic_enable = false,
})

mason_null_ls.setup({
	ensure_installed = {
		"prettier",
		"stylua",
		"eslint",
		"ansible-lint",
		"goimports",
		"clang-format",
		"yamllint",
		"markdownlint",
		"hadolint",
		"tflint",
		"golangci-lint",
		"shellcheck",
		"shfmt",
		"actionlint",
	},
})
