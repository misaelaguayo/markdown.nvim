local M = {}

function M.setup(opts)
    opts = opts or {}

    vim.keymap.set("n", "<leader>H", function ()
        -- call markdown preview and open in vertical split
        local buf_id = 0
        local buf_path = vim.api.nvim_buf_get_name(buf_id)
        local markdown_preview_path = "markdown"
        if opts.markdown_preview_path then
            markdown_preview_path = opts.markdown_preview_path
        end
        vim.fn.system(markdown_preview_path .. ' ' .. buf_path)
        local err = vim.v.shell_error
        if err == 0 then
            vim.cmd('vsp sixel/sixel.jpeg')
        end
    end)
end

return M
