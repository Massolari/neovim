local getFilePath = function()
  local path = string.gsub(vim.fn.expand("%:h"), '^./', '')
  local formattedCwd = string.gsub(vim.fn.getcwd(), '\\-', '\\-')
  local formattedPath = string.gsub(path, formattedCwd .. '/', '')
  if formattedPath == '.' then
    return ''
  end
  return formattedPath .. '/'
end

local get_color = require'functions'.get_color

local colors = {
  bg       = get_color('CursorLine', 'bg', '#202328'),
  fg       = get_color('Normal', 'fg', '#bbc2cf'),
  yellow   = 'DarkYellow',
  cyan     = '#008080',
  darkblue = '#081633',
  green    = '#98be65',
  orange   = '#FF8800',
  violet   = '#a9a1e1',
  magenta  = '#c678dd',
  blue     = '#51afef',
  red      = '#ec5f67',
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand '%:t') ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
}

local config = {
  options = {
    disabled_filetypes = { 'dashboard' },
    component_separators = '·',
    section_separators = '',
  },
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_v = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end
local function ins_inactive_left(component)
  table.insert(config.inactive_sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end
local function ins_inactive_right(component)
  table.insert(config.inactive_sections.lualine_x, component)
end

ins_left {
  function()
    return '▊'
  end,
  color = { fg = colors.blue }, -- Sets highlighting of component
  padding = { left = 0, right = 1 }, -- We don't need space before this
  separator = ''
}

ins_left {
  getFilePath,
  cond = conditions.buffer_not_empty,
  padding = 0,
  color = {fg = colors.magenta, gui = 'bold'},
  separator = ''
}

ins_left {
  'filetype',
  icon_only = true,
  padding = { left = 0, right = 1 },
  separator = ''
}

ins_left {
  'filename',
  padding = 0,
  color = {fg = colors.magenta, gui = 'bold'},
  separator = ''
}

ins_left {
  function()
    return vim.b.coc_current_function or ''
    -- local current_function = vim.b.coc_current_function
    -- if current_function == nil then
    --   return ''
    -- end
    -- return current_function
  end,
  cond = conditions.buffer_not_empty,
  color = { fg = colors.blue, gui = 'bold' },
  padding = { left = 1, right = 0 },
  -- separator = { left = '', right = '·' }
  separator = ''
}

ins_left { 'location', padding = { left = 1 }, separator = '' }
ins_left { 'progress', padding = {  left = 0, right = 1 }, color = { gui = 'bold' } }
ins_left {
  'diagnostics',
  symbols = { error = ' ', warn = ' ', info = '  ', hint = ' '},
}

ins_right {
  function ()
    return vim.g.coc_status or ''
  end,
  -- 'coc#status',
  color = { fg = colors.cyan },
}


ins_right {
  'branch',
  icon = ' ',
  color = { fg = colors.violet, gui = 'bold' },
  separator = ''
}

ins_right {
  'diff',
  symbols = {
    added = ' ',
    modified = '柳',
    removed = ' ',
  },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red }
  },
  cond = conditions.hide_in_width,
  padding = { right = 1 },
  separator = ''
}

ins_right {
  function()
    return '▊'
  end,
  color = { fg = colors.blue },
  padding = 0,
}

ins_inactive_left {
  getFilePath,
  cond = conditions.buffer_not_empty,
  padding = { left = 1, right = 0 },
  color = { gui = 'bold'},
  separator = ''
}
ins_inactive_left {
  'filetype',
  icon_only = true,
  padding = { left = 0, right = 1 },
  separator = ''
}
ins_inactive_left {
  'filename',
  padding = 0,
  color = { gui = 'bold'},
  separator = ''
}

require'lualine'.setup(config)
