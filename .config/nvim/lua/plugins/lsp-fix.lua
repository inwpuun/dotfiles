return {
    {
        "LazyVim/LazyVim",
        opts = {},
    },

    -- Mason
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },

    -- Mason-lspconfig
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "gopls",
                    "ts_ls",
                    "pyright",
                },
                automatic_installation = true,
            })
        end,
    },

    -- ✅ Only ONE lspconfig block
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")

            -- Lua
            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                    },
                },
            })

            -- TypeScript
            lspconfig.ts_ls.setup({})

            -- Go
            -- lspconfig.gopls.setup({})

            -- Python
            lspconfig.pyright.setup({})

            -- Rust
            lspconfig.rust_analyzer.setup({})
        end,
    },
}
