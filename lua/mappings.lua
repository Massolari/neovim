local M = {}
local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
local luasnip = require'luasnip'
local function set_keymap(...) vim.api.nvim_set_keymap(...) end

local wk = require'which-key'

local function set_keymaps(mode, list)
  for _, map in pairs(list) do
    set_keymap(mode, unpack(map))
  end
end

local opts = {
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

-- Command
wk.register({
  -- Mover no modo insert sem as setas
  ['<c-j>'] = { '<Down>', 'Comando anterior executado mais recente' },
  ['<c-k>'] = { '<Up>', 'Próximo comando executado mais recente' },
}, { mode = "c", silent = false })

-- Insert
wk.register({
  -- Mover no modo insert sem as setas
  ['<c-b>'] = { '<left>', 'Move o cursor para a esquerda' },
  ['<c-j>'] = {
    function ()
      if vim.fn['coc#expandableOrJumpable']() then
        vim.cmd([[\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>]])
      end
    end,
    'Expande o snippet ou pula para o item seguinte',
  },
  ['<c-l>'] = { '<right>', 'Move o cursor para a direita' },

  -- Ir para o normal mode mais rapidamente
  ['jk'] = { '<Esc>', 'Ir para o modo normal' },
  ['kj'] = { '<Esc>', 'Ir para o modo normal' },
}, vim.tbl_extend('force', opts, { mode = "i" }))

-- Normal
wk.register({
  ['<c-n>'] = {  "<cmd>BufferLineCycleNext<CR>", 'Próximo buffer' },
  ['<c-p>'] = {  "<cmd>BufferLineCyclePrev<CR>", 'Buffer anterior' },
  [']'] = {
    [']'] = { "<cmd>call search('^\\w\\+\\s:\\s', 'w')<CR>", 'Pular para a próxima função Elm' },
    c = 'Próximo git hunk',
    d = { '<Plug>(coc-diagnostic-next)', 'Próximo problema (diagnostic)' },
    e = { '<Plug>(coc-diagnostic-next-error)', 'Próximo erro de código' },
    w = { "<cmd>lua require'illuminate'.next_reference({ wrap = true })<CR>", 'Próxima palavra destacada' },
  },
  ['['] = {
    ['['] = { "<cmd>call search('^\\w\\+\\s:\\s', 'bW')<CR>", 'Pular para a função Elm anterior' },
    c = 'Git hunk anterior',
    d = { '<Plug>(coc-diagnostic-prev)', 'Problema anterior (diagnostic)' },
    e = { '<Plug>(coc-diagnostic-prev-error)', 'Erro de código anterior' },
    w = { "<cmd>lua require'illuminate'.next_reference({ reverse = true, wrap = true })<CR>", 'Palavra destacada anterior' },
  }
}, vim.tbl_extend('force', opts, { mode = 'n'}))

-- Normal com leader
wk.register({
  [','] = { 'mpA,<Esc>`p', '"," no fim da linha' },
  [';'] = { 'mpA;<Esc>`p', '";" no fim da linha' },
  ['<Tab>'] = { '', 'Alterar para arquivo anterior' },
  ['='] = { '<c-w>=', 'Igualar tamanho das janelas' },
  ['<space>'] = { '<cmd>noh<cr>', 'Limpar seleção da pesquisa' },
  a = {
    name = 'Aba',
    a = { '<cmd>tabnew<CR>', 'Abrir uma nova' },
    c = { '<cmd>tabclose<CR>', 'Fechar (close)' },
    n = { '<cmd>tabnext<CR>', 'Ir para a próxima (next)' },
    p = { '<cmd>tabprevious<CR>', 'Ir para a anterior (previous)' },
  },
  b = {
    name = 'Buffer',
    a = { 'ggVG', 'Selecionar tudo (all)' },
    b = { "<cmd>lua require'telescope.builtin'.buffers()<CR>", 'Listar abertos' },
    d = { '<cmd>bp|bd #<CR>', 'Deletar' },
    j = { '<cmd>BufferLinePick<CR>', 'Pular (jump) para buffer' },
    s = { '<cmd>w<CR>', 'Salvar' },
  },
  c = {
    name = 'Code',
    a = { "<cmd>CocAction<CR>", 'Ações' },
    c = { "<cmd>Telescope coc commands<CR>", 'Comandos'},
    d = { '<cmd>Telescope coc workspace_diagnostics<cr>', 'Problemas (diagnostics)' },
    -- d = { '<cmd>CocList diagnostics<cr>', 'Problemas (diagnostics)' },
    f = { "<cmd>call CocActionAsync('format')<CR>", 'Formatar código' },
    i = { "<cmd>CocList marketplace<CR>", 'Instalar language-server' },
    o = { "<cmd>Telescope coc document_symbols<CR>", 'Buscar símbolos no arquivo' },
    -- o = { "<cmd>CocList outline<CR>", 'Buscar símbolos no arquivo' },
    -- p = { "<cmd>CocList -I symbols<CR>", 'Buscar símbolos no projeto' },
    p = { "<cmd>Telescope coc workspace_symbols<CR>", 'Buscar símbolos no projeto' },
    r = { '<Plug>(coc-rename)', 'Renomear Variável' },
  },
  e = {
    name = 'Editor',
    c = { "<cmd>lua require'telescope.builtin'.colorscheme()<CR>", 'Temas (colorscheme)' },
    d = { "<cmd>lua require'dash'.search()<CR>", 'Dash' },
    g = { "<cmd>lua require'functions'.vim_grep()<CR>", 'Buscar com vimgrep' },
    i = { "<cmd>lua require'functions'.display_image(vim.fn.expand('<cfile>'))<CR>", 'Exibir imagem sob o cursor' },
    q = { '<cmd>qa<CR>', 'Fechar' },
  },
  g = {
    name = 'Git',
    b = { '<cmd>Git blame<CR> ', 'Blame' },
    c = { '<cmd>Git commit<CR> ', 'Commit' },
    d = { '<cmd>Gdiff<CR> ', 'Diff' },
    g = { "<cmd>G log<CR>", 'Log' },
    h = {
      name= 'Hunks',
      u = 'Desfazer (undo)',
      v = 'Ver',
    },
    i = {
      name = 'Issues (Github)',
      i = { '<cmd>Octo issue list<CR>', 'Listar' },
      c = { '<cmd>Octo issue create<CR>', 'Criar' }
    },
    k = { "<cmd>lua require'functions'.checkout_new_branch()<CR>", 'Criar branch e fazer checkout' },
    l = { '<cmd>Git pull --rebase<CR> ', 'Pull' },
    o = { "<cmd>Octo actions<CR>", 'Octo (ações do GitHub)' },
    p = { "<cmd>Git -c push.default=current push<CR>", 'Push' },
    r = { "<cmd>lua require'telescope.builtin'.git_branches()<CR>", 'Listar branches' },
    s = { '<cmd>Git<CR> ', 'Status' },
    u = {
      name = 'Pull Requests (Github)',
      c = { '<cmd>Octo pr create<CR>', 'Criar' },
      u = { '<cmd>Octo pr list<CR>', 'Listar' },
    },
    w = { '<cmd>Gwrite<CR> ', 'Salvar e adicionar ao stage' },
    y = { "<cmd>lua require'functions'.lazygit_toggle()<CR>", 'Abrir lazygit' },
  },
  h = { '<cmd>split<CR> ', 'Dividir horizontalmente' },
  i = { 'mpgg=G`p', 'Indentar arquivo' },
  l = { "<cmd>lua require'functions'.toggle_location_list()<CR>", 'Alternar locationlist' },
  m = {
    name = 'Markdown',
    m = { "<cmd>Glow<CR>", 'Pré-visualizar com glow' },
    b = { "<cmd>MarkdownPreview<CR>", 'Pré-visualizar com navegador (browser)' }
  },
  o = {
    name = 'Abrir arquivos do vim',
    i = { "<cmd>exe 'edit' stdpath('config').'/init.vim'<CR>", 'init.vim' },
    p = { "<cmd>exe 'edit' stdpath('config').'/lua/plugins.lua'<CR>", 'plugins.lua' },
    u = {
      name = 'Arquivos do usuário' ,
      i = { "<cmd>exe 'edit' stdpath('config').'/lua/user/init.lua'<CR>", 'init.lua do usuário' },
      p = { "<cmd>exe 'edit' stdpath('config').'/lua/user/plugins.lua'<CR>", 'plugins.lua do usuário' },
    },
    s = { "<cmd>exe 'source' stdpath('config').'/init.lua'<CR>", 'Atualizar (source) configurações do vim' },
  },
  p = {
    name = 'Projeto',
    e = { "<cmd>lua require'telescope.builtin'.grep_string()<CR>", 'Procurar texto sob cursor' },
    f = { "<cmd>lua require'telescope.builtin'.find_files()<CR>", 'Buscar (find) arquivo' },
    s = { "<cmd>lua require'telescope.builtin'.grep_string({ search = vim.fn.input('Grep For> ')})<CR>", 'Procurar (search) nos arquivos' },
  },
  q = { "<cmd>lua require'functions'.toggle_quickfix()<CR>", 'Alternar quickfix' },
  s = {
    name = 'Sessão',
    c = { "<cmd>CloseSession<CR>", 'Fechar (close)' },
    d = {
      "<cmd>lua require'functions'.command_with_args('Delete session> ', 'default', 'customlist,xolox#session#complete_names', 'DeleteSession')<CR>",
      'Deletar'
    },
    o = {
      "<cmd>lua require'functions'.command_with_args('Open session> ', 'default', 'customlist,xolox#session#complete_names', 'OpenSession')<CR>",
      'Abrir'
    },
    s = {
      "<cmd>lua require'functions'.command_with_args('Save session> ', 'default', 'customlist,xolox#session#complete_names_with_suggestions', 'SaveSession')<CR>",
      'Salvar'
    },
  },
  t = 'Terminal',
  v = { '<cmd>vsplit<CR> ', 'Dividir verticalmente' },
  w = {
    name = 'Window',
    c = { '<c-w>c', 'Fechar janela' },
  },
}, vim.tbl_extend('force', opts, { mode = 'n', prefix = '<leader>' }))

local normal = {
  -- Mapeamentos do pounce
{'s', '<cmd>Pounce<CR>', {}},

  -- Toda a vez que pular para próxima palavra buscada o cursor fica no centro da tela
{ 'n', 'nzzzv', opts },
{ 'N', 'Nzzzv', opts },

  -- Explorador de arquivos
{ '<F3>', '<cmd>NvimTreeToggle<CR>' , opts},
{ '<F2>', '<cmd>NvimTreeFindFile<CR>' , opts},


  -- Mover cursor para outra janela divida
{ '<C-j>', '<C-w>j', opts },
{ '<C-k>', '<C-w>k', opts },
{ '<C-l>', '<C-w>l', opts },
{ '<C-h>', '<C-w>h', opts },

  -- Limpar espaços em branco nos finais da linha
{ '<F5>', 'mp<cmd>%s/\\s\\+$/<CR>`p' , opts},

  -- Enter no modo normal funciona como no modo inserção
{ '<CR>', 'i<CR><Esc>', opts },


  -- Setas redimensionam janelas adjacentes
{ '<left>', '<cmd>vertical resize -5<cr>' , opts},
{ '<right>', '<cmd>vertical resize +5<cr>' , opts},
{ '<up>', '<cmd>resize -5<cr>' , opts},
{ '<down>', '<cmd>resize +5<cr>' , opts},

  -- Mover de forma natural em wrap
{ 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true } },
{ 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true } },

  -- Desabilitar modo Ex
{ 'Q', '<nop>', {}}
}

local terminal = {
  -- Ir para modo normal no terminal de forma rapida
{'jk', '<c-\\><c-n>', opts},
{'kj', '<C-\\><C-n>', opts}
}

local visual = {
{'<', '<gv', opts},
{'>', '>gv', opts},
{ '//', 'y/<C-R>"<CR>', opts },
{'K', ":m '<-2<CR>gv=gv", opts},
{'J', ":m '>+1<CR>gv=gv", opts},
}

function M.setup()
  set_keymaps('t', terminal)
  set_keymaps('n', normal)
  set_keymaps('v', visual)
  vim.cmd[[
    imap <silent><script><expr> <c-q> copilot#Accept("\<c-q>")
    let g:copilot_no_tab_map = v:true
    ]]
end

wk.register({
  ['<c-space>'] = { 'coc#refresh()', 'Atualizar sugestões do autocomplete', expr=true },
}, { mode = 'i'  })

vim.cmd[[
nnoremap <silent> K :call g:ShowDocumentation()<CR>

function! g:ShowDocumentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
]]

wk.register({
  d = { "<Plug>(coc-definition)", 'Definição' },
  -- D = {
  --   function()
  --     vim.cmd('belowright split')
  --     vim.lsp.buf.definition()
  --   end,
  --   'Definição'
  -- },
  i = { "<Plug>(coc-implementation)", 'Implementação' },
  r = { "<cmd>Telescope coc references", 'Referências' },
  -- r = { "<Plug>(coc-references)", 'Referências' },
  y = { "<Plug>(coc-type-definition)", 'Definição do tipo' },
}, vim.tbl_extend('force', opts, { mode = 'n', prefix = 'g' }))

return M
