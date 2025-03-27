return {
  "mg979/vim-visual-multi",
  branch = "master",
  keys = { { "<c-g>", mode = { "x", "n" } }, "<c-t>", "<M-g>", { "g/", mode = "x" } },
  init = function()
    vim.g.VM_maps = {
      ["Find Under"] = "<C-t>",
      ["Find Subword Under"] = "<C-t>",
      ["Add Cursor Down"] = "<C-g>",
      ["Add Cursor Up"] = "<M-g>",
      ["Goto Next"] = "g)",
      ["Goto Prev"] = "g(",
      ["Visual Regex"] = "g/",
      ["Visual Cursors"] = "<c-g>",
      ["Remove Region"] = "<c-,>",
    }
  end,
}
