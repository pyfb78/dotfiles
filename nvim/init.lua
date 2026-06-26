-- Lean config that keeps Pavan's requested plugin set.
-- Uses lazy.nvim so the same plugins/configs do not all load during startup.

pcall(vim.loader.enable)

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('config.options')
require('config.keymaps')
require('config.lazy')
