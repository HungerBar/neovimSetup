return {
	"lervag/vimtex",
	lazy = false,
	init = function()
		vim.g.vimtex_quickfix_mode = 2

		vim.g.vimtex_compiler_latexmk_engines = {
			_ = "-xelatex", -- 指定 latexmk 使用 xelatex 引擎 [citation:2]
		}
		vim.g.vimtex_compiler_latexmk = {
			build_dir = "build",
			options = {
				"-pdfxe", -- 明确表示使用 xelatex 生成 PDF
				"-synctex=1",
				"-interaction=nonstopmode",
				"-file-line-error",
				"-shell-escape", -- 可选
				"-verbose", -- 可选
			},
		}
		-- 问ai问出来的，似乎没啥用
		vim.g.vimtex_compiler_auto_compile = true

		-- Skim 查看器配置
		vim.g.vimtex_view_method = "skim"
		vim.g.vimtex_view_skim_sync = 1
		vim.g.vimtex_view_skim_activate = false

		-- 快捷键映射
		vim.keymap.set("n", "<leader>ll", "<plug>(vimtex-compile)", { desc = "编译文档" })
		vim.keymap.set("n", "<leader>lv", "<plug>(vimtex-view)", { desc = "打开 Skim 预览" })
		vim.keymap.set("n", "<leader>lc", "<plug>(vimtex-clean)", { desc = "清理编译文件" })
	end,
}
