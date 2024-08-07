local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    return
end

local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

local config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {
        active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
}

vim.diagnostic.config(config)

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
})

require("plugins.conf.lsp.keymaps")

local on_attach = function(_)
    if _.name == "lua_ls" then
        _.server_capabilities.documentFormattingProvider = false
    --elseif _.name == "rust_analyzer" then
    --    _.server_capabilities.documentFormattingProvider = false
    end
    lsp_keymaps()
end

-- nvim-cmp supports additional completion capabilities
--local capabilities = require("cmp_nvim_lsp").default_capabilities()

--local servers = { "texlab", "lua_ls", "rnix", "taplo", "rust_analyzer" }
--local servers = { "texlab", "lua_ls", "rnix", "taplo" }
-- I've temporarily disabled rnix because it depends on nix 2.15.3, which is affected by CVE-2024-27297
local servers = { "texlab", "lua_ls", "taplo" }

-- Ensure the servers above are installed
for _, lsp in ipairs(servers) do
    require("lspconfig")[lsp].setup({
        on_attach = on_attach,
        --capabilities = capabilities,
    })
end

-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require("lspconfig").lua_ls.setup({
    on_attach = on_attach,
    --capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT)
                version = "LuaJIT",
                -- Setup your lua path
                path = runtime_path,
            },
            diagnostics = {
                globals = { "vim" },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                vim.env.VIMRUNTIME,
                -- Depending on the usage, you might want to add additional paths here.
                "${3rd}/luv/library",
                -- "${3rd}/busted/library",
                },
            },
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
            -- library = vim.api.nvim_get_runtime_file("", true)
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false },
        },
    },
})
