(require-macros :hibiscus.vim)

(fn highlight []
  (let [highlight (require :vim.highlight)]
    (highlight.on_yank {:higroup "Search" :timeout 200})))

(fn recover-position []
  (let [line-position (vim.fn.line "'\"")]
    (when (and (> line-position 1) (<= line-position (vim.fn.line "$")))
      (exec [
        [:exe "\"normal! g`\\\"\""]]))))

(fn map-q-to-close []
  (map! [n :buffer] :q ":close<CR>"))

(augroup! :_general-settings
  [[FileType] [qf help man] 'map-q-to-close]
  [[TextYankPost] * 'highlight]
  [[BufWinEnter] dashboard "setlocal cursorline signcolumn=yes cursorcolumn number"]
  [[FileType] qf #(set! nobuflisted)]
  [[FileType] qf #(map! [n :buffer] :<CR> "<CR>")]
  [[BufReadPost] * 'recover-position]
  [[BufEnter FocusGained InsertLeave] * #(set! relativenumber)]
  [[BufLeave FocusLost InsertEnter]  *  #(set! norelativenumber)])

(augroup! :_format-options
  [[BufWinEnter BufRead BufNewFile]  *  "setlocal formatoptions-=c formatoptions-=r formatoptions-=o" ])

(augroup! :_format-save
  [[BufWrite]  *  #(vim.lsp.buf.formatting_sync nil 1000)])

(augroup! :_filetype-changes
  [[BufWinEnter]  .zsh  "setlocal filetype=sh"]
  [[BufRead]  *.zsh  "setlocal filetype=sh"]
  [[BufNewFile]  *.zsh  "setlocal filetype=sh"])

(augroup! :_git
  [[FileType]  gitcommit  "setlocal wrap"]
  [[FileType]  [gitcommit octo]  "setlocal spell"])

(augroup! :_markdown
  [[FileType]  markdown  "setlocal wrap"]
  [[FileType]  markdown  "setlocal spell"])

(augroup! :_auto_resize
  ; will cause split windows to be resized evenly if main window is resized
  [[VimResized]  *  "tabdo wincmd ="])

(augroup! :_general_lsp
  [[FileType]  [lspinfo lsp-installer null-ls-info] 'map-q-to-close])

(augroup! :_dashboard
  ; seems to be nobuflisted that makes my stuff disappear will do more testing
  [[FileType]  dashboard  "setlocal nocursorline noswapfile synmaxcol& signcolumn=no norelativenumber nocursorcolumn nospell  nolist  nonumber bufhidden=wipe colorcolumn= foldcolumn=0 matchpairs= " ]
  [[FileType]  dashboard  #(map! [n :buffer] :q ":q<CR>")])

(augroup! :_coc
  [[FileType]  [typescript json]  "setl formatexpr=CocAction('formatSelected')"]
  [[User]  CocJumpPlaceholder  "call CocActionAsync('showSignatureHelp')"]
  [[CursorHold]  *  "silent call CocActionAsync('highlight')"])
