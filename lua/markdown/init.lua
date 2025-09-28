local M = {}

local api = require("image")
local Job = require("plenary.job")

local function display_image(path)
    vim.cmd('rightbelow vnew')

    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_option(buf, "readonly", true)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_win_set_buf(win, buf)

    local image = api.from_file(path, {
        window = win,
        buf = buf,
    })

    image:render()
end

local exit_code = 0

function M.setup(opts)
    opts = opts or {}

    local converter_bin = opts.converter_bin or vim.fn.stdpath('data') .. '/lazy/markdown.nvim/target/release/converter'

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
