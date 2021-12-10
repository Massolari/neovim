vim.cmd([[
" Fechar todos os outros buffers
command! Bdall %bd|e#|bd#

" Cor de fundo transparente
command! Transparent hi Normal guibg=NONE ctermbg=NONE
]])
