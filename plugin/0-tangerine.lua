vim.opt.termguicolors = true
local function bootstrap (url)
	local name = url:gsub(".*/", "")
	local path = vim.fn.stdpath "data" .. "/site/pack/tangerine/start/" .. name
	if vim.fn.isdirectory(path) == 0 then
		print(name .. ": installing in data dir...")

		vim.fn.system {"git", "clone", "--depth", "1", url, path}

		vim.cmd [[redraw]]
		print(name .. ": finished installing")
	end
end

bootstrap ("https://github.com/udayvir-singh/tangerine.nvim")

bootstrap ("https://github.com/udayvir-singh/hibiscus.nvim")

require'tangerine'.setup{
  -- target = vim.fn.stdpath [[data]] .. "/tangerine",

  -- compile files in &rtp
  rtpdirs = {
    "ftplugin",
  },

  compiler = {
    -- disable popup showing compiled files
    verbose = false,

    -- compile every time changed are made to fennel files or on entering vim
    hooks = { "onsave", "oninit" }
  },
  keymaps = {}
}
-- require'hibiscus'.setup()
