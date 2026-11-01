local ok, err = pcall(function()
    local plugins = require("lazy.core.config").plugins
    assert(not plugins["zen-mode.nvim"])
    assert(not plugins["mason-lspconfig.nvim"])
    assert(vim.fn.maparg("<leader>zz", "n") == "")
    assert(plugins["nvim-treesitter"].lazy == false)

    for _, module in ipairs { "telescope", "oil", "blink.cmp", "gitsigns", "lualine" } do
        assert(require(module))
    end
    for _, command in ipairs { "lua-language-server", "pyright-langserver", "stylua", "prettier" } do
        assert(vim.fn.executable(command) == 1, "Missing tool: " .. command)
    end
    local settings = vim.lsp.config.pyright.settings
    assert(settings.python.analysis.typeCheckingMode == "off")
    assert(settings.basedpyright == nil)
    assert(vim.lsp.is_enabled "lua_ls" and vim.lsp.is_enabled "pyright")

    local conform = require "conform"
    assert(conform.get_formatter_info("stylua").available)
    assert(conform.get_formatter_info("prettier").available)
    assert(not require("configs.conform").formatters)

    -- Keep this check independent of language-server startup time.
    vim.lsp.enable({ "lua_ls", "pyright" }, false)
    for _, lang in ipairs(require "configs.treesitter") do
        assert(vim.treesitter.language.add(lang), "Missing parser: " .. lang)
        local buf = vim.api.nvim_create_buf(true, false)
        vim.api.nvim_set_current_buf(buf)
        vim.bo[buf].filetype = lang
        assert(vim.treesitter.highlighter.active[buf], "Highlighting inactive: " .. lang)
        vim.api.nvim_buf_delete(buf, { force = true })
    end

    local buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_set_current_buf(buf)
    vim.bo[buf].filetype = "no_parser_test"
    assert(not vim.treesitter.highlighter.active[buf])
    vim.api.nvim_buf_delete(buf, { force = true })
end)

if not ok then
    io.stderr:write(tostring(err) .. "\n")
    vim.cmd "cquit 1"
else
    print "Plugin smoke checks passed"
    vim.cmd "qa!"
end
