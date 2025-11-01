return {
	"mfussenegger/nvim-dap",
	event = "VeryLazy",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"jay-babu/mason-nvim-dap.nvim",
		"theHamsta/nvim-dap-virtual-text",
		"folke/which-key.nvim", -- 确保 which-key 作为依赖
	},
	config = function()
		local mason_dap = require("mason-nvim-dap")
		local dap = require("dap")
		local ui = require("dapui")
		local dap_virtual_text = require("nvim-dap-virtual-text")

		-- Dap Virtual Text
		dap_virtual_text.setup()
		mason_dap.setup({
			ensure_installed = { "cppdbg" },
			automatic_installation = true,
		})

		dap.adapters.codelldb = {
			type = "executable",
			command = "codelldb", -- 确保这个命令在 PATH 中，或者使用绝对路径
			name = "codelldb",
		}

		-- Configurations
		dap.configurations.cpp = {
			{
				name = "Launch file",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				args = {},

				stopOnEntry = false,
				stopAtEntry = false,

				-- 对于 CodeLLDB，添加这些参数
				initCommands = function()
					-- 跳过系统库和运行时代码
					local commands = {
						"settings set target.skip-prologue true",
						"settings set target.process.thread.step-avoid-regexp ^(.*\\.dylib|.*\\.so|libc\\..*|libpthread\\..*|libstdc\\+\\+\\..*)",
					}
					return commands
				end,
			},
		}

		dap.configurations.c = dap.configurations.cpp

		-- Dap UI
		ui.setup({
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.25 },
						"breakpoints",
						"stacks",
						"watches",
					},
					size = 40,
					position = "left",
				},
				{
					elements = {
						"repl",
						"console",
					},
					size = 0.25,
					position = "bottom",
				},
			},
		})

		vim.fn.sign_define("DapBreakpoint", { text = "🐞" })

		dap.listeners.before.attach.dapui_config = function()
			ui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			ui.open()
		end
		vim.keymap.set("n", "<leader>dU", function()
			ui.close() -- 关闭 DAP UI
			-- 如果也希望同时终止调试，可以取消下一行的注释
			dap.terminate() -- 终止调试会话
		end, { desc = "Close DAP UI" })

		-- WhichKey 键盘映射
		local wk = require("which-key")
		wk.register({
			["<leader>d"] = {
				name = "+debugger",
				t = {
					function()
						require("dap").toggle_breakpoint()
					end,
					"Toggle Breakpoint",
				},
				c = {
					function()
						require("dap").continue()
					end,
					"Continue",
				},
				i = {
					function()
						require("dap").step_into()
					end,
					"Step Into",
				},
				o = {
					function()
						require("dap").step_over()
					end,
					"Step Over",
				},
				u = {
					function()
						require("dap").step_out()
					end,
					"Step Out",
				},
				r = {
					function()
						require("dap").repl.open()
					end,
					"Open REPL",
				},
				l = {
					function()
						require("dap").run_last()
					end,
					"Run Last",
				},
				q = {
					function()
						require("dap").terminate()
						require("dapui").close()
						require("nvim-dap-virtual-text").toggle()
					end,
					"Terminate",
				},
				b = {
					function()
						require("dap").list_breakpoints()
					end,
					"List Breakpoints",
				},
				e = {
					function()
						require("dap").set_exception_breakpoints({ "all" })
					end,
					"Set Exception Breakpoints",
				},
			},
		}, {
			mode = "n",
			nowait = true,
			remap = false,
		})
	end,
}
