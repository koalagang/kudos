require('bufferline').setup {
    options = {
        -- disable close button
        buffer_close_icon = '',

        -- provide LSP diagnostics
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,

        -- TODO: figure out how to add colour as seen in
        -- https://github.com/akinsho/bufferline.nvim?tab=readme-ov-file#underline-indicator
        -- indicator = {
        --     style = "underline",
        -- },
    },
}

local api = vim.api
local o = vim.o

function Update_showbufferline()
    -- get the count of listed buffers
    local buf_count = #vim.fn.getbufinfo({buflisted = 1})
    if buf_count > 1 then
        -- set to 2 when there are multiple buffers
        o.showtabline = 2
    else
        -- set to 1 when there is only one buffer
        o.showtabline = 1
    end
end

-- set up autocommands to trigger on buffer enter and leave events
api.nvim_create_augroup("BufferlineUpdate", { clear = true })
api.nvim_create_autocmd({"BufEnter", "BufLeave"}, {
    group = "BufferlineUpdate",
    callback = Update_showbufferline,
})

-- initial call to set the correct showtabline value on startup
Update_showbufferline()
