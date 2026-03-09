--- @type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function(args)
        local parsers = require("nvim-treesitter.parsers")
        local parser = vim.treesitter.language.get_lang(args.match)
        if not parsers or not parsers[parser] then
          return
        end
        require("nvim-treesitter").install({ parser }):wait(5 * 60 * 1000) -- max. 5 minutes
        local ok, _ = pcall(vim.treesitter.start, args.buf, parser)
        if not ok then
          return
        end
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[0][0].foldmethod = "expr"
      end,
    })
  end,
}
