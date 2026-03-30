--- @type LazyPluginSpec
return {

  "igorlfs/nvim-dap-view",
  -- let the plugin lazy load itself
  lazy = false,
  ---@module 'dap-view'
  ---@type dapview.Config
  opts = {
    winbar = { default_section = "scopes" },
    windows = { position = "right" },
  },
}
