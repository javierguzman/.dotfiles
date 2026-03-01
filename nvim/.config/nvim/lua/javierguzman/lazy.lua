-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- colorscheme (loaded first)
	{
		"bluz71/vim-nightfly-guicolors",
		priority = 1000,
		config = function()
			vim.cmd("colorscheme nightfly")
		end,
	},

	-- core utilities
	"nvim-lua/plenary.nvim",
	"christoomey/vim-tmux-navigator",
	"tpope/vim-surround",
	"tpope/vim-fugitive",
	"nvim-tree/nvim-web-devicons",

	-- file explorer
	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("javierguzman.plugins.nvim-tree")
		end,
	},

	-- commenting
	{
		"numToStr/Comment.nvim",
		event = "BufReadPre",
		config = function()
			require("javierguzman.plugins.comment")
		end,
	},

	-- autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("javierguzman.plugins.autopairs")
		end,
	},
	{ "windwp/nvim-ts-autotag" },

	-- telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			require("javierguzman.plugins.telescope")
		end,
	},

	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("javierguzman.plugins.treesitter")
		end,
	},

	-- completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
			"saadparwaiz1/cmp_luasnip",
			{
				"L3MON4D3/LuaSnip",
				dependencies = "rafamadriz/friendly-snippets",
			},
			"onsails/lspkind.nvim",
		},
		config = function()
			require("javierguzman.plugins.nvim-cmp")
		end,
	},

	-- lsp
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			{ "nvimdev/lspsaga.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
			"pmizio/typescript-tools.nvim",
			"onsails/lspkind.nvim",
		},
		config = function()
			require("javierguzman.plugins.lsp.mason")
			require("javierguzman.plugins.lsp.lspsaga")
			require("javierguzman.plugins.lsp.lspconfig")
		end,
	},

	-- formatting & linting
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"jay-babu/mason-null-ls.nvim",
		},
		config = function()
			require("javierguzman.plugins.lsp.null-ls")
		end,
	},

	-- ai chat assistant
	{
		"olimorris/codecompanion.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			adapters = {
				anthropic = function()
					return require("codecompanion.adapters").extend("anthropic", {
						env = { api_key = "ANTHROPIC_API_KEY" },
						schema = {
							model = { default = "claude-sonnet-4-20250514" },
							max_tokens = { default = 16000 },
						},
					})
				end,
			},
			strategies = {
				chat = { adapter = "anthropic" },
				inline = { adapter = "anthropic" },
			},
		},
		keys = {
			{ "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle AI chat" },
			{ "<leader>ae", "<cmd>CodeCompanion<cr>",           mode = { "n", "v" }, desc = "Inline AI edit" },
			{ "<leader>ap", "<cmd>CodeCompanionActions<cr>",    mode = { "n", "v" }, desc = "AI action palette" },
			{ "<leader>ac", "<cmd>CodeCompanionChat Add<cr>",   mode = "v",          desc = "Add selection to chat" },
		},
	},

	-- markdown rendering
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		ft = { "markdown" },
		opts = {},
	},

	-- kubernetes
	{
		"ramilito/kubectl.nvim",
		config = function()
			require("kubectl").setup()
		end,
		keys = {
			{ "<leader>k", "<cmd>lua require('kubectl').toggle()<cr>", desc = "kubectl" },
		},
	},

	-- lazygit
	{
		"kdheepak/lazygit.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},

	-- git
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("javierguzman.plugins.gitsigns")
		end,
	},
})
