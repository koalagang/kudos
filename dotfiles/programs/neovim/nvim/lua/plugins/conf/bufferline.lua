local bufferline = require('bufferline')
local api = vim.api

bufferline.setup {
    options = {
        buffer_close_icon = '', -- disable close button
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
    }
}

-- hide bufferline by default
vim.go.showtabline = 1

-- hide bufferline when only one buffer is open
-- but show it when there are multiple
local toggleBufferline = api.nvim_create_augroup("toggleBufferline", { clear = true })
api.nvim_create_autocmd("BufDelete", {
    command = "if len(getbufinfo({'buflisted':1})) -1 < 2 | set showtabline=1 | endif",
    group = toggleBufferline,
})
api.nvim_create_autocmd("BufAdd", {
    command = "if len(getbufinfo({'buflisted':1})) > 1 | set showtabline=2 | endif",
    group = toggleBufferline,
})
