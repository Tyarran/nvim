vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.smarttab = true
vim.opt_local.shiftround = true
vim.opt_local.colorcolumn = '120'

-- function! StrTrim(txt)
--   return substitute(a:txt, '^\n*\s*\(.\{-}\)\n*\s*$', '\1', '')
-- endfunction
--
-- let g:syntastic_javascript_checkers = ['eslint']
-- let b:syntastic_javascript_eslint_exec = StrTrim(system('npm-which eslint'))
