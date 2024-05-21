local M = {}

local utils = require("chafa")

function M.setup(opts)
    opts = opts or {}

    vim.keymap.set("n", "<leader>H", function ()
        -- call markdown preview and open in vertical split
        -- vim.fn.system('markdown preview blahu')
        local buf_id = 0
        local buf_path = vim.api.nvim_buf_get_name(buf_id)
        vim.cmd('vsp README')
        -- if opts.name then
        --     print("Hello " .. opts.name)
        -- else
        --     print("Hello World")
        -- end
    end)
end

return M
