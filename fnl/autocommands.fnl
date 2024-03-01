(import-macros {: augroup! : map! : set!} :hibiscus.vim)

(local {: show-info : format} (require :functions))

(fn recover-position []
  (let [mark (vim.api.nvim_buf_get_mark 0 "\"")
        row (. mark 1)]
    (when (and (> row 1) (<= row (vim.api.nvim_buf_line_count 0)))
      (vim.api.nvim_win_set_cursor 0 mark))))

(augroup! :_general-settings ; autocmds gerais
          [[:FileType] [:help :man] #(map! [:n :buffer] :q ":close<CR>")]
          [[:TextYankPost]
           "*"
           #(vim.highlight.on_yank {:higroup :Search :timeout 200})]
          [[:BufReadPost] "*" `recover-position]
          [[:BufEnter :FocusGained :InsertLeave] "*" #(set! :relativenumber)]
          [[:BufLeave :FocusLost :InsertEnter]
           "*"
           #(set! :relativenumber false)])

(augroup! :_markdown [[:FileType] [:markdown :txt] "setlocal spell"])

(augroup! :_auto_resize
          ; will cause split windows to be resized evenly if main window is resized
          [[:VimResized] "*" "tabdo wincmd ="])

(augroup! :_format-on-save [[:BufWritePre] "*" #(format)])

(augroup! :_qutebrowser [[:BufWinEnter]
                         :*qutebrowser-editor*
                         #(set! :filetype :markdown)])

(augroup! :_firenvim
          [[:UIEnter]
           "*"
           (fn []
             (local event (vim.fn.deepcopy vim.v.event))
             (let [client-name (-> (vim.api.nvim_get_chan_info event.chan)
                                   (vim.fn.get :client {})
                                   (vim.fn.get :name ""))
                   is-client-firenvim (= client-name :Firenvim)]
               (when is-client-firenvim
                 (let [cmp (require :cmp)]
                   (cmp.setup {:enabled false})))))])
