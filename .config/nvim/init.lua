-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#6ab8ff", bold = true })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#ff6188", bold = true })
