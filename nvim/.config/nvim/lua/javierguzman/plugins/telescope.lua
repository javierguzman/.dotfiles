
local telescope_setup, telescope = pcall(require, "telescope")

if not telescope_setup then
  return
end

local actions_setup, actions = pcall(require, "telescope.actions")

if not actions_setup then
  return
end


telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
        ["<C-j>"] = actions.move_selection_next, -- move to next result
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
      },
    },
  },
})

telescope.load_extension("fzf")
telescope.load_extension("file_browser")

local builtin = require("telescope.builtin")
local keymap = vim.keymap
keymap.set("n", "<leader>ff", builtin.find_files, {})
keymap.set("n", "<leader>fa", function()
	builtin.find_files({
		find_command = { "rg", "--files", "--hidden", "--no-ignore", "--glob", "!.git" },
	})
end, {}) -- find ALL files, including dotfiles (.env) and gitignored ones, but not .git internals
keymap.set("n", "<leader>fg", builtin.live_grep, {})
keymap.set("n", "<leader>fs", builtin.grep_string, {})
keymap.set("n", "<leader>fb", builtin.buffers, {})
keymap.set("n", "<leader>fh", builtin.help_tags, {})
keymap.set("n", "<leader>fd", builtin.diagnostics, {})
keymap.set("n", "<leader>fe", function()
	telescope.extensions.file_browser.file_browser({
		path = "%:p:h",
		select_buffer = true,
	})
end, {})
