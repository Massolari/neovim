vim.opt.termguicolors = true
local function bootstrap (name, url, path)
	if vim.fn.isdirectory(path) == 0 then
		print(name .. ": installing in data dir...")

		vim.fn.system {"git", "clone", "--depth", "1", url, path}

		vim.cmd [[redraw]]
		print(name .. ": finished installing")
	end
end

bootstrap (
  "tangerine.nvim",
  "https://github.com/udayvir-singh/tangerine.nvim",
  vim.fn.stdpath "data" .. "/site/pack/packer/start/tangerine.nvim"
)

bootstrap (
  "hibiscus.nvim",
  "https://github.com/udayvir-singh/hibiscus.nvim",
  vim.fn.stdpath "data" .. "/site/pack/packer/start/hibiscus.nvim"
)

require'tangerine'.setup{
  -- target = vim.fn.stdpath [[data]] .. "/tangerine",

  -- compile files in &rtp
  -- rtpdirs = {
  --   "plugin",
  -- },

  compiler = {
    -- disable popup showing compiled files
    verbose = false,

    -- compile every time changed are made to fennel files or on entering vim
    hooks = { "onsave", "oninit" }
  }
}
-- require'hibiscus'.setup()
