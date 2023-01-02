(local M {1 :diepm/vim-rest-console :ft :rest})

(import-macros {: g!} :hibiscus.vim)

(fn M.config []
  (g! :vrc_curl_opts {:-sS ""
                      :--connect-timeout 10
                      :-i ""
                      :--max-time 60
                      :-k ""})
  (g! :vrc_auto_format_response_patterns {:json "python3 -m json.tool"}) ; Formatar resposta em JSON
  (g! :vrc_split_request_body 0) ;  Permitir que parâmetros GET sejam declarados em linhas sequenciais
  )

M
