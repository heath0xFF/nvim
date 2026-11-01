return {
    formatters_by_ft = {
        lua = { "stylua" },
        json = { "prettier" },
        css = { "prettier" },
        javascript = { "prettier" },
    },

    format_on_save = {
        timeout_ms = 500,
        lsp_fallback = false,
    },
}
