return {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    event = "VeryLazy",
    keys = {
        {
            "<Esc>",
            function()
                local mc = require("multicursor-nvim")
                if not mc.cursorsEnabled() then
                    mc.clearCursors()
                elseif mc.hasCursors() then
                    mc.clearCursors()
                else
                    -- Default <esc> handler.
                    vim.cmd([[noh]])
                end
            end,
            desc = "Clear cursors",
        },
        -- Add or skip cursor above/below the main cursor.
        {
            "<A-e>",
            function()
                require("multicursor-nvim").lineAddCursor(-1)
            end,
            mode = { "n", "v" },
            desc = "Add cursor above",
        },
        {
            "<A-n>",
            function()
                require("multicursor-nvim").lineAddCursor(1)
            end,
            mode = { "n", "v" },
            desc = "Add cursor below",
        },
        -- Add or skip adding a new cursor by matching word/selection
        {
            "<A-h>",
            function()
                require("multicursor-nvim").matchAddCursor(1)
            end,
            mode = { "n", "v" },
            desc = "Add cursor by match",
        },
        -- Add and remove cursors with control + left click
        {
            "<c-leftmouse>",
            function()
                require("multicursor-nvim").handleMouse()
            end,
            mode = "n",
            desc = "Add/remove cursor with mouse",
        },
    },
    config = function()
        local mc = require("multicursor-nvim")
        mc.setup()
        -- Customize how cursors look
        local hl = vim.api.nvim_set_hl
        hl(0, "MultiCursorCursor", { link = "Cursor" })
        hl(0, "MultiCursorVisual", { link = "Visual" })
        hl(0, "MultiCursorSign", { link = "SignColumn" })
        hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
        hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
        hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
}
