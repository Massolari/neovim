(λ fs-find [file]
  (vim.fs.find file
               {:upward true
                :path (vim.fs.dirname (vim.api.nvim_buf_get_name 0))}))

(fn tsc-autocmd []
  (vim.api.nvim_create_autocmd [:FileType]
                               {:pattern [:typescript :typescriptreact]
                                :callback #(let [package_json_path (fs-find :package.json)]
                                             (match package_json_path
                                               [path] (let [project_root (vim.fs.dirname path)]
                                                        (set vim.b.dispatch
                                                             (.. project_root
                                                                 "/node_modules/typescript/bin/tsc --noEmit --watch --project "
                                                                 project_root
                                                                 :/tsconfig.json)))
                                               _ (set vim.b.dispatch "bun %")))}))

{1 :tpope/vim-dispatch
 :lazy false
 :init (fn []
         (set vim.g.dispatch_no_maps 1))
 :config (fn []
           (tsc-autocmd))}
