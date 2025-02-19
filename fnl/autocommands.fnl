(fn recover-position []
  (let [mark (vim.api.nvim_buf_get_mark 0 "\"")
        row (. mark 1)]
    (when (and (> row 1) (<= row (vim.api.nvim_buf_line_count 0)))
      (vim.api.nvim_win_set_cursor 0 mark))))

(let [group (vim.api.nvim_create_augroup :_general-settings {})] ; autocmds gerais
  (vim.api.nvim_create_autocmd [:FileType]
                               {:pattern [:help :man]
                                :callback #(vim.keymap.set :n :q ":close<CR>"
                                                           {:buffer true})
                                : group})
  (vim.api.nvim_create_autocmd [:TextYankPost]
                               {:pattern "*"
                                :callback #(vim.highlight.on_yank {:higroup :Search
                                                                   :timeout 200})
                                : group})
  (vim.api.nvim_create_autocmd [:BufReadPost]
                               {:pattern "*"
                                :callback #(recover-position)
                                : group})
  (vim.api.nvim_create_autocmd [:BufEnter :FocusGained :InsertLeave]
                               {:pattern "*"
                                :callback #(set vim.opt.relativenumber true)
                                : group})
  (vim.api.nvim_create_autocmd [:BufLeave :FocusLost :InsertEnter]
                               {:pattern "*"
                                :callback #(set vim.opt.relativenumber false)
                                : group}))

(vim.api.nvim_create_autocmd [:FileType]
                             {:pattern [:markdown :txt]
                              :callback #(set vim.opt_local.spell true)
                              :group (vim.api.nvim_create_augroup :_markdown {})})

(vim.api.nvim_create_autocmd [:VimResized]
                             {:pattern "*"
                              :command "tabdo wincmd ="
                              :group (vim.api.nvim_create_augroup :_auto_resize
                                                                  {})})

(vim.api.nvim_create_autocmd :User
                             {:pattern :MiniFilesActionRename
                              :callback (fn [event]
                                          (_G.Snacks.rename.on_rename_file event.data.from
                                                                           event.data.to))})

