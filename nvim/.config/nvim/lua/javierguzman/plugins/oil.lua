local setup, oil = pcall(require, "oil")
if not setup then
	return
end

oil.setup({
	columns = { "icon" },
	view_options = {
		show_hidden = true,
	},
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
