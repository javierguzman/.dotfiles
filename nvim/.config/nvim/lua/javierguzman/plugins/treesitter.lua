-- nvim-treesitter (main branch)
-- The main branch only installs parsers and queries. Neovim itself does the
-- highlighting, so a FileType autocommand starts Treesitter for each buffer.
-- Parsers compile with tree-sitter-cli (brew install tree-sitter-cli).
local status, treesitter = pcall(require, "nvim-treesitter")
if not status then
	vim.notify("nvim-treesitter is not available: " .. tostring(treesitter), vim.log.levels.WARN)
	return
end

-- language parsers to install (no-op when a parser is already installed)
local ensure_installed = {
	"json",
	"javascript",
	"typescript",
	"tsx",
	"yaml",
	"html",
	"css",
	"markdown",
	"markdown_inline",
	"python",
	"go",
	"rust",
	"c",
	"cpp",
	"elixir",
	"heex",
	"bash",
	"lua",
	"vim",
	"dockerfile",
	"gitignore",
	"terraform",
	"hcl",
}

treesitter.install(ensure_installed)

local available = {}
for _, lang in ipairs(treesitter.get_available()) do
	available[lang] = true
end

-- start highlighting and indentation for a buffer when its parser is installed
local function attach(bufnr)
	if not pcall(vim.treesitter.start, bufnr) then
		return
	end
	vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(args.match)
		if not lang then
			return
		end

		if not available[lang] or vim.list_contains(treesitter.get_installed(), lang) then
			attach(args.buf)
			return
		end

		-- auto install: install a missing parser, then attach when the install is done
		treesitter.install({ lang }):await(function()
			vim.schedule(function()
				if vim.api.nvim_buf_is_valid(args.buf) then
					attach(args.buf)
				end
			end)
		end)
	end,
})
