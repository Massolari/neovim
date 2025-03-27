return {
  "echasnovski/mini.files",
  keys = {
    {
      "<leader>eF",
      "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>",
      desc = "Explorador de arquivos (a partir do arquivo atual)",
    },
    { "<leader>ef", "<cmd>lua MiniFiles.open()<CR>", desc = "Explorador de arquivos" },
  },
  opts = {
    windows = { preview = true },
    mappings = { go_in = "L", go_in_plus = "", go_out = "H", go_out_plus = "", reveal_cwd = "" },
  },
  config = true,
  version = false,
}
