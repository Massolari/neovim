return {
  "folke/noice.nvim",
  cond = not vim.g.started_by_firenvim,
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    presets = {
      lsp_doc_border = true,
    },
    lsp = {
      hover = { enabled = true },
      signature = { enabled = true },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
  },
}
