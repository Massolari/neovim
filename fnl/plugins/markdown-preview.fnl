{1 :iamcco/markdown-preview.nvim
 :build #(vim.fn.mkdp#util#install)
 :ft :markdown
 :keys [{1 :<leader>em 2 :<cmd>MarkdownPreview<CR> :desc "Markdown preview"}]}
