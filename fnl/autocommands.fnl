(require-macros :hibiscus.vim)

(fn recover-position []
  (let [line-position (vim.fn.line "'\"")]
    (when (and (> line-position 1) (<= line-position (vim.fn.line "$")))
      (exec [
        [:exe "\"normal! g`\\\"\""]]))))

(fn map-q-to-close []
  (map! [n :buffer] :q ":close<CR>"))

(augroup! :_general-settings
  [[FileType] [qf help man] 'map-q-to-close]
  [[TextYankPost] * #(vim.highlight.on_yank {:higroup "Search" :timeout 200})]
  [[BufWinEnter] dashboard "setlocal cursorline signcolumn=yes cursorcolumn number"]
  [[FileType] qf #(set! nobuflisted)]
  [[FileType] qf #(map! [n :buffer] :<CR> "<CR>")]
  [[BufReadPost] * 'recover-position]
  [[BufEnter FocusGained InsertLeave] * #(set! relativenumber)]
  [[BufLeave FocusLost InsertEnter]  *  #(set! relativenumber false)])

(augroup! :_git
  [[FileType]  gitcommit  "setlocal wrap"]
  [[FileType]  [gitcommit octo]  "setlocal spell"])

(augroup! :_markdown
  [[FileType]  [markdown txt]  "setlocal wrap spell"])

(augroup! :_auto_resize
  ; will cause split windows to be resized evenly if main window is resized
  [[VimResized]  *  "tabdo wincmd ="])

(augroup! :_dashboard
  ; seems to be nobuflisted that makes my stuff disappear will do more testing
  [[FileType]  dashboard  "setlocal nocursorline noswapfile synmaxcol& signcolumn=no norelativenumber nocursorcolumn nospell  nolist  nonumber bufhidden=wipe colorcolumn= foldcolumn=0 matchpairs= " ]
  [[FileType]  dashboard  #(map! [n :buffer] :q ":q<CR>")])

(augroup! :_coc
  [[FileType]  [typescript json]  "setl formatexpr=CocAction('formatSelected')"]
  [[User]  CocJumpPlaceholder  "call CocActionAsync('showSignatureHelp')"]
  [[CursorHold]  *  "silent call CocActionAsync('highlight')"])

(fn source-file []
  (let [file-name (vim.fn.expand "%:r")
        config-folder (vim.fn.stdpath "config")
        lua-file (.. config-folder "/" (vim.fn.expand "%:p:.:gs?fnl?lua?"))
        source-file
          (if (= file-name "./init")
            (.. config-folder "/lua/tangerine_vimrc.lua")
            lua-file)]
      (exec [[":source " source-file]])
      (print (.. "sourced: " source-file))))

(augroup! :_config
  [[BufWritePost] *.fnl 'source-file])
