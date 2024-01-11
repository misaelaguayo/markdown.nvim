local M = {}

function M.setup(opts)
    opts = opts or {}

    vim.keymap.set("n", "<leader>H", function ()
        if opts.name then
            print("Hello " .. opts.name)
        else
            print("Hello World")
        end
    end)
end

return M
