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

  -- Your old config installed the dedicated bluz71 Nightfly plugin before
  -- setting `colorscheme nightfly`.  v2 accidentally relied on the big
  -- awesome-vim-colorschemes pack, which gives a different palette.
  {
    'bluz71/vim-nightfly-guicolors',
    lazy = false,
    priority = 1200,
    init = function()
      vim.opt.background = 'dark'
      vim.opt.termguicolors = true
      -- Keep the same behavior as the old config: do not enable Nightfly's
      -- global transparent option, because the old config only manually made
      -- a few background/gutter groups transparent after loading the theme.
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

  -- Still installed because you requested it, but lazy so its bundled
  -- colors/nightfly.vim cannot shadow the real bluz71 Nightfly scheme.
  { 'rafi/awesome-vim-colorschemes', lazy = true },

  -- Keep polyglot active for the old syntax/highlight behavior.  Treesitter is
  -- installed but no longer takes over highlighting by default.
  { 'sheerun/vim-polyglot', lazy = false, priority = 900 },
  { 'tpope/vim-surround', event = 'VeryLazy' },
  { 'tpope/vim-commentary', event = 'VeryLazy' },
  { 'jiangmiao/auto-pairs', event = 'InsertEnter' },
  { 'Vimjas/vim-python-pep8-indent', ft = 'python' },
  { 'joom/latex-unicoder.vim', ft = 'tex' },
  { 'jdhao/better-escape.vim', event = 'InsertEnter', init = function()
    vim.g.better_escape_interval = 200
    vim.g.better_escape_shortcut = 'fd'
  end },

  -- Keep both devicon plugins because you explicitly requested both.
  { 'ryanoasis/vim-devicons', event = 'VeryLazy' },
  { 'kyazdani42/nvim-web-devicons', lazy = true },

  {
    'lervag/vimtex',
    ft = 'tex',
    init = function()
      vim.g.vimtex_quickfix_enabled = 0
      vim.g.tex_flavor = 'latex'
      vim.g.vimtex_fold_manual = 1
      vim.g.vimtex_compiler_latexmk = { continuous = 1 }
      vim.g.vimtex_compiler_progname = 'nvr'
      vim.g.vimtex_view_sioyek_exe = 'sioyek'
      vim.g.vimtex_view_method = 'sioyek'
      vim.g.vimtex_compiler_method = 'latexmk'
      vim.g.vimtex_view_sioyek_option = '--reuse-instance'
      vim.g.vimtex_quickfix_mode = 0
    end,
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'tex',
        callback = function()
          if vim.fn.exists('*AutoPairsDefine') == 1 then
            vim.b.AutoPairs = vim.fn.AutoPairsDefine({ ['$'] = '$' })
          end
        end,
      })

      local function tex_focus_vim()
        vim.fn.jobstart({ 'open', '-a', 'kitty' }, { detach = true })
        vim.cmd.redraw()
      end

      vim.api.nvim_create_augroup('vimtex_event_focus1', { clear = true })
      vim.api.nvim_create_autocmd('User', {
        group = 'vimtex_event_focus1',
        pattern = 'VimtexEventViewReverse',
        callback = tex_focus_vim,
      })
      vim.api.nvim_create_augroup('vimtex_event_focus2', { clear = true })
      vim.api.nvim_create_autocmd('User', {
        group = 'vimtex_event_focus2',
        pattern = 'VimtexEventView',
        callback = tex_focus_vim,
      })
      vim.api.nvim_create_augroup('init_vimtex1', { clear = true })
      vim.api.nvim_create_autocmd('User', {
        group = 'init_vimtex1',
        pattern = 'VimtexEventViewReverse',
        callback = function()
          pcall(function() vim.b.vimtex.viewer.xdo_focus_vim() end)
        end,
      })
      vim.api.nvim_create_augroup('init_vimtex', { clear = true })
      vim.api.nvim_create_autocmd('User', {
        group = 'init_vimtex',
        pattern = 'VimtexEventView',
        callback = function()
          pcall(function() vim.b.vimtex.viewer.xdo_focus_vim() end)
        end,
      })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    cmd = { 'TSInstall', 'TSUpdate', 'TSModuleInfo', 'TSBufEnable', 'TSBufDisable' },
    opts = {
      ensure_installed = {
        'bash', 'c', 'cpp', 'css', 'html', 'java', 'javascript', 'json',
        'latex', 'lua', 'markdown', 'python', 'typescript', 'vim', 'vimdoc',
      },
      -- This restores your old colors: vim-polyglot + nightfly handle syntax.
      highlight = { enable = false },
      indent = { enable = false },
      auto_install = false,
    },
    config = function(_, opts)
      local ok, configs = pcall(require, 'nvim-treesitter.configs')
      if ok then configs.setup(opts) end
    end,
  },

  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'nvim-lua/popup.nvim', lazy = true },
  { 'MunifTanjim/nui.nvim', lazy = true },
  { 'tpope/vim-dispatch', cmd = { 'Dispatch', 'Make', 'Start' } },
  { 'miyakogi/seiya.vim', event = 'VeryLazy', init = function()
    vim.g.seiya_auto_enable = 1
    vim.g.seiya_target_groups = vim.fn.has('nvim') == 1 and { 'guibg' } or { 'ctermbg' }
  end },
}
