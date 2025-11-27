vim.env.LANG = "en_US.UTF-8"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.copilot_assume_mapped = true

vim.loader.enable()

-- Ensure tree-sitter site directory is in runtimepath
vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site")

require("config")
