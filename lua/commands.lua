local functions = require("functions")

-- Fechar todos os buffers exceto o atual
vim.api.nvim_create_user_command("Bdall", "%bd|e#|bd#", { desc = "Fechar todos os outros buffers" })

-- Gerar imagem do código
vim.api.nvim_create_user_command("Silicon", functions.generate_code_image, { range = "%", nargs = "?" })

-- Mostrar histórico de notificações
vim.api.nvim_create_user_command("Notifications", function()
  Snacks.notifier.show_history()
end, {})

vim.api.nvim_create_user_command("Lexy", function(args)
  if args.args == "" then
    local content =
      vim.system({ "curl", "-s", "https://api.github.com/repos/adambard/learnxinyminutes-docs/contents/" }):wait()
    local data = vim.json.decode(content.stdout)
    local files = vim
      .iter(data)
      :filter(function(item)
        return vim.endswith(item.name, ".md")
          and item.name ~= "README.md"
          and item.name ~= "CONTRIBUTING.md"
          and item.name ~= "LICENSE.txt"
      end)
      :map(function(item)
        return item.name:sub(0, -4)
      end)
      :totable()

    vim.ui.select(files, { prompt = "Select a topic:" }, function(choice)
      if choice then
        vim.cmd("Lexy " .. choice)
      end
    end)
    return
  end
  local query = args.args
  vim.cmd("belowright vsplit")
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, buf)
  vim.cmd("r !curl -s https://raw.githubusercontent.com/adambard/learnxinyminutes-docs/master/" .. query .. ".md")
  vim.bo[buf].filetype = "markdown"
  vim.fn.cursor(1, 1)
  vim.keymap.set("n", "q", "<cmd>bd<CR>", { buffer = buf, silent = true })
end, { nargs = "*" })

vim.api.nvim_create_user_command("Tldr", function(args)
  if args.args == "" then
    local content = vim
      .system({
        "curl",
        "-s",
        "https://api.github.com/repos/tldr-pages/tldr/git/trees/fcef55edbc545d32e07dd4d29730cf70ff6a383e",
      })
      :wait()
    local data = vim.json.decode(content.stdout)
    local files = vim
      .iter(data.tree)
      :map(function(item)
        return item.path:sub(0, -4)
      end)
      :totable()

    vim.ui.select(files, { prompt = "Select a topic:" }, function(choice)
      if choice then
        vim.cmd("Tldr " .. choice)
      end
    end)
    return
  end
  local query = args.args
  local topic = "common"
  local subtopic = query
  if query:find("/") then
    local parts = vim.split(query, "/")
    topic = parts[1]
    subtopic = parts[2]
  end
  vim.cmd("belowright vsplit")
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, buf)
  vim.cmd(
    "r !curl -s https://raw.githubusercontent.com/tldr-pages/tldr/master/pages/" .. topic .. "/" .. subtopic .. ".md"
  )
  vim.bo[buf].filetype = "markdown"
  vim.fn.cursor(1, 1)
  vim.keymap.set("n", "q", "<cmd>bd<CR>", { buffer = buf, silent = true })
end, { nargs = "*" })
