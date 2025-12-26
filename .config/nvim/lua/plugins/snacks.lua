-- lazy.nvim
return {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
        dashboard = { enabled = true },
        explorer = { enabled = true },
        picker = {
            sources = {
                explorer = {
                    -- your explorer picker configuration comes here
                    -- or leave it empty to use the default settings
                    layout = {
                        layout = {
                            position = "right",
                        },
                    },
                },
            },
            formatters = {
                file = {
                    filename_first = true, -- display filename before the file path
                    truncate = 999,
                    git_status_hl = true,
                },
                severity = {
                    icons = true, -- show severity icons
                    level = true, -- show severity level
                    ---@type "left"|"right"
                    pos = "left", -- position of the diagnostics
                },
            },
        },
    },
}
