(local M {})

(λ show-notification [msg level title ?opts]
  "Show a notification"
  {:fnl/arglist [msg level title ?opts]}
  (let [options (or ?opts {})]
    (set options.title title)
    (vim.notify msg level options)))

(λ show-warning [msg title ?opts]
  (show-notification msg vim.log.levels.WARN title ?opts))

(λ show-info [msg title ?opts]
  (show-notification msg vim.log.levels.INFO title ?opts))

(λ show-error [msg title ?opts]
  (show-notification msg vim.log.levels.ERROR title ?opts))

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
  (let [data-path (vim.fn.stdpath :data)
        code-temp-file (.. data-path :/code-silicon.code)
        img-temp-file (.. data-path :/image-silicon.png)
        language (-> (vim.fn.expand "%:e") (get-silicon-language))
        lines (vim.api.nvim_buf_get_lines 0 (- line1 1) line2 false)
        notify-title :Silicon] ; Escrever o código em um arquivo temporário
    (vim.fn.delete code-temp-file)
    (vim.fn.delete img-temp-file)
    (vim.fn.writefile lines code-temp-file) ; Gerar a imagem em um arquivo temporário
    (let [silicon-cmd (string.format "silicon -l %s -o %s < %s" language
                                     (vim.fn.shellescape img-temp-file)
                                     (vim.fn.shellescape code-temp-file))
          silicon-result (vim.fn.system silicon-cmd)
          silicon-exit-code (vim.fn.system "echo $status")] ; Remover o arquivo de código temporário
      (vim.fn.delete code-temp-file)
      (if (and (= silicon-result "") (= silicon-exit-code "0\n"))
          (do
            ; Copiar a imagem para o clipboard usando osascript (AppleScript)
            (let [osascript-cmd (string.format "osascript -e 'set the clipboard to (POSIX file \"%s\")'"
                                               (vim.fn.shellescape img-temp-file))
                  copy-result (vim.fn.system osascript-cmd)]
              (if (= copy-result "")
                  (show-info "Imagem de código copiada para o clipboard"
                             notify-title)
                  (show-error copy-result notify-title)))) ; Se algo deu errado com o silicon
          (show-error silicon-result notify-title)) ; Remover o arquivo de imagem temporário
      )))

(set M.lsp-config-options
     {:elixirls #{:cmd [:elixir-ls]}
      :lua_ls #{:on_init (fn [client]
                           (when client.workspace_folders
                             (set client.config.settings.Lua
                                  (vim.tbl_deep_extend :force
                                                       client.config.settings.Lua
                                                       {:runtime {:version :LuaJIT}
                                                        :diagnostics {:unusedLocalIgnore ["_*"]}
                                                        :hint {:enable true}
                                                        :workspace {:library [vim.env.VIMRUNTIME]}}))))
                :settings {:Lua {}}}
      :ltex_plus (fn [default-config]
                   {:root_dir vim.loop.cwd
                    :filetypes [:octo (_G.unpack default-config.filetypes)]
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
                                                :rsweave]}}})
      :fennel_ls #{:settings {:fennel-ls {:extra-globals :vim}}}
      :tailwindcss (fn [default-config]
                     {:settings {:tailwindCSS {:includeLanguages {:elm :html
                                                                  :gleam :html}
                                               :experimental {:classRegex ["\\bclass[\\s(<|]+\"([^\"]*)\""
                                                                           "\\bclass[\\s(]+\"[^\"]*\"[\\s+]+\"([^\"]*)\""
                                                                           "\\bclass[\\s<|]+\"[^\"]*\"\\s*\\+{2}\\s*\" ([^\"]*)\""
                                                                           "\\bclass[\\s<|]+\"[^\"]*\"\\s*\\+{2}\\s*\" [^\"]*\"\\s*\\+{2}\\s*\" ([^\"]*)\""
                                                                           "\\bclass[\\s<|]+\"[^\"]*\"\\s*\\+{2}\\s*\" [^\"]*\"\\s*\\+{2}\\s*\" [^\"]*\"\\s*\\+{2}\\s*\" ([^\"]*)\""
                                                                           "\\bclassList[\\s\\[\\(]+\"([^\"]*)\""
                                                                           "\\bclassList[\\s\\[\\(]+\"[^\"]*\",\\s[^\\)]+\\)[\\s\\[\\(,]+\"([^\"]*)\""
                                                                           "\\bclassList[\\s\\[\\(]+\"[^\"]*\",\\s[^\\)]+\\)[\\s\\[\\(,]+\"[^\"]*\",\\s[^\\)]+\\)[\\s\\[\\(,]+\"([^\"]*)\""]}}}
                      :init_options {:userLanguages {:elm :html :gleam :html}}
                      :filetypes [:elm
                                  :gleam
                                  (_G.unpack default-config.filetypes)]})
      :ts_ls #{:init_options {:preferences {:includeInlayParameterNameHints :all
                                            :includeInlayParameterNameHintsWhenArgumentMatchesName true
                                            :includeInlayFunctionParameterTypeHints true
                                            :includeInlayVariableTypeHints true
                                            :includeInlayVariableTypeHintsWhenTypeMatchesName true
                                            :includeInlayPropertyDeclarationTypeHints true
                                            :includeInlayFunctionLikeReturnTypeHints true
                                            :includeInlayEnumMemberValueHints true}}}
      :yamlls #{:settings {:yaml {:keyOrdering false}}}})

(λ M.start-ltex []
  (vim.ui.input {:prompt "Language: " :default :pt-BR}
                (fn [language]
                  (when (and (not= language "") (not= language nil))
                    (let [lspconfig (require :lspconfig)
                          config (M.lsp-config-options.ltex lspconfig.ltex.document_config.default_config)]
                      (lspconfig.ltex.setup (vim.tbl_extend :force config
                                                            {:settings {:ltex {: language}}})))))))

(λ M.get-key-insert [key]
  (vim.api.nvim_replace_termcodes key true false true))

M
