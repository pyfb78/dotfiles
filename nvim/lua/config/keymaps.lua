local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map('n', '<Esc>', '<cmd>nohlsearch<CR>', opts)
map('n', '//', '<cmd>nohlsearch<CR>', opts)
map({ 'n', 'v' }, 'j', "v:count ? 'j' : 'gj'", { expr = true, silent = true })
map({ 'n', 'v' }, 'k', "v:count ? 'k' : 'gk'", { expr = true, silent = true })
map({ 'n', 'v' }, '$', "v:count ? '$' : 'g$'", { expr = true, silent = true })
map({ 'n', 'v' }, '^', "v:count ? '^' : 'g^'", { expr = true, silent = true })
map({ 'n', 'v' }, '0', "v:count ? '0' : 'g0'", { expr = true, silent = true })
map('n', '-', 'ddp', opts)
map('n', '_', 'ddkP', opts)
map('n', '<leader>ev', '<cmd>vsplit $MYVIMRC<CR>', opts)
map('n', '<leader>sv', '<cmd>source $MYVIMRC<CR>', opts)
map('n', '<leader>w', '<cmd>set wrap!<CR>', opts)
map('n', '<leader>e', '<cmd>Oil<CR>', opts)

local function run_current_file()
  vim.cmd.write()
  local file = vim.fn.expand('%:p')
  local stem = vim.fn.expand('%:p:r')
  local ft = vim.bo.filetype
  local cmd

  if ft == 'python' then
    cmd = 'python3 ' .. vim.fn.shellescape(file)
  elseif ft == 'cpp' then
    cmd = 'g++ -std=c++17 -Wshadow -Wall -O2 -Wno-unused-result ' .. vim.fn.shellescape(file) .. ' -o ' .. vim.fn.shellescape(stem) .. ' && ' .. vim.fn.shellescape(stem)
  elseif ft == 'c' then
    cmd = 'gcc ' .. vim.fn.shellescape(file) .. ' -o ' .. vim.fn.shellescape(stem) .. ' && ' .. vim.fn.shellescape(stem)
  elseif ft == 'java' then
    cmd = 'javac ' .. vim.fn.shellescape(file) .. ' && java -cp ' .. vim.fn.shellescape(vim.fn.expand('%:p:h')) .. ' ' .. vim.fn.shellescape(vim.fn.expand('%:t:r'))
  elseif ft == 'lua' then
    cmd = 'lua ' .. vim.fn.shellescape(file)
  elseif ft == 'tex' then
    vim.cmd('VimtexCompile')
    return
  elseif ft == 'javascript' or ft == 'html' then
    cmd = 'npm start'
  else
    vim.notify('No runner for filetype: ' .. ft, vim.log.levels.WARN)
    return
  end

  vim.cmd('vsplit')
  vim.cmd('vertical terminal ' .. cmd)
  vim.cmd('startinsert')
end

map('n', '<leader>r', run_current_file, opts)

-- Bufferline navigation
map('n', '<Tab>', '<cmd>BufferLineCycleNext<CR>', opts)
map('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', opts)

-- Jump directly to bufferline slots
map('n', '<leader>1', '<cmd>BufferLineGoToBuffer 1<CR>', opts)
map('n', '<leader>2', '<cmd>BufferLineGoToBuffer 2<CR>', opts)
map('n', '<leader>3', '<cmd>BufferLineGoToBuffer 3<CR>', opts)
map('n', '<leader>4', '<cmd>BufferLineGoToBuffer 4<CR>', opts)
map('n', '<leader>5', '<cmd>BufferLineGoToBuffer 5<CR>', opts)
map('n', '<leader>6', '<cmd>BufferLineGoToBuffer 6<CR>', opts)
map('n', '<leader>7', '<cmd>BufferLineGoToBuffer 7<CR>', opts)
map('n', '<leader>8', '<cmd>BufferLineGoToBuffer 8<CR>', opts)
map('n', '<leader>9', '<cmd>BufferLineGoToBuffer 9<CR>', opts)

-- Pick a buffer visually
map('n', '<leader>bp', '<cmd>BufferLinePick<CR>', opts)

-- Close current buffer
map('n', '<leader>bd', '<cmd>bdelete<CR>', opts)

-- Pick a buffer to close visually
map('n', '<leader>bc', '<cmd>BufferLinePickClose<CR>', opts)

-- Close all other buffers
map('n', '<leader>bo', '<cmd>BufferLineCloseOthers<CR>', opts)

-- Close buffers to the left/right
map('n', '<leader>bl', '<cmd>BufferLineCloseLeft<CR>', opts)
map('n', '<leader>br', '<cmd>BufferLineCloseRight<CR>', opts)
