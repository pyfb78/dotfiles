return {

  {
    'lewis6991/impatient.nvim',
    lazy = false,
    priority = 2000,
    config = function()
      -- Keep the plugin installed because you requested it, but avoid calling it on
      -- newer Neovim where vim.loader.enable() is the replacement.
      if vim.fn.has('nvim-0.9') == 0 then
        pcall(require, 'impatient')
      end
    end,
  },

  {
    'bluz71/vim-nightfly-guicolors',
    lazy = false,
    priority = 1200,
    init = function()
      vim.opt.background = 'dark'
      vim.opt.termguicolors = true
      vim.g.nightflyCursorColor = false
      vim.g.nightflyItalics = true
      vim.g.nightflyNormalPmenu = false
      vim.g.nightflyNormalFloat = false
      vim.g.nightflyTerminalColors = true
      vim.g.nightflyTransparent = false
      vim.g.nightflyUndercurls = true
      vim.g.nightflyUnderlineMatchParen = false
      vim.g.nightflyVirtualTextColor = false
    end,
    config = function()
      vim.cmd.colorscheme('nightfly')
      require('config.colors').apply()
    end,
  },

  {
    'rafi/awesome-vim-colorschemes',
    lazy = true,
  },

  -- vim-polyglot is intentionally gone. Tree-sitter now owns syntax
  -- highlighting whenever a parser is installed.
  { 'tpope/vim-surround', event = 'VeryLazy' },
  { 'tpope/vim-commentary', event = 'VeryLazy' },

  {
    'jiangmiao/auto-pairs',
    event = 'InsertEnter',
    config = function()
      local function setup_math_pairs()
        vim.b.AutoPairs = vim.fn.AutoPairsDefine({ ['$'] = '$' })
        vim.cmd('silent! call AutoPairsInit()')
      end

      local group = vim.api.nvim_create_augroup('markup_auto_pairs', { clear = true })

      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = { 'tex', 'typst' },
        callback = setup_math_pairs,
      })

      -- FileType may already have fired before auto-pairs lazy-loads.
      if vim.bo.filetype == 'tex' or vim.bo.filetype == 'typst' then
        setup_math_pairs()
      else
        vim.cmd('silent! call AutoPairsInit()')
      end
    end,
  },

  { 'Vimjas/vim-python-pep8-indent', ft = 'python' },
  { 'joom/latex-unicoder.vim', ft = 'tex' },

  {
    'jdhao/better-escape.vim',
    event = 'InsertEnter',
    init = function()
      vim.g.better_escape_interval = 200
      vim.g.better_escape_shortcut = 'fd'
    end,
  },

  { 'ryanoasis/vim-devicons', event = 'VeryLazy' },
  { 'kyazdani42/nvim-web-devicons', lazy = true },

  {
    'lervag/vimtex',
    lazy = false,
    init = function()
      vim.g.tex_flavor = 'latex'

      vim.g.vimtex_quickfix_enabled = 0
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_fold_manual = 1

      vim.g.vimtex_compiler_method = 'latexmk'
      vim.g.vimtex_compiler_latexmk = {
        callback = 1,
        continuous = 1,
        executable = 'latexmk',
        options = {
          '-verbose',
          '-file-line-error',
          '-synctex=1',
          '-interaction=nonstopmode',
        },
      }

      vim.g.vimtex_view_method = 'sioyek'
      vim.g.vimtex_view_sioyek_exe = 'sioyek'
      vim.g.vimtex_view_sioyek_options = ''
      vim.g.vimtex_callback_progpath = vim.fn.exepath('nvim')
    end,
  },

  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'nvim-lua/popup.nvim', lazy = true },
  { 'MunifTanjim/nui.nvim', lazy = true },

  {
    'tpope/vim-dispatch',
    cmd = { 'Dispatch', 'Make', 'Start' },
  },

  {
    'miyakogi/seiya.vim',
    event = 'VeryLazy',
    init = function()
      vim.g.seiya_auto_enable = 1
      vim.g.seiya_target_groups = vim.fn.has('nvim') == 1 and { 'guibg' } or { 'ctermbg' }
    end,
  },
}
