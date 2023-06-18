vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>")
-- windows management
keymap.set("n", "<leader>sv", "<C-w>v")
keymap.set("n", "<leader>sh", "<C-w>s")
keymap.set("n", "<leader>se", "<C-w>=")
keymap.set("n", "<leader>sx", ":close<CR>")

-- tab management
keymap.set("n", "<leader>to", ":tabnew<CR>")
keymap.set("n", "<leader>tx", ":tabclose<CR>")
keymap.set("n", "<leader>tn", ":tabn<CR>")
keymap.set("n", "<leader>tp", ":tabp<CR>")
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>")

--zoom
keymap.set("n", "<C-+", "<ZoomIn>")
keymap.set("n", "<C--", "<ZoomOut>")

--nvimtree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- telescope
local builtin = require("telescope.builtin")

keymap.set("n", "<leader>ff", builtin.find_files, {})
keymap.set("n", "<leader>fg", builtin.live_grep, {})
keymap.set("n", "<leader>fs", builtin.grep_string, {})
keymap.set("n", "<leader>fb", builtin.buffers, {})
keymap.set("n", "<leader>fh", builtin.help_tags, {})
keymap.set("n", "<leader>fd", builtin.diagnostics, {})

-- handy stuff; copy and paste in next line directly
keymap.set("n", "<leader>m", "o<ESC>P<CR>")
-- paste and keep register value
keymap.set("v", "<leader>p", '"_dP')

-- copies without losing reg
keymap.set("v", "<leader>y", '"+y')
keymap.set("n", "<leader>y", '"+y')

--move hightlighted selection up and down
keymap.set("v", "J", ":m'>+1<CR>gv=gv")
keymap.set("v", "K", ":m'<-2<CR>gv=gv")

--our fzf
keymap.set("n", "<leader>z", ":silent !tmux neww tmux-sessionizer<CR>")

-- make it executable
keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
