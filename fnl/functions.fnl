(require-macros :hibiscus.vim)

(local Terminal (. (require :toggleterm.terminal) "Terminal"))
(local M {})

(fn is-location-quickfix-open? [window]
  (let [query (if (= window "quickfix") "v:val.quickfix && !v:val.loclist" "!v:val.quickfix && v:val.loclist")
        windows (vim.fn.getwininfo)
        wanted-windows (vim.fn.filter windows query)]
    (> (vim.fn.len wanted-windows) 0)))

(set M.toggle-quickfix
  (fn []
    (let [is-open? (is-location-quickfix-open? "quickfix")]
      (if is-open?
        (exec [[:cclose]])
        (exec [[:botright "copen 10"]])))))


(set M.toggle-location-list
  (fn []
    (let [is-open? (is-location-quickfix-open? "location")]
      (if is-open?
        (exec [[:lclose]])
        (let [(status err) (pcall vim.cmd ":lopen 10")]
          (when (not status)
            (print err)))))))

(set M.command-with-args
  (fn [prompt default completion command]
    (let [(status maybe-input) (pcall vim.fn.input prompt "" completion)
          input (if (and (= maybe-input "") (~= default nil)) default maybe-input)]
      (when status
        (vim.cmd (.. ":" command input))))))

(set M.checkout-new-branch
  (fn []
    (let [(status branch) (pcall vim.fn.input "New branch name> ")]
      (when (and (not status) (~= branch ""))
        (exec [
          [:echo "\\r\""]
          [:echohl "Directory"]
          [":Git" (.. "checkout -b " branch)]
          [:echohl "None"]])))))


; Get the user input for what he wants to search for with vimgrep
; if it's empty, abort, if it's not empty get the user input for the target folder, if
; it's not specified, defaults to `git ls-files`
(set M.vim-grep
  (fn []
    (let [(search-status input) (pcall vim.fn.input "Search for: ")]
      (if (or (not search-status) (= input ""))
        (print "Aborted")
        (let [(folder-status maybe-target) (pcall vim.fn.input "Target folder/files (git ls-files): " "" "file")
              target (if (= maybe-target "") "`git ls-files`" maybe-target)]
          (if (not folder-status)
            (print "Aborted")
            (let [(status err) (pcall vim.cmd (.. ":vimgrep /" input "/gj" target))]
              (if (not status)
                (print err)
                (exec [[:copen]])))))))))


; Lazygit
(let [lazygit (Terminal:new {:cmd "lazygit" :hidden true :direction "float" :id 1000})]
  (set M.lazygit-toggle
    (fn []
      (lazygit:toggle))))


; Get a color form a highlight group
(set M.get-color
  (fn [highlight-group type fallback]
    (let [color (vim.fn.synIDattr (-> highlight-group vim.fn.hlID vim.fn.synIDtrans) (.. type "#"))]
      (if (= color "")
        fallback
        color))))

(set M.display-image
  (fn [source]
    (let [show-image (.. "curl -s " source " | viu - ")
          image-window (Terminal:new {:cmd show-image :hidden true :direction "float" :close_on_exit false})]
      (image-window:toggle))))

(fn get-cur-word []
  (let [line (vim.fn.getline ".")
        col (vim.fn.col ".")
        left-part (vim.fn.strpart line 0 (+ col 1))
        right-part (vim.fn.strpart line col (vim.fn.col "$"))
        word
          (vim.fn.matchstr
           left-part
           (.. "\\k*$" (string.sub (vim.fn.matchstr right-part) "^\\k*"))
           2)]
    (.. "\\<" (vim.fn.escape word (.. "/\\" "\\>")))))

(fn jump-word [previous]
  (let [word (get-cur-word)
        flag (if previous "b" "")]
    (vim.fn.search word flag)))

(set M.jump-next-word
  (fn []
    (jump-word false)))

(set M.jump-previous-word
  (fn []
    (jump-word true)))

(set M.symbol-line
  (fn []
    (let [curwin (or vim.g.statusline_winid 0)
          curbuf (vim.api.nvim_win_get_buf curwin)
          (ok line) (pcall vim.api.nvim_buf_get_var curbuf "coc_symbol_line")
          str (and ok (or line ""))]
      str)))

M
