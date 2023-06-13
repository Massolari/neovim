(local {: requireAnd} (require :functions))

{1 :kevinhwang91/nvim-ufo
 :dependencies [:kevinhwang91/promise-async]
 :event :BufReadPost
 :init (fn []
         (set vim.o.fillchars
              "eob: ,fold: ,foldopen:,foldsep: ,foldclose:")
         (set vim.o.foldcolumn :1)
         (set vim.o.foldlevel 99)
         (set vim.o.foldlevelstart 99)
         (set vim.o.foldenable true))
 :keys [{1 :zR 2 #(requireAnd :ufo #($.openAllFolds))}
        {1 :zM 2 #(requireAnd :ufo #($.closeAllFolds))}
        {1 :zr 2 #(requireAnd :ufo #($.openFoldsExceptKinds))}
        {1 :zm 2 #(requireAnd :ufo #($.closeFoldsWith))}]
 :opts {:provider_selector (fn [] [:treesitter :indent])}
 :config true}
