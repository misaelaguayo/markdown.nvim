local M = {}

function M.setup(opts)
    opts = opts or {}

    vim.keymap.set("n", "<leader>H", function ()
        -- call markdown preview and open in vertical split
        -- vim.fn.system('markdown preview blahu')
        vim.cmd('vsp check')
        if opts.name then
            print("Hello " .. opts.name)
        else
            print("Hello World")
        end
    end)
end

return M
