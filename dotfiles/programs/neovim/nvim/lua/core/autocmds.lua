local api = vim.api

-- [[ File templates ]]
local templates = api.nvim_create_augroup("templates", { clear = true })
-- shell
api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.sh",
    command = "0r ~/.config/nvim/templates/skeleton.sh | call feedkeys('ji')",
    group = templates,
})
-- latex
api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.tex",
    command = "0r ~/.config/nvim/templates/skeleton.tex | call feedkeys('jjellciw')",
    group = templates,
})
-- nix
api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.nix",
    command = "0r ~/.config/nvim/templates/skeleton.nix | call feedkeys('jA\t')",
    group = templates,
})

-- [[ Formatting ]]
local formatting = api.nvim_create_augroup("formatting", { clear = true })
-- Clean up trailing spaces
api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    command = [[%s/\s\+$//e]],
    group = formatting,
})
-- Remove empty line at end of file
--api.nvim_create_autocmd("BufWritePre", {
--    pattern = "*",
--    command = [[%s#\($\n\s*\)\+\%$##]],
--    group = formatting,
--})
-- prevent autocommenting new lines
api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
    group = formatting,
})
