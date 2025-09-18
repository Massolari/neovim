--- @type LazyPluginSpec
return {
  "pimalaya/himalaya-vim",
  dir = "~/himalaya-vim",
  init = function()
    vim.g.himalaya_folder_picker = "fzflua"
  end,
}
