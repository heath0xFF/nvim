return {
    -- theme
    {
        dir = "~/code/stillwater",
        lazy = false,
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- Enable theme
            vim.cmd.colorscheme "stillwater"
        end,
    },

    -- lsp config
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("configs.lspconfig").defaults()
        end,
    },

    {
        "mason-org/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonUpdate" },
        opts = require "configs.mason",
    },

    -- TODO: consider adding telescope-fzf-native as a dependency for faster fuzzy finding
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        cmd = "Telescope",
        opts = require "configs.telescope",
    },

    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").install(require "configs.treesitter")
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
                callback = function(event)
                    local lang = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
                    -- Parsers can still be installing on the first launch.
                    if lang and vim.treesitter.language.add(lang) then
                        vim.treesitter.start(event.buf, lang)
                    end
                end,
            })
        end,
    },
    {
        "saghen/blink.cmp",
        -- optional: provides snippets for the snippet source
        dependencies = { "rafamadriz/friendly-snippets" },

        -- use a release tag to download pre-built binaries
        version = "1.*",
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            enabled = function()
                local path = vim.fn.expand "%:p"
                if path:match "/root/personal%-notes/" then
                    return false
                end
                return true
            end,
            keymap = { preset = "default" },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            -- (Default) Only show the documentation popup when manually triggered
            completion = { documentation = { auto_show = false } },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "prefer_rust_with_warning" },
        },
        opts_extend = { "sources.default" },
    },
    {
        "stevearc/conform.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = require "configs.conform",
    },

    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = require "configs.lualine",
    },

    {
        "stevearc/oil.nvim",
        opts = {},
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup {
                default_file_explorer = true,
                view_options = {
                    show_hidden = true,
                },
            }
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        opts = require "configs.gitsigns",
    },
}
