(require-macros :hibiscus.vim)

(local Terminal (. (require :toggleterm.terminal) :Terminal))
(local M {})

(λ show-notification [msg level title ?opts]
  (let [options (or ?opts {})]
    (set options.title title)
    (vim.notify msg level options)))

(λ show-warning [msg title ?opts]
  (show-notification msg vim.log.levels.WARN title ?opts))

(λ show-info [msg title ?opts]
  (show-notification msg :info title ?opts))

(λ show-error [msg title ?opts]
  (show-notification msg :error title ?opts))

(set M.show-warning show-warning)
(set M.show-info show-info)
(set M.show-error show-error)

(λ is-location-quickfix-open? [window]
  (let [query (if (= window :quickfix) "v:val.quickfix && !v:val.loclist"
                  "v:val.loclist")
        windows (vim.fn.getwininfo)
        wanted-windows (vim.fn.filter windows query)]
    (> (vim.fn.len wanted-windows) 0)))

(set M.toggle-quickfix
     #(let [is-open? (is-location-quickfix-open? :quickfix)]
        (if is-open?
            (exec [[:cclose]])
            (exec [[:botright "copen 10"]]))))

(set M.toggle-location-list
     #(let [is-open? (is-location-quickfix-open? :location)]
        (if is-open?
            (exec [[:lclose]])
            (let [(status err) (pcall vim.cmd ":lopen 10")]
              (when (not status)
                (show-warning err "Location list"))))))

(set M.command-with-args
     (λ [prompt default completion command]
       (let [(status maybe-input) (pcall vim.fn.input prompt "" completion)
             input (if (and (= maybe-input "") (not= default nil)) default
                       maybe-input)]
         (when status
           (vim.cmd (.. ":" command " " input))))))

(set M.checkout-new-branch
     #(let [(status branch) (pcall vim.fn.input "New branch name> ")]
        (when (and status (not= branch ""))
          (exec [[:echo "\"\\r\""]
                 [:echohl :Directory]
                 [":Git" (.. "checkout -b " branch)]
                 [:echohl :None]]))))

; Get the user input for what he wants to search for with vimgrep
; if it's empty, abort, if it's not empty get the user input for the target folder, if
; it's not specified, defaults to `git ls-files`
(set M.vim-grep (fn []
                  (let [(search-status input) (pcall vim.fn.input
                                                     "Search for: ")]
                    (if (or (not search-status) (= input ""))
                        (print :Aborted)
                        (let [(folder-status maybe-target) (pcall vim.fn.input
                                                                  "Target folder/files (git ls-files): "
                                                                  "" :file)
                              target (if (= maybe-target "") "`git ls-files`"
                                         maybe-target)]
                          (if (not folder-status)
                              (print :Aborted)
                              (let [(status err) (pcall vim.cmd
                                                        (.. ":vimgrep /" input
                                                            :/gj target))]
                                (if (not status)
                                    (print err)
                                    (exec [[:copen]])))))))))

; Lazygit
(let [lazygit (Terminal:new {:cmd :lazygit
                             :hidden true
                             :direction :float
                             :id 1000})]
  (set M.lazygit-toggle #(lazygit:toggle)))

; Get a color form a highlight group
(set M.get-color (fn [highlight-group type fallback]
                   (let [color (vim.fn.synIDattr (-> highlight-group
                                                     vim.fn.hlID
                                                     vim.fn.synIDtrans)
                                                 (.. type "#"))]
                     (if (= color "")
                         fallback
                         color))))

(set M.display-image (fn [source]
                       (let [show-image (.. "curl -s " source " | viu - ")
                             image-window (Terminal:new {:cmd show-image
                                                         :hidden true
                                                         :direction :float
                                                         :close_on_exit false})]
                         (image-window:toggle))))

(λ get-cur-word []
  (let [line (vim.fn.getline ".")
        col (vim.fn.col ".")
        left-part (vim.fn.strpart line 0 (+ col 1))
        right-part (vim.fn.strpart line col (vim.fn.col "$"))
        word (.. (vim.fn.matchstr left-part "\\k*$")
                 (string.sub (vim.fn.matchstr right-part "^\\k*") 2))]
    (.. "\\<" (vim.fn.escape word (.. "/\\" "\\>")))))

(λ jump-word [previous]
  (let [word (get-cur-word)
        flag (if previous :b "")]
    (vim.fn.search word flag)))

(set M.jump-next-word #(jump-word false))

(set M.jump-previous-word #(jump-word true))

(set M.file-exists? #(> (vim.fn.filereadable $1) 0))

M
