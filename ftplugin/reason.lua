vim.g.ale_fixers = { reason = { 'refmt' } }
vim.g.ale_linters = { reason = { 'reason-language-server' } }
vim.g.ale_reason_ls_executable = 'reason-language-server'
vim.g.ale_fix_on_save = 1
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.smarttab = true
vim.opt_local.makeprg = 'yarn run build'
