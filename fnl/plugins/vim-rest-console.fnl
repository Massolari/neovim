(local M {1 :diepm/vim-rest-console :ft :rest})

(fn M.config []
  (set vim.g.vrc_curl_opts {:-sS ""
                            :--connect-timeout 10
                            :-i ""
                            :--max-time 60
                            :-k ""})
  (set vim.g.vrc_auto_format_response_patterns {:json "jq ."}) ; Formatar resposta em JSON
  (set vim.g.vrc_split_request_body 0) ;  Permitir que parâmetros GET sejam declarados em linhas sequenciais
  )

M
