--- @type LazyPluginSpec
return {
  "nvim-mini/mini.nvim",
  verssion = "*",
  config = function()
    require("mini.ai").setup()

    require("mini.files").setup({
      windows = { preview = true },
      mappings = { go_in = "L", go_in_plus = "", go_out = "H", go_out_plus = "", reveal_cwd = "" },
    })
    vim.keymap.set(
      "n",
      "<leader>eF",
      "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>",
      { desc = "Explorador de arquivos (a partir do arquivo atual)" }
    )
    vim.keymap.set("n", "<leader>ef", "<cmd>lua MiniFiles.open()<CR>", { desc = "Explorador de arquivos" })

    require("mini.surround").setup({
      mappings = {
        add = "ys",
        delete = "ds",
        find = ">s",
        find_left = "<s",
        highlight = "!s",
        replace = "cs",
      },
    })
  end,
}
