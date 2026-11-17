local opt = vim.opt

-- line numbers
opt.scrolloff=8
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- line wrapping
opt.wrap = false

opt.ignorecase = true
opt.smartcase = true

-- cursor line
opt.cursorline = true

--appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

--backspace
opt.backspace = "indent,eol,start"

--clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append("-")

-- helm: files under templates/ use the helm filetype when a Chart.yaml exists in a parent dir
vim.filetype.add({
	pattern = {
		[".*/templates/.*%.ya?ml"] = function(path)
			if vim.fs.find("Chart.yaml", { path = vim.fs.dirname(path), upward = true })[1] then
				return "helm"
			end
		end,
		[".*/templates/.*%.tpl"] = function(path)
			if vim.fs.find("Chart.yaml", { path = vim.fs.dirname(path), upward = true })[1] then
				return "helm"
			end
		end,
	},
})

-- docker compose: docker_compose_language_service attaches only to the yaml.docker-compose filetype
vim.filetype.add({
	filename = {
		["docker-compose.yml"] = "yaml.docker-compose",
		["docker-compose.yaml"] = "yaml.docker-compose",
		["compose.yml"] = "yaml.docker-compose",
		["compose.yaml"] = "yaml.docker-compose",
	},
})
