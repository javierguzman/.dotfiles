local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
  return
end

-- recommended settings from nvim tree github
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- blue folders
vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = "#82aaff" })
vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = "#82aaff" })
vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = "#82aaff", bold = true })
vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderName", { fg = "#82aaff" })

nvimtree.setup({
  -- disable window_picker for explorer to work well with window splits
  actions = {
    open_file = {
      window_picker = {
        enable = false,
      },
    },
  },

  -- show dotfiles and gitignored files (e.g. google-services.json)
  filters = {
    dotfiles = false,
    git_ignored = false,
  },

  renderer = {
    highlight_git = true,           -- color files by git status (red=modified, green=new, etc.)
    highlight_opened_files = "name", -- highlight name of currently open files
    indent_markers = {
      enable = true,
    },
    icons = {
      show = {
        folder_arrow = true,
      },
    },
  },
})
