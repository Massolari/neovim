local Terminal = require'toggleterm.terminal'.Terminal

local M = {}
-- Alterar o quickfix
function M.toggle_quickfix ()
  local is_quickfix_open = vim.fn.len(vim.fn.filter(vim.fn.getwininfo(), 'v:val.quickfix && !v:val.loclist')) > 0

  if is_quickfix_open then
    vim.cmd('cclose')
  else
    vim.cmd('botright copen 10')
  end
end

-- Alterar a location list
function M.toggle_location_list ()
  local is_location_list_open = vim.fn.len(vim.fn.filter(vim.fn.getwininfo(), '!v:val.quickfix && v:val.loclist')) > 0

  if is_location_list_open then
    vim.cmd('lclose')
  else
    local status, err = pcall(vim.cmd, 'lopen 10')
    if not status then
      print(err)
    end
  end
end

-- Executar comando tratando parâmetros de input
function M.command_with_args(prompt, default, completion, command)
  local status, input = pcall(vim.fn.input, prompt, '', completion)
  if status == false then
    return
  end

  if input == '' and default ~= nil then
    input = default
  end
  vim.cmd(":" .. command .. " " .. input)
end

-- Criar nova branch e fazer checkout
function M.checkout_new_branch()
  local branch_name = vim.fn.input("New branch name> ")
  if branch_name == "" then
    return
  end
  vim.cmd('echo "\r"')
  vim.cmd("echohl Directory")
  vim.cmd(":Git checkout -b " .. branch_name)
  vim.cmd("echohl None")
end

-- Get the user input for what he wants to search for with vimgrep
-- if it's empty, abort, if it's not empty get the user input for the target folder, if
-- it's not specified, defaults to `git ls-files`
function M.vim_grep()
  local searchStatus, input = pcall(vim.fn.input, 'Search for: ', '')
  if searchStatus == false or input == '' then
    print('Aborted')
    return
  end

  local folderStatus, target = pcall(vim.fn.input, 'Target folder/files (git ls-files): ', '', 'file')
  if folderStatus == false then
    print('Aborted')
    return
  end
  -- local target = vim.fn.input('Target folder/files (git ls-files): ', '', 'file')
  if target == '' then
    target = '`git ls-files`'
  end

  local status, err = pcall(vim.cmd, ':vimgrep /' .. input .. '/gj ' .. target)
  if status == false then
    print(err)
    return
  end
  vim.cmd(':copen')
end

-- Lazygit
local lazygit = Terminal:new({ cmd = 'lazygit', hidden = true, direction = 'float' })

function M.lazygit_toggle()
  lazygit:toggle()
end

-- Get a color form a highlight group
function M.get_color(highlight_group, type, fallback)
  local color = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(highlight_group)), type .. '#')
  if color == '' then
    return fallback
  end
  return color
end


function M.display_image(source)
  local show_image = [[curl -s ]] .. source .. [[ | viu - ]]
  Terminal:new({ cmd = show_image, hidden = true, direction = 'float', close_on_exit = false }):toggle()
end

return M
