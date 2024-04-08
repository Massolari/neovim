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
        (vim.cmd "botright copen 10"))))

(λ M.toggle-location-list []
  (let [is-open? (is-location-quickfix-open? :location)]
    (if is-open?
        (vim.cmd.lclose)
        (let [(status err) (pcall vim.cmd "lopen 10")]
          (when (not status)
            (show-warning err "Location list"))))))

(λ M.with-input [prompt fun ?default ?completion]
  (let [(status maybe-input) (if ?completion
                                 (pcall vim.fn.input prompt "" ?completion)
                                 (pcall vim.fn.input prompt ""))
        input (if (and (= maybe-input "") (not= ?default nil)) ?default
                  maybe-input)]
    (when status
      (fun input))))

(λ M.grep []
  (let [(search-status input) (pcall vim.fn.input "Procurar por: ")]
    (if (or (not search-status) (= input ""))
        (show-info "Pesquisa cancelada" :RipGrep)
        (let [(status err) (pcall vim.cmd (.. "silent grep! \"" input "\""))]
          (if (not status)
              (show-error err :Busca)
              (vim.cmd.copen))))))

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

(set M.dir-exists? #(> (vim.fn.isdirectory $1) 0))

(set M.has-files-dirs? #(-> (vim.fs.find $ {:upward true})
                            (table.getn)
                            (> 0)))

(math.randomseed (os.time))
(λ M.get-random [max]
  (math.random max))

(λ M.get-random-item [list]
  (->> list (length) (M.get-random) (. list)))

(λ M.clear-endspace []
  (let [ids (->> (vim.fn.getmatches)
                 (vim.tbl_filter #(= $.group :EndSpace))
                 (vim.tbl_map #($.id)))]
    (each [_ i (pairs ids)]
      (vim.fn.matchdelete i))))

(λ M.require-and [module callback]
  (callback (require module)))

(fn M.format []
  (let [buf (vim.api.nvim_get_current_buf)
        ft (vim.fn.getbufvar buf :&ft)
        has-null-ls (-> (M.require-and :null-ls.sources
                                       #($.get_available ft :NULL_LS_FORMATTING))
                        (length)
                        (> 0))
        filter-fn (if has-null-ls #(= $1 $2) #(not= $1 $2))]
    (vim.lsp.buf.format {:filter #(filter-fn $.name :null-ls)
                         :timeout_ms 10000})))

(λ M.prefixed-keys [mappings prefix]
  (icollect [_ {1 keys 2 cmd &as map-options} (ipairs mappings)]
    (vim.tbl_extend :keep [(.. prefix keys) cmd] map-options)))

(λ M.keymaps-set [mode keys ?options]
  (let [global-options (or ?options {})
        prefix (or global-options.prefix "")] ; Remover prefixo de global-options, pois não é uma opção válida para vim.keymap.set
    (set global-options.prefix nil)
    (each [_ [lhs rhs ?local-options] (ipairs keys)]
      (vim.keymap.set mode (.. prefix lhs) rhs
                      (vim.tbl_extend :force global-options
                                      (or ?local-options {}))))))

; Silicon

(λ get-silicon-language [file-extension]
  (match file-extension
    :fnl :clj
    :gleam :rust
    _ file-extension))

(λ M.generate-code-image [{: line1 : line2}]
  (let [language (-> (vim.fn.expand "%:e") (get-silicon-language))
        code (-> (vim.api.nvim_buf_get_lines 0 (- line1 1) line2 false)
                 (table.concat "\\n"))
        cmd (string.format "printf '%s' | silicon -l %s --to-clipboard" code
                           language)
        result (vim.fn.system cmd)
        notify-title :Silicon]
    (if (= result "")
        (show-info "Imagem de código gerada" notify-title)
        (show-error result notify-title))))

(λ M.get-lsp-config-options [server-name default-config]
  (match server-name
    :sumneko_lua {:settings {:Lua {:runtime {:version :LuaJIT}
                                   :hint {:enable true}
                                   :diagnostics {:globals [:vim]}
                                   :workspace {:library (vim.api.nvim_list_runtime_paths)}}}}
    :ltex {:root_dir vim.loop.cwd
           :filetypes [:octo (unpack default-config.filetypes)]
           :settings {:ltex {:enabled [:bibtex
                                       :context
                                       :context.tex
                                       :gitcommit
                                       :html
                                       :latex
                                       :markdown
                                       :octo
                                       :org
                                       :restructuredtext
                                       :rsweave]
                             :java {:path (.. vim.env.HOME
                                              :/.nix-profile/bin/java)}}}}
    :fennel_language_server
    {:settings {:fennel {:workspace {:library (vim.api.nvim_list_runtime_paths)}
                         :diagnostics {:globals [:vim]}}}}
    :fennel_ls {:settings {:fennel-ls {:extra-globals :vim}}}
    :tailwindcss
    {:settings {:tailwindCSS {:includeLanguages {:elm :html :gleam :html}
                              :experimental {:classRegex ["\\bclass[\\s(<|]+\"([^\"]*)\""
                                                          "\\bclass[\\s(]+\"[^\"]*\"[\\s+]+\"([^\"]*)\""
                                                          "\\bclass[\\s<|]+\"[^\"]*\"\\s*\\+{2}\\s*\" ([^\"]*)\""
                                                          "\\bclass[\\s<|]+\"[^\"]*\"\\s*\\+{2}\\s*\" [^\"]*\"\\s*\\+{2}\\s*\" ([^\"]*)\""
                                                          "\\bclass[\\s<|]+\"[^\"]*\"\\s*\\+{2}\\s*\" [^\"]*\"\\s*\\+{2}\\s*\" [^\"]*\"\\s*\\+{2}\\s*\" ([^\"]*)\""
                                                          "\\bclassList[\\s\\[\\(]+\"([^\"]*)\""
                                                          "\\bclassList[\\s\\[\\(]+\"[^\"]*\",\\s[^\\)]+\\)[\\s\\[\\(,]+\"([^\"]*)\""
                                                          "\\bclassList[\\s\\[\\(]+\"[^\"]*\",\\s[^\\)]+\\)[\\s\\[\\(,]+\"[^\"]*\",\\s[^\\)]+\\)[\\s\\[\\(,]+\"([^\"]*)\""]}}}
     :init_options {:userLanguages {:elm :html :gleam :html}}
     :filetypes [:elm :gleam (unpack default-config.filetypes)]}
    :tsserver {:init_options {:preferences {:includeInlayParameterNameHints :all
                                            :includeInlayParameterNameHintsWhenArgumentMatchesName true
                                            :includeInlayFunctionParameterTypeHints true
                                            :includeInlayVariableTypeHints true
                                            :includeInlayVariableTypeHintsWhenTypeMatchesName true
                                            :includeInlayPropertyDeclarationTypeHints true
                                            :includeInlayFunctionLikeReturnTypeHints true
                                            :includeInlayEnumMemberValueHints true}}}
    :yamlls {:settings {:yaml {:keyOrdering false}}}
    :gleam {:cmd [(.. vim.env.HOME
                      :/.vscode/extensions/maurobalbi.glas-vscode-0.2.3-darwin-arm64/glas)
                  :--stdio]}
    _ default-config))

(λ M.start-ltex []
  (vim.ui.input {:prompt "Language: " :default :pt-BR}
                (fn [language]
                  (when (and (not= language "") (not= language nil))
                    (let [lspconfig (require :lspconfig)
                          config (M.get-lsp-config-options :ltex
                                                           lspconfig.ltex.document_config.default_config)]
                      (lspconfig.ltex.setup (vim.tbl_extend :force config
                                                            {:settings {:ltex {: language}}})))))))

(λ M.get_breadcrumbs []
  (if (> (length (vim.lsp.buf_get_clients)) 0)
      (M.require-and :nvim-navic #($.get_location))
      " "))

(λ M.get-key-insert [key]
  (vim.api.nvim_replace_termcodes key true false true))

M
