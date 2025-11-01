return {
  "lervag/vimtex",
  lazy = false,
  config = function()
    vim.g.vimtex_quickfix_mode = 2
    
    -- 修正编译器配置
    vim.g.vimtex_compiler_latexmk = {
      build_dir = 'build',  -- 使用正确的 build_dir 参数
      options = {
        '-synctex=1',
        '-interaction=nonstopmode',
      },
      engine = 'xelatex',  -- 正确设置引擎
    }
    
    vim.g.vimtex_compiler_auto_compile = true
    
    -- 优化 Skim 配置
    vim.g.vimtex_view_method = 'skim'
    vim.g.vimtex_view_skim_sync = 1  -- 启用同步
    vim.g.vimtex_view_skim_activate = false  -- 避免频繁激活窗口
    
    -- 正向搜索配置
    vim.g.vimtex_view_forward_search_on_startup = true
    
    -- 快捷键
    vim.keymap.set('n', '<leader>ll', '<plug>(vimtex-compile)', { desc = '编译文档' })
    vim.keymap.set('n', '<leader>lv', '<plug>(vimtex-view)', { desc = '打开 Skim 预览' })
    vim.keymap.set('n', '<leader>lc', '<plug>(vimtex-clean)', { desc = '清理编译文件' })
  end
}
