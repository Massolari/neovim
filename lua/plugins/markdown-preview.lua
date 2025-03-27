return {
  "iamcco/markdown-preview.nvim",
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  keys = {
    { "<leader>em", "<cmd>MarkdownPreview<CR>", desc = "Markdown preview" },
  },
}
