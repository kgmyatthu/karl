vim.keymap.set("n", "<leader>dg", ":lua require'dap'.continue()<CR>")
vim.keymap.set("n", "<F5>", ":lua require'dap'.step_over()<CR>")
vim.keymap.set("n", "<F4>", ":lua require'dap'.step_into()<CR>")
vim.keymap.set("n", "<F12>", ":lua require'dap'.step_out()<CR>")
vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set("n", "<leader>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")

local dap = require('dap')

-- nodejs
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {os.getenv('HOME') .. '/opt/vscode-node-debug2/out/src/nodeDebug.js'},
}
dap.configurations.javascript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    processId = require'dap.utils'.pick_process,
  },
}

dap.adapters.chrome = {
    type = "executable",
    command = "node",
    args = {os.getenv("HOME") .. "/opt/vscode-chrome-debug/out/src/chromeDebug.js"} -- TODO adjust
}

-- react jsx,tsx
dap.configurations.javascriptreact = { -- change this to javascript if needed
    {
        type = "chrome",
        request = "attach",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        port = 9222,
        webRoot = "${workspaceFolder}"
    }
}

dap.configurations.typescriptreact = { -- change to typescript if needed
    {
        type = "chrome",
        request = "attach",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        port = 9222,
        webRoot = "${workspaceFolder}"
    }
}
dap.configurations.typescript = { 
    {
        type = "chrome",
        request = "attach",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        port = 9229,
        webRoot = "${workspaceFolder}"
    }
}


 -- don't forget to compile with debug symbols
 dap.adapters.codelldb = function(on_adapter)
   -- This asks the system for a free port
   local tcp = vim.loop.new_tcp()
   tcp:bind('127.0.0.1', 0)
   local port = tcp:getsockname().port
   tcp:shutdown()
   tcp:close()
 
   -- Start codelldb with the port
   local stdout = vim.loop.new_pipe(false)
   local stderr = vim.loop.new_pipe(false)
   local opts = {
     stdio = {nil, stdout, stderr},
     args = {'--port', tostring(port)},
   }
   local handle
   local pid_or_err
   handle, pid_or_err = vim.loop.spawn('/Users/kgmyatthu/.local/share/nvim/mason/bin/codelldb', opts, function(code)
     stdout:close()
     stderr:close()
     handle:close()
     if code ~= 0 then
       print("codelldb exited with code", code)
     end
   end)
   if not handle then
     vim.notify("Error running codelldb: " .. tostring(pid_or_err), vim.log.levels.ERROR)
     stdout:close()
     stderr:close()
     return
   end
   vim.notify('codelldb started. pid=' .. pid_or_err)
   stderr:read_start(function(err, chunk)
     assert(not err, err)
     if chunk then
       vim.schedule(function()
         require("dap.repl").append(chunk)
       end)
     end
   end)
   local adapter = {
     type = 'server',
     host = '127.0.0.1',
     port = port
   }
   -- 💀
   -- Wait for codelldb to get ready and start listening before telling nvim-dap to connect
   -- If you get connect errors, try to increase 500 to a higher value, or check the stderr (Open the REPL)
   vim.defer_fn(function() on_adapter(adapter) end, 2000)
 end
 
 -- don't forget to compile/build with debug symbols, otherwise it won't work.
 dap.configurations.cpp = {
   {
     name = "runit",
     type = "codelldb",
     request = "launch",
     program = function()
       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
     end,
     args = {"--log_level=all"},
     cwd = "${workspaceFolder}",
     stopOnEntry = false,
     terminal = 'integrated',
     pid = function()
             local handle = io.popen('pgrep hw$')
             local result = handle:read()
             handle:close()
             return result
     end
   },
 }

 dap.configurations.c = dap.configurations.cpp
 dap.configurations.h = dap.configurations.cpp
 dap.configurations.rust = dap.configurations.cpp

require('dapui').setup()
require("nvim-dap-virtual-text").setup()

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
vim.keymap.set("n", "<leader>dc", ":lua require'dapui'.close()<CR>")
