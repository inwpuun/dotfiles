return {
    "nvim-lualine/lualine.nvim",
    opts = {
        options = {
            component_separators = { left = "", right = "" },
            theme = "dracula",
        },
        sections = {
            lualine_c = {
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic", "coc" },
                    colored = true, -- Displays diagnostics status in color if set to true.
                    update_in_insert = true, -- Update diagnostics in insert mode.
                },
                {
                    "filename",
                    path = 1, -- show relative path (e.g., src/app/instructor/page.tsx)
                    file_status = true, -- Displays file status (readonly status, modified status)
                    newfile_status = false, -- Display new file status (new file means no write after created)
                    symbols = {
                        modified = "[+]", -- Text to show when the file is modified.
                        readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
                        unnamed = "[No Name]", -- Text to show for unnamed buffers.
                        newfile = "[New]", -- Text to show for newly created file before first write
                    },
                },
            },
            --     lualine_x = {
            --         {
            --             "diagnostics",
            --             sources = { "nvim_diagnostic" },
            --             symbols = { error = "E ", warn = "W ", info = "I ", hint = "H " },
            --         },
            --     },
        },
    },
}
