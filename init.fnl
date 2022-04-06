(require-macros :hibiscus.vim)

; Instalar packer se não estiver instalado
(let [install-path (.. (vim.fn.stdpath "data") "/site/pack/packer/start/packer.nvim")
      packer-exists? (= 0 (vim.fn.empty (vim.fn.glob install-path)))]
  (when (not packer-exists?)
    (if (= 0 (vim.fn.executable "git"))
      (do
        (exec [[:echorr "You have to install git or first install packer yourself!"]])
        (vim.fn.execute "q!"))
      (do
        (vim.fn.execute (.. "!git clone https://github.com/wbthomason/packer.nvim " install-path))
        (exec [[:autocmd "VimEnter * PackerInstall"]])))))

(require :plugins)
(require :settings)
(require :commands)
(require :autocommands)
(require :mappings)

; Arquivo de configuração do usuário
(let [user-file (.. (vim.fn.stdpath "config") "/lua/user/init.lua")]
  (when (> (vim.fn.filereadable user-file) 0)
    (require :user)))

(require :setup)
(require :theme)
