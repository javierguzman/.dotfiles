local setup, lualine = pcall(require, "lualine")
if not setup then
	return
end

lualine.setup({
	options = {
		theme = "auto", -- picks up colors from your active colorscheme (nightfly)
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		globalstatus = true, -- single status line for all splits
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { { "filename", path = 1 } }, -- relative path
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})
