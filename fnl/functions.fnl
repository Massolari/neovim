(import-macros {: exec} :hibiscus.vim)
(import-macros {: fstring} :hibiscus.core)

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

(λ M.toggle-quickfix []
  (let [is-open? (is-location-quickfix-open? :quickfix)]
    (if is-open?
        (vim.cmd.cclose)
        (exec [[:botright "copen 10"]]))))

(λ M.toggle-location-list []
  (let [is-open? (is-location-quickfix-open? :location)]
    (if is-open?
        (vim.cmd.lclose)
        (let [(status err) (pcall vim.cmd "lopen 10")]
          (when (not status)
            (show-warning err "Location list"))))))

(λ with-input [prompt fun ?default ?completion]
  (let [(status maybe-input) (if ?completion
                                 (pcall vim.fn.input prompt "" ?completion)
                                 (pcall vim.fn.input prompt ""))
        input (if (and (= maybe-input "") (not= ?default nil)) ?default
                  maybe-input)]
    (when status
      (fun input))))

(λ M.checkout-new-branch []
  (with-input "New branch name: "
              (fn [branch]
                (when (not= branch "")
                  (exec [[:echo "\"\\r\""]
                         [:echohl :Directory]
                         [":Git" (.. "checkout -b " branch)]
                         [:echohl :None]])))))

; Get the user input for what he wants to search for with vimgrep
; if it's empty, abort, if it's not empty get the user input for the target folder, if
; it's not specified, defaults to `git ls-files`

(λ M.vim-grep []
  (let [(search-status input) (pcall vim.fn.input "Search for: ")]
    (if (or (not search-status) (= input ""))
        (print :Aborted)
        (let [(folder-status maybe-target) (pcall vim.fn.input
                                                  "Target folder/files (git ls-files): "
                                                  "" :file)
              target (if (= maybe-target "") "`git ls-files`" maybe-target)]
          (if (not folder-status)
              (print :Aborted)
              (let [(status err) (pcall vim.cmd.vimgrep
                                        (fstring "/${input}/gj ${target}"))]
                (if (not status)
                    (print err)
                    (vim.cmd.copen))))))))

; w3m

; (λ w3m-open [url]
;   (let [w3m (Terminal:new {:cmd (.. "w3m " url)
;                            :on_open (fn []
;                                       (vim.cmd (.. "vertical resize "
;                                                    (/ (vim.opt.columns:get) 2))))
;                            :direction :vertical
;                            :id 1001})]
;     (w3m:toggle)))

; (λ M.w3m-open []
;   (w3m-open :-v))
;
; (λ M.w3m-open-url []
;   (with-input "Open URL: " #(w3m-open $1)))

; (λ M.w3m-search []
;   (with-input "Search on the web: "
;               (fn [input]
;                 (when (not= input "")
;                   (w3m-open (.. "\"https://www.google.com/search?q="
;                                 (string.gsub input " " "+") "\""))))))

; Session

; (let [sessions (Terminal:new {:cmd (.. "bash --rcfile <(echo 'cd "
;                                        (vim.fn.stdpath :data) :/sessions
;                                        "; echo \"************
; * Sessions *
; ************
; \"; ls')")
;                               :direction :float
;                               :hidden true
;                               :id 1002})]
;   (set M.session-list #(sessions:toggle)))

; Get a color form a highlight group

(λ M.get-color [highlight-group type fallback]
  (let [color (vim.fn.synIDattr (-> highlight-group
                                    vim.fn.hlID
                                    vim.fn.synIDtrans)
                                (.. type "#"))]
    (if (= color "")
        fallback
        color)))

(set M.file-exists? #(> (vim.fn.filereadable $1) 0))

(local animals ["🐕" "🐈" "🦆"])
(λ M.release-animals []
  (let [d (require :duck)]
    (each [_ animal (pairs animals)]
      (d.hatch animal))))

(λ M.cook-animals []
  (let [d (require :duck)]
    (each [_ _ (pairs animals)]
      (d.cook))))

(λ M.get-random [max]
  (math.randomseed (os.time))
  (math.random max))

(λ M.get-random-item [list]
  (->> list (length) (M.get-random) (. list)))

(λ M.clear-endspace []
  (let [ids (->> (vim.fn.getmatches)
                 (vim.tbl_filter #(= $.group :EndSpace))
                 (vim.tbl_map (fn [m]
                                m.id)))]
    (each [_ i (pairs ids)]
      (vim.fn.matchdelete i))))

(λ M.requireAnd [module callback]
  (callback (require module)))

M
