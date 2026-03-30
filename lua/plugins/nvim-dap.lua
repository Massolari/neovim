--- @type LazyPluginSpec
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
  },
  config = function()
    local dap = require("dap")
    -- local dapui = require("dapui")
    -- dapui.setup()
    dap.set_log_level("TRACE")

    dap.adapters.firefox = {
      type = "executable",
      command = "node",
      args = {
        vim.fn.stdpath("data") .. "/mason/packages/firefox-debug-adapter/dist/adapter.bundle.js",
      },
    }

    local configuration = {
      {
        name = "Launch Firefox against Vite",
        type = "firefox",
        request = "launch",
        reAttach = true,
        url = "http://localhost:8084/AdminInterface/ac/", -- Ajuste a porta se necessário
        firefoxExecutable = "/Applications/Firefox.app/Contents/MacOS/firefox", -- Caminho do Firefox no macOS
        pathMappings = {
          {
            url = "http://localhost:8084/AdminInterface/ac/",
            path = "${workspaceFolder}",
          },
        },
      },
    }
    dap.configurations.typescript = configuration
    dap.configurations.typescriptreact = configuration
    dap.configurations.javascript = configuration
    dap.configurations.javascriptreact = configuration

    -- dap.listeners.before.attach.dapui_config = function()
    --   dapui.open()
    -- end
    -- dap.listeners.before.launch.dapui_config = function()
    --   dapui.open()
    -- end
    -- dap.listeners.before.event_terminated.dapui_config = function()
    --   dapui.close()
    -- end
    -- dap.listeners.before.event_exited.dapui_config = function()
    --   dapui.close()
    -- end
  end,
}
