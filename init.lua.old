-- Instalação do packer
local install_path = vim.fn.stdpath'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  if vim.fn.executable'git' == 0 then
    vim.cmd"echoerr 'You have to install git or first install packer yourself!'"
    vim.fn.execute'q!'
  end
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd'autocmd VimEnter * PackerInstall'
end

require'plugins'
require'settings'
require'commands'
require'autocommands'
require'mappings'.setup()
-- require'lsp'

-- Arquivo de configurações do usuário
local user_file = vim.fn.stdpath'config' .. '/lua/user/init.lua'
if vim.fn.filereadable(user_file) > 0 then
  require'user'
end

require'setup'

require'theme'
