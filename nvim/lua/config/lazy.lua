local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = {
    { import = 'plugins.core' },
    { import = 'plugins.coc' },
    { import = 'plugins.telescope' },
    { import = 'plugins.ui' },
    { import = 'plugins.git' },
    { import = 'plugins.tools' },
  },
  defaults = { lazy = true },
  install = { colorscheme = { 'nightfly' } },
  checker = { enabled = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip', 'matchit', 'matchparen', 'netrwPlugin', 'tarPlugin',
        'tohtml', 'tutor', 'zipPlugin',
      },
    },
  },
})
