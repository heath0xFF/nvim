local M = {}
local map = vim.keymap.set

-- Attach keymaps
M.on_attach = function(client, bufnr)
    local opts = { buffer = bufnr }

    map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
    map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    map("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
    map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
    map("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
    -- TODO: consider adding diagnostic navigation mappings: [d / ]d (vim.diagnostic.goto_prev/next)
    map("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    map({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
    map("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
end

-- Let Tree-sitter control syntax highlighting.
M.on_init = function(client, _)
    client.server_capabilities.semanticTokensProvider = nil
end

-- Capabilities
M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    },
}

-- Setup LSPs
M.defaults = function()
    local servers = {
        lua_ls = {
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    workspace = { checkThirdParty = false },
                },
            },
        },
        pyright = {
            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "off",
                        diagnosticMode = "openFilesOnly",
                        autoSearchPaths = false,
                        useLibraryCodeForTypes = false,
                        stubPath = "typings",
                        diagnosticSeverityOverrides = {
                            reportGeneralTypeIssues = "none",
                            reportMissingTypeStubs = "none",
                            reportOptionalSubscript = "none",
                            reportUnknownArgumentType = "none",
                            reportUnknownMemberType = "none",
                            reportUnknownParameterType = "none",
                            reportUnknownVariableType = "none",
                        },
                    },
                },
            },
        },
        -- Add more servers and custom overrides here
    }

    local server_names = {}
    for name, config in pairs(servers) do
        config.on_attach = M.on_attach
        config.capabilities = M.capabilities
        config.on_init = M.on_init
        vim.lsp.config(name, config)
        table.insert(server_names, name)
    end
    vim.lsp.enable(server_names)
end

return M
