local commands = {
  _general_settings = {
    { "FileType", "qf,help,man", "nnoremap <silent> <buffer> q :close<CR>" },
    {
      "TextYankPost",
      "*",
      "lua require'vim.highlight'.on_yank({higroup = 'Search', timeout = 200})",
    },
    {
      "BufWinEnter",
      "dashboard",
      "setlocal cursorline signcolumn=yes cursorcolumn number",
    },
    { "FileType", "qf", "set nobuflisted" },
    { "FileType", "qf", "nnoremap <buffer> <CR> <CR>" },
    { "BufReadPost", "*", [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]] },
    {
      "BufEnter,FocusGained,InsertLeave",
      "*",
      "set relativenumber"
    },
    {
      "BufLeave,FocusLost,InsertEnter",
      "*",
      "set norelativenumber"
    }
  },
  _formatoptions = {
    {
      "BufWinEnter,BufRead,BufNewFile",
      "*",
      "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
    },
  },
  _formatonsave = {
    { "BufWrite", "*", "lua vim.lsp.buf.formatting_sync(nil, 1000)"}
  },
  _filetypechanges = {
    { "BufWinEnter", ".zsh", "setlocal filetype=sh" },
    { "BufRead", "*.zsh", "setlocal filetype=sh" },
    { "BufNewFile", "*.zsh", "setlocal filetype=sh" },
  },
  _git = {
    { "FileType", "gitcommit", "setlocal wrap" },
    { "FileType", "gitcommit,octo", "setlocal spell" },
  },
  _markdown = {
    { "FileType", "markdown", "setlocal wrap" },
    { "FileType", "markdown", "setlocal spell" },
  },
  _auto_resize = {
    -- will cause split windows to be resized evenly if main window is resized
    { "VimResized", "*", "tabdo wincmd =" },
  },
  _general_lsp = {
    { "FileType", "lspinfo,lsp-installer,null-ls-info", "nnoremap <silent> <buffer> q :close<CR>" },
  },
  _dashboard = {
    -- seems to be nobuflisted that makes my stuff disappear will do more testing
    {
      "FileType",
      "dashboard",
      "setlocal nocursorline noswapfile synmaxcol& signcolumn=no norelativenumber nocursorcolumn nospell  nolist  nonumber bufhidden=wipe colorcolumn= foldcolumn=0 matchpairs= ",
    },
    { "FileType", "dashboard", "nnoremap <silent> <buffer> q :q<CR>" },
  },
}

for group_name, definition in pairs(commands) do
  vim.cmd("augroup " .. group_name)
  vim.cmd "autocmd!"

  for _, def in pairs(definition) do
    local command = table.concat(vim.tbl_flatten { "autocmd", def }, " ")
    vim.cmd(command)
  end

  vim.cmd "augroup END"
end
