return {
  "gelguy/wilder.nvim",
  event = "CmdlineEnter",
  config = function()
    local wilder = require("wilder")
    wilder.setup({ modes = { ":", "/", "?" } })

    -- Enable Python remote plugin if you want fuzzy matching
    wilder.set_option("pipeline", {
      wilder.branch(
        wilder.cmdline_pipeline({
          fuzzy = 1,
        }),
        wilder.search_pipeline()
      ),
    })

    wilder.set_option(
      "renderer",
      wilder.renderer_mux({
        [":"] = wilder.popupmenu_renderer({
          highlighter = wilder.basic_highlighter(),
          pumblend = 20,
          border = "rounded",
        }),
        ["/"] = wilder.wildmenu_renderer({
          highlighter = wilder.basic_highlighter(),
        }),
      })
    )
  end,
}
