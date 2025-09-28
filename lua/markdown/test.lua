vim.cmd('rightbelow vnew')

local win = vim.api.nvim_get_current_win()
local buf = vim.api.nvim_create_buf(false, true)

vim.api.nvim_buf_set_option(buf, "readonly", true)
vim.api.nvim_buf_set_option(buf, "modifiable", false)
vim.api.nvim_win_set_buf(win, buf)
