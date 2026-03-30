local functions = require("functions")

functions.on_pack_changed("markdown-preview.nvim", function(_)
  vim.fn["mkdp#util#install"]()
end)

vim.pack.add({ "https://github.com/iamcco/markdown-preview.nvim" })

vim.keymap.set("n", "<leader>em", "<cmd>MarkdownPreview<CR>", { desc = "Markdown preview" })
