local M = {}

local api = require("image")
local Job = require("plenary.job")

local function display_image(path)
    vim.cmd('rightbelow vsplit')
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_get_current_buf()
    local image = api.from_file(path, {
        window = win,
        buf = buf,
    })
    image:render()

    vim.defer_fn(function()
        image:clear()
    end, 5000)
end

local converter_bin = "./target/release/converter"
local exit_code = 0

function M.setup(opts)
    opts = opts or {}

    vim.keymap.set("n", '<leader>H', function()
        local source = "output.png"
        local markdown_file = vim.api.nvim_buf_get_name(0)

        Job:new({
            command = converter_bin,
            args = { markdown_file, source },
            on_exit = function(j, return_val)
                exit_code = return_val
            end,
        }):sync()

        if exit_code == 0 then
            display_image(source)
        else
            print("Error generating image")
        end
    end)
end

return M
