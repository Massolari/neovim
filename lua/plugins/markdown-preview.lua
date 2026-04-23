vim.pack.add({
  {
    src = "https://github.com/iamcco/markdown-preview.nvim",
    data = {
      build = {
        run = function(_)
          vim.fn["mkdp#util#install"]()
        end,
      },
    },
  },
})

vim.keymap.set("n", "<leader>em", "<cmd>MarkdownPreview<CR>", { desc = "Markdown preview" })
