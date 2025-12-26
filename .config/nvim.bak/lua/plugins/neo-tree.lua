return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    open_on_setup = false,
    open_on_setup_file = false,
    filesystem = {
      hijack_netrw_behavior = "disabled", -- prevent it from auto-opening
    },
  },
}
