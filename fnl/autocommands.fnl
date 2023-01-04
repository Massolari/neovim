(import-macros {: augroup! : map! : exec : set!} :hibiscus.vim)

(local {: show-info} (require :functions))

(fn recover-position []
  (let [line-position (vim.fn.line "'\"")]
    (when (and (> line-position 1) (<= line-position (vim.fn.line "$")))
      (vim.cmd.exec "\"normal! g`\\\"\""))))

(fn map-q-to-close []
  (map! [:n :buffer] :q ":close<CR>"))

(augroup! :_general-settings ; autocmds gerais
          [[FileType] [qf help man] `map-q-to-close]
          [[TextYankPost]
           *
           #(vim.highlight.on_yank {:higroup :Search :timeout 200})]
          ;; [[FileType] dashboard #(print :Hello)]
          ;; "setlocal nocursorline signcolumn=no nocursorcolumn nonumber norelativenumber"]
          ;; (fn []
          ;;   (print :Here!))] ;
          [[FileType]
           qf
           (fn []
             (set! nobuflisted)
             (map! [n :buffer] :<CR> :<CR>))]
          [[BufReadPost] * `recover-position]
          [[BufEnter FocusGained InsertLeave] * #(set! relativenumber)]
          [[BufLeave FocusLost InsertEnter] * #(set! relativenumber false)])

(augroup! :_git ; autocmd para arquivos do git
          [[FileType] gitcommit "setlocal wrap"]
          [[FileType] [gitcommit octo] "setlocal spell"])

(augroup! :_markdown [[FileType] [markdown txt] "setlocal wrap spell"])

(augroup! :_auto_resize
          ; will cause split windows to be resized evenly if main window is resized
          [[VimResized] * "tabdo wincmd ="])

(fn source-file []
  (let [file-name (vim.fn.expand "%:r")
        config-folder (vim.fn.stdpath :config)
        lua-file (.. config-folder "/" (vim.fn.expand "%:p:.:gs?fnl?lua?"))
        source-file (if (= file-name :init)
                        (.. config-folder :/lua/tangerine_vimrc.lua)
                        lua-file)]
    (vim.cmd.source source-file)
    (show-info (.. "sourced: " source-file) :Source)))

(augroup! :_highlight_end_spaces
          ; Destacar espaços em branco no final do arquivo
          [[WinEnter] * #(vim.fn.matchadd :EndSpace "\\s\\+$")])

(augroup! :_config ;autocmd para arquivos de configuração fennel
          [[BufWritePost] *.fnl `source-file])

(augroup! :_qutebrowser [[BufWinEnter]
                         *qutebrowser-editor*
                         #(set! filetype :markdown)])

(augroup! :nvim_ghost_user_autocommands
          [[User] *.com* #(set! filetype :markdown)])

(augroup! :_firenvim
          [[UIEnter]
           *
           (fn []
             (local event (vim.fn.deepcopy vim.v.event))
             (let [client-name (-> (vim.api.nvim_get_chan_info event.chan)
                                   (vim.fn.get :client {})
                                   (vim.fn.get :name ""))
                   is-client-firenvim (= client-name :Firenvim)]
               (when is-client-firenvim
                 (let [cmp (require :cmp)]
                   (cmp.setup {:enabled false})))))])
