local gl = require('galaxyline')
local colors = require("galaxyline.themes.colors").default
local condition = require('galaxyline.condition')
local gls = gl.section

local get_color = require'functions'.get_color

colors.bg = get_color('CursorLine', 'bg', colors.bg)
colors.fg = get_color('Normal', 'fg')
colors.yellow = 'DarkYellow'

local getFilePath = function()
  local path = string.gsub(vim.fn.expand("%:h"), '^./', '')
  local formattedCwd = string.gsub(vim.fn.getcwd(), '\\-', '\\-')
  local formattedPath = string.gsub(path, formattedCwd .. '/', '')
  if formattedPath == '.' then
    return ''
  end
  return formattedPath .. '/'
end

gl.short_line_list = {'NvimTree','vista','dbui','packer'}

gls.left[1] = {
  RainbowRed = {
    provider = function() return '▊ ' end,
    highlight = {colors.blue,colors.bg}
  },
}
gls.left[2] = {
  ViMode = {
    provider = function()
-- auto change color according the vim mode
      local mode_color = {
        n = colors.red,
        i = colors.green,
        v=colors.blue,
        [''] = colors.blue,
        V=colors.blue,
        c = colors.magenta,
        no = colors.red,
        s = colors.orange,
        S=colors.orange,
        [''] = colors.orange,
        ic = colors.yellow,
        R = colors.violet,
        Rv = colors.violet,
        cv = colors.red,
        ce=colors.red,
        r = colors.cyan,
        rm = colors.cyan,
        ['r?'] = colors.cyan,
        ['!']  = colors.red,
        t = colors.red
      }
      vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color[vim.fn.mode()])
      return '  '
    end,
    highlight = { colors.red, colors.bg, 'bold' },
  },
}
-- gls.left[3] = {
--   FileSize = {
--     provider = 'FileSize',
--     condition = condition.buffer_not_empty,
--     highlight = {colors.fg,colors.bg}
--   }
-- }
gls.left[3] = {
  FilePath = {
    provider = getFilePath,
    condition = condition.buffer_not_empty,
    highlight = {colors.magenta,colors.bg,'bold'},
  },
}
gls.left[4] = {
  FileIcon = {
    provider = 'FileIcon' ,
    condition = condition.buffer_not_empty,
    highlight = {require('galaxyline.providers.fileinfo').get_file_icon_color,colors.bg},
  },
}
gls.left[5] = {
  FileName = {
    provider = 'FileName',
    condition = condition.buffer_not_empty,
    highlight = {colors.magenta,colors.bg,'bold'},
    separator_highlight = {'NONE',colors.bg},
    separator = '',
  },
}
gls.left[6] = {
  CurrentFunction = {
    provider = function()
        local current_function = vim.b.lsp_current_function
        if current_function == nil or current_function == '' then
          return ''
        end
        return '𝝺 ' .. vim.b.lsp_current_function .. ' '
      end,
    condition = condition.buffer_not_empty,
    highlight = {colors.blue,colors.bg,'bold'},
    separator_highlight = {'NONE',colors.bg},
    separator = '',
  },
}
gls.left[7] = {
  LineInfo = {
    provider = 'LineColumn',
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.fg,colors.bg},
  },
}
gls.left[8] = {
  PerCent = {
    provider = 'LinePercent',
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.fg,colors.bg,'bold'},
  },
}
gls.left[9] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = {colors.red,colors.bg}
  },
}
gls.left[10] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = {colors.yellow,colors.bg},
  },
}
gls.left[11] = {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '   ',
    highlight = {colors.blue,colors.bg},
  }
}
gls.left[12] = {
  DiagnosticHint = {
    provider = 'DiagnosticHint',
    icon = '  ',
    highlight = {colors.cyan,colors.bg},
  },
}

-- gls.right[1] = {
--   FileEncode = {
--     provider = 'FileEncode',
--     condition = condition.hide_in_width,
--     separator = ' ',
--     separator_highlight = {'NONE',colors.bg},
--     highlight = {colors.green,colors.bg,'bold'}
--   }
-- }

vim.cmd([[highlight Statusline guibg=]] .. colors.bg)
vim.cmd([[highlight Statusline guifg=]] .. colors.bg)

-- gls.right[2] = {
--   FileFormat = {
--     provider = 'FileFormat',
--     condition = condition.hide_in_width,
--     separator = ' ',
--     separator_highlight = {'NONE',colors.bg},
--     highlight = {colors.green,colors.bg,'bold'}
--   }
-- }

gls.right[1] = {
  ShowLspClient = {
    -- provider = 'GetLspClient',
    provider = function ()
      for _, client in pairs(vim.lsp.buf_get_clients()) do
        return ' ' .. client.name
      end
      return ''
    end,
    highlight = {colors.cyan,colors.bg,'bold'},
    separator = ' ',
    separator_highlight = {'NONE', colors.bg},
  }
}
gls.right[2] = {
  GitIcon = {
    provider = function() return '  ' end,
    condition = condition.check_git_workspace,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.violet,colors.bg,'bold'},
  }
}

gls.right[3] = {
  GitBranch = {
    provider = { 'GitBranch', function () return ' ' end },
    condition = condition.check_git_workspace,
    highlight = {colors.violet,colors.bg,'bold'},
  }
}

gls.right[4] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = {colors.green,colors.bg},
  }
}
gls.right[5] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = condition.hide_in_width,
    icon = ' 柳',
    highlight = {colors.orange,colors.bg},
  }
}
gls.right[6] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = {colors.red,colors.bg},
  }
}

gls.right[7] = {
  RainbowBlue = {
    provider = function() return ' ▊' end,
    highlight = {colors.blue,colors.bg}
  },
}

gls.short_line_left[1] = {
  BufferType = {
    provider = 'FileTypeName',
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.blue,colors.bg,'bold'}
  }
}

gls.short_line_left[2] = {
  SFileName = {
    provider =  { getFilePath, 'SFileName' },
    condition = condition.buffer_not_empty,
    highlight = {colors.fg,colors.bg,'bold'}
  }
}

gls.short_line_right[1] = {
  BufferIcon = {
    provider= 'BufferIcon',
    highlight = {colors.fg,colors.bg}
  }
}
