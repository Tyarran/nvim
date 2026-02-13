vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.smarttab = true
vim.opt_local.shiftround = true
vim.cmd('syn on')

vim.b.ale_linters = { php = { 'langserver' } }
vim.g.ale_php_langserver_use_global = 1
vim.g.ale_php_langserver_executable = 'php-language-server'
