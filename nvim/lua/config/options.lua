local opt = vim.opt

vim.g.python3_host_prog = vim.env.PYTHON3_HOST_PROG or '/usr/bin/python3'

vim.cmd('filetype indent plugin on')

-- Keep Vim's syntax engine available as a fallback for filetypes without an
-- installed Tree-sitter parser. The Tree-sitter FileType autocmd disables
-- regex syntax locally whenever Tree-sitter starts successfully.
vim.cmd('syntax on')

opt.compatible = false
opt.modifiable = true
opt.mouse = 'a'
opt.splitbelow = true
opt.splitright = true
opt.foldmethod = 'indent'
opt.foldlevel = 99
opt.foldcolumn = '0'
opt.foldlevelstart = 99
opt.encoding = 'UTF-8'
opt.termguicolors = true
opt.background = 'dark'
opt.completeopt = { 'menuone', 'noselect' }
opt.laststatus = 3
opt.number = true
opt.relativenumber = true
opt.clipboard:append('unnamedplus')
opt.ruler = true
opt.showcmd = true
opt.swapfile = false
opt.showmode = false
opt.shortmess:append('c')
opt.backspace = { 'indent', 'eol', 'start' }
opt.autoindent = true
opt.smartindent = true
opt.breakindent = true
opt.wrapmargin = 1
opt.formatoptions:append('t')
opt.formatoptions:remove('l')
opt.signcolumn = 'yes'
opt.updatetime = 300
opt.timeoutlen = 400
opt.ignorecase = true
opt.smartcase = true
opt.scrolloff = 6
opt.sidescrolloff = 8
opt.wrap = true
opt.linebreak = true
opt.undofile = true
opt.fillchars = { eob = ' ', fold = ' ', foldopen = ' ', foldsep = ' ', foldclose = ' ' }

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.py', '*.java', '*.cpp', '*.c', '*.rkt', '*.h', '*.tex', '*.vim', '*.vimrc', '*.json', '*.lua' },
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.textwidth = 200000
    vim.bo.expandtab = true
    vim.bo.autoindent = true
    vim.bo.fileformat = 'unix'
    vim.wo.linebreak = true
  end,
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = { '*.css', '*.html', '*.js', '*.ts', '*.jsx', '*.tsx', '*.typ' },
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.textwidth = 200000
    vim.bo.expandtab = true
    vim.bo.autoindent = true
    vim.bo.fileformat = 'unix'
    vim.wo.linebreak = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'tex', 'typst' },
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- i3config highlighting/filetype detection.
vim.api.nvim_create_augroup('i3config_ft_detection', { clear = true })
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  group = 'i3config_ft_detection',
  pattern = vim.fn.expand('~/.config/i3/config'),
  callback = function()
    vim.bo.filetype = 'i3config'
  end,
})

local colors = require('config.colors')
vim.api.nvim_create_autocmd('ColorScheme', { callback = colors.apply })
vim.api.nvim_create_autocmd('VimEnter', { callback = colors.apply })
