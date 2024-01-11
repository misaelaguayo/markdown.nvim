if vim.fn.has("nvim-0.7.0") ~= 1 then
  vim.api.nvim_err_writeln("markdown-preview.nvim requires Neovim 0.7.0+")
end
