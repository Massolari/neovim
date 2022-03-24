-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
vim.cmd [[packadd matchit]]

return require 'packer'.startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Ícones
  use 'kyazdani42/nvim-web-devicons'

  -- Editorconfig
  use 'editorconfig/editorconfig-vim'

  -- Sessões
  use 'xolox/vim-misc'
  use {
    'xolox/vim-session',
    requires = { 'xolox/vim-misc' },
  }

  -- Buscador
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require 'telescope'
      telescope.setup {
        defaults = {
          mappings = {
            i = {
              ['<c-j>'] = require 'telescope.actions'.move_selection_next,
              ['<c-k>'] = require 'telescope.actions'.move_selection_previous,
              ['<esc>'] = require 'telescope.actions'.close,
            }
          }
        }
      }
      telescope.load_extension('fzf')
      telescope.load_extension('coc')
    end
  }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use { 'fannheyward/telescope-coc.nvim' }

  -- Sintasse para várias linguagens
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }

  -- Habilita o uso do emmet (<C-g>,)
  use {
    'mattn/emmet-vim',
    config = function()
      -- Usar o emmet apenas no modo visual ou no modo inserção
      vim.g.user_emmet_mode = 'iv'
      vim.g.user_emmet_leader_key = '<C-g>'
    end,
  }

  -- Habilita a busca rapida usando duas letras
  -- use 'ggandor/lightspeed.nvim'
  use {
    'rlane/pounce.nvim',
    config = function() require 'pounce'.setup {} end
  }

  -- Gruvbox
  use 'ellisonleao/gruvbox.nvim'


  -- Mostra um git diff na coluna de número e comandos para hunks
  use {
    'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require 'gitsigns'.setup {
        numhl = false,
        linehl = false,
        keymaps = {
          -- Default keymap options
          noremap = true,
          buffer = true,

          ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'" },
          ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'" },

          ['n <leader>ghu'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
          ['v <leader>ghu'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
          ['n <leader>ghv'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',

          -- Text objects
          -- ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
          -- ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
        },
        current_line_blame = true,
        current_line_blame_opts = {
          delay = 0
        }
      }
    end
  }

  -- Mostra linhas de indentação
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require 'indent_blankline'.setup {
        show_current_context = true
      }
    end
  }

  -- Auto-fechamento de delimitadores
  use {
    'windwp/nvim-autopairs',
    config = function()
      require 'nvim-autopairs'.setup()
    end
  }

  -- Operação com delimitadores
  use 'tpope/vim-surround'

  -- Se mover melhor com o f/t
  use 'unblevable/quick-scope'

  -- Text-objects melhorados e com seek
  use 'wellle/targets.vim'

  -- Explorador de arquivos
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require 'nvim-tree'.setup {
        disable_netrw = false
      }
    end
  }

  -- Warper para comandos do git
  use {
    'tpope/vim-fugitive',
    opt = true,
    cmd = { 'G', 'Git', 'Gdiff', 'Gclog', 'Gwrite' }
  }
  use {
    'pwntester/octo.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'kyazdani42/nvim-web-devicons',
    },
    config = function()
      require "octo".setup()
    end
  }

  -- Engine de snippets
  use 'L3MON4D3/LuaSnip'
  use "rafamadriz/friendly-snippets"

  -- Biblioteca de snippets
  use 'honza/vim-snippets'

  -- Status line
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function() require 'statusline' end
  }

  -- Guia de atalhos
  use {
    "folke/which-key.nvim",
    config = function()
      require 'which-key'.setup {
        plugins = {
          spelling = {
            enabled = true
          }
        }
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  -- Cliente REST
  use {
    'diepm/vim-rest-console',
    opt = true,
    ft = 'rest',
  }

  -- LSP do Nvim
  use {'neoclide/coc.nvim', branch = 'release'}

  -- Alternador de terminal
  use {
    'akinsho/nvim-toggleterm.lua',
    config = function()
      require 'toggleterm'.setup {
        open_mapping = [[<leader>t]],
        shade_terminals = false,
        direction = 'horizontal',
        insert_mappings = false, -- whether or not the open mapping applies in insert mode
        terminal_mappings = false,
      }
    end
  }

  -- Buffers no topo
  use {
    'akinsho/bufferline.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require 'bufferline'.setup {
        options = {
          diagnostics = 'coc',
          diagnostics_indicator = function(_, _, diagnostics_dict, _)
            local error = ""
            local warning = ""
            local info = ""
            local hint = ""
            for e, n in pairs(diagnostics_dict) do
              if e == 'error' then
                error = "  " .. n
              elseif e == 'warning' then
                warning = "  " .. n
              elseif e == 'hint' then
                hint = "  " .. n
              else
                info = "  " .. n
              end
            end
            return error .. warning .. info .. hint
          end
        }
      }
    end
  }

  local user_file = vim.fn.stdpath('config') .. '/lua/user/plugins.lua'
  if vim.fn.filereadable(user_file) > 0 then
    require 'user.plugins'.setup(use)
  end

  use 'github/copilot.vim'

  -- Correção do CursorHold
  use 'antoinemadec/FixCursorHold.nvim'

  -- Colorir hexademical de cores
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require 'colorizer'.setup {
        '*';
        css = { hsl_fn = true };
        scss = { hsl_fn = true };
      }
    end
  }

  -- Dashboard
  use 'ChristianChiarulli/dashboard-nvim'

  -- Destacar palavras iguais
  use { 'Massolari/vim-illuminate', disable = true }

  -- Wildmenu melhorado
  use 'gelguy/wilder.nvim'

  -- Integração com Dash (MacOS)
  use {
    'mrjones2014/dash.nvim',
    run = 'make install',
  }

  -- Pré-visualizar markdown
  use "ellisonleao/glow.nvim"

  -- Inteligência para Elm
  use {'jwoudenberg/elm-pair', rtp = 'editor-integrations/neovim'}
end)
