local M = {}

-- Nightfly is still the real colorscheme. These overrides only fix the
-- editor-side gutter/status-column pieces. Bufferline/title-bar colors live in
-- lua/plugins/ui.lua so manually re-running this function cannot change the
-- title bar after it already looks right.
local sidebar_fg = '#4b6479' -- darker old-looking line-number gray/blue

local transparent_groups = {
  -- Exact groups from the old settings.vim.
  'Normal',
  'Folded',
  'NonText',
  'SpecialKey',
  'VertSplit',
  'WinSeparator',
  'EndOfBuffer',

  -- Gutter/status-column groups.
  'SignColumn',
  'FoldColumn',
  'StatusColumn',
  'CursorLineSign',
  'CursorLineFold',
}

local line_number_groups = {
  'LineNr',
  'LineNrAbove',
  'LineNrBelow',
  'CursorLineNr',
}

local function hi(cmd)
  pcall(vim.cmd, cmd)
end

function M.apply()
  hi('highlight Comment cterm=italic gui=italic')

  for _, group in ipairs(transparent_groups) do
    hi(('highlight %s guibg=none ctermbg=none'):format(group))
  end

  -- Force all relative/current line numbers to the old darker gutter color.
  -- Newer Neovim has LineNrAbove/LineNrBelow, which otherwise makes relative
  -- numbers noticeably brighter than your old setup.
  for _, group in ipairs(line_number_groups) do
    pcall(vim.api.nvim_set_hl, 0, group, { fg = sidebar_fg, bg = 'NONE' })
  end

  pcall(vim.api.nvim_set_hl, 0, 'SignColumn', { fg = sidebar_fg, bg = 'NONE' })
  pcall(vim.api.nvim_set_hl, 0, 'FoldColumn', { fg = sidebar_fg, bg = 'NONE' })
  pcall(vim.api.nvim_set_hl, 0, 'StatusColumn', { fg = sidebar_fg, bg = 'NONE' })

  -- Original: lua vim.api.nvim_set_hl(0, "TelescopeBorder", {ctermbg=220})
  -- Keep it cterm-only so GUI colors still come from Nightfly.
  pcall(vim.api.nvim_set_hl, 0, 'TelescopeBorder', { ctermbg = 220 })
end

return M
