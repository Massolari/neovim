(local {: require-and} (require :functions))

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
 :keys [{1 :zR 2 #(require-and :ufo #($.openAllFolds))}
        {1 :zM 2 #(require-and :ufo #($.closeAllFolds))}
        {1 :zr 2 #(require-and :ufo #($.openFoldsExceptKinds))}
        {1 :zm 2 #(require-and :ufo #($.closeFoldsWith))}]
 :opts {:provider_selector (fn [] [:treesitter :indent])}
 :config true}
