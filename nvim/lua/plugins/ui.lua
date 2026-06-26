return {
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    priority = 700,
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      local function arduino_status()
        if vim.bo.filetype ~= 'arduino' then return '' end
        if vim.fn.exists('*arduino#GetPort') == 0 then return '' end
        local port = vim.fn['arduino#GetPort']()
        local board = vim.g.arduino_board or ''
        local line = string.format('[%s]', board)
        if (vim.g.arduino_programmer or '') ~= '' then
          line = line .. string.format(' [%s]', vim.g.arduino_programmer)
        end
        if port ~= 0 then
          line = line .. string.format(' (%s:%s)', port, vim.g.arduino_serial_baud or '')
        end
        return line
      end

      require('lualine').setup({
        options = {
          icons_enabled = true,
          -- The old config used `theme = 'auto'`; with the real bluz71 nightfly
          -- plugin restored, explicitly selecting lualine's nightfly palette
          -- prevents lazy.nvim/awesome-vim-colorschemes from falling back to a
          -- dull generic palette.
          theme = 'nightfly',
          section_separators = '',
          component_separators = '|',
          disabled_filetypes = {},
          always_divide_middle = true,
          -- Old config used `set laststatus=3` and did not override
          -- lualine's globalstatus option here.
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', { 'diagnostics', sources = { 'coc' } } },
          lualine_c = { 'filename' },
          -- Fixed: no unconditional require('wpm'), since wpm.nvim is not in your requested list.
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename', arduino_status },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = { 'nvim-tree', 'fugitive' },
      })
    end,
  },

  {
    'akinsho/bufferline.nvim',
    version = '*',
    event = 'VeryLazy',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      vim.opt.termguicolors = true

      local none = 'NONE'
      local inactive = '#7c8f8f'
      local selected = '#c3ccdc'
      local changed = '#82aaff'

      require('bufferline').setup({
        options = {
          mode = 'buffers',
          numbers = 'none',
          diagnostics = 'nvim_lsp',
          separator_style = { '', '' },
          indicator = { style = 'none' },
          show_buffer_close_icons = false,
          show_close_icon = false,
          always_show_bufferline = true,
          offsets = {
            {
              filetype = 'NvimTree',
              text = 'File Explorer',
              highlight = 'Directory',
              separator = false,
            },
          },
        },

        highlights = {
          fill = { bg = none },

          background = { fg = inactive, bg = none },
          buffer_visible = { fg = inactive, bg = none },
          buffer_selected = { fg = selected, bg = none, bold = true, italic = true },

          tab = { fg = inactive, bg = none },
          tab_selected = { fg = selected, bg = none, bold = true, italic = true },
          tab_separator = { fg = none, bg = none },
          tab_separator_selected = { fg = none, bg = none },
          tab_close = { fg = inactive, bg = none },

          numbers = { fg = inactive, bg = none },
          numbers_visible = { fg = inactive, bg = none },
          numbers_selected = { fg = selected, bg = none, bold = true, italic = true },

          duplicate = { fg = inactive, bg = none },
          duplicate_visible = { fg = inactive, bg = none },
          duplicate_selected = { fg = selected, bg = none, bold = true, italic = true },

          modified = { fg = changed, bg = none },
          modified_visible = { fg = changed, bg = none },
          modified_selected = { fg = changed, bg = none },

          close_button = { fg = inactive, bg = none },
          close_button_visible = { fg = inactive, bg = none },
          close_button_selected = { fg = selected, bg = none },

          separator = { fg = none, bg = none },
          separator_visible = { fg = none, bg = none },
          separator_selected = { fg = none, bg = none },

          indicator_selected = { fg = none, bg = none },
          trunc_marker = { fg = inactive, bg = none },

          diagnostic = { bg = none },
          diagnostic_visible = { bg = none },
          diagnostic_selected = { bg = none, bold = true, italic = true },

          hint = { bg = none },
          hint_visible = { bg = none },
          hint_selected = { bg = none, bold = true, italic = true },

          info = { bg = none },
          info_visible = { bg = none },
          info_selected = { bg = none, bold = true, italic = true },

          warning = { bg = none },
          warning_visible = { bg = none },
          warning_selected = { bg = none, bold = true, italic = true },

          error = { bg = none },
          error_visible = { bg = none },
          error_selected = { bg = none, bold = true, italic = true },
        },
      })

      local function force_transparent_tabline()
        for _, group in ipairs(vim.fn.getcompletion('BufferLine', 'highlight')) do
          local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
          if ok then
            hl.bg = nil
            hl.ctermbg = nil
            hl.link = nil
            vim.api.nvim_set_hl(0, group, hl)
          else
            vim.api.nvim_set_hl(0, group, { bg = 'NONE' })
          end
        end

        vim.api.nvim_set_hl(0, 'TabLine', { bg = 'NONE' })
        vim.api.nvim_set_hl(0, 'TabLineSel', { bg = 'NONE', bold = true, italic = true })
        vim.api.nvim_set_hl(0, 'TabLineFill', { bg = 'NONE' })

        vim.cmd('redrawtabline')
      end

      force_transparent_tabline()

      vim.api.nvim_create_autocmd({ 'ColorScheme', 'VimEnter', 'BufEnter' }, {
        callback = function()
          vim.schedule(force_transparent_tabline)
        end,
      })

      require('config.colors').apply()
    end,
  },

  {
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    config = function()
      local nvim_notify = require('notify')
      nvim_notify.setup({
        level = 'info',
        stages = 'fade',
        on_open = nil,
        on_close = nil,
        render = 'default',
        timeout = 5000,
        max_width = nil,
        max_height = nil,
        background_colour = '#000000',
        minimum_width = 50,
        icons = {
          ERROR = '',
          WARN = '',
          INFO = '',
          DEBUG = '',
          TRACE = '✎',
        },
      })
      vim.notify = nvim_notify
    end,
  },

  {
    'andweeb/presence.nvim',
    event = 'VeryLazy',
    config = function()
      require('presence'):setup({
        auto_update = true,
        neovim_image_text = 'The One True Text Editor',
        main_image = 'neovim',
        client_id = '793271441293967371',
        log_level = nil,
        debounce_timeout = 10,
        enable_line_number = false,
        blacklist = {},
        buttons = true,
        file_assets = {},
        editing_text = 'Editing %s',
        file_explorer_text = 'Browsing %s',
        git_commit_text = 'Committing changes',
        plugin_manager_text = 'Managing plugins',
        reading_text = 'Reading %s',
        workspace_text = 'Working on %s',
        line_number_text = 'Line %s out of %s',
      })
    end,
  },

  {
    'ghillb/cybu.nvim',
    event = 'VeryLazy',
    config = function()
      require('cybu').setup()
      vim.keymap.set('n', '[b', '<Plug>(CybuPrev)', { silent = true })
      vim.keymap.set('n', ']b', '<Plug>(CybuNext)', { silent = true })
    end,
  },

  {
    'norcalli/nvim-colorizer.lua',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('colorizer').setup()
    end,
  },

  {
    'max397574/colortils.nvim',
    cmd = { 'Colortils', 'ColortilsPicker', 'ColortilsLighten', 'ColortilsDarken' },
    config = function()
      require('colortils').setup({
        register = '+',
        color_preview = '█ %s',
        default_format = 'hex',
        border = 'rounded',
        mappings = {
          increment_big = 'L',
          decrement_big = 'H',
        },
      })
    end,
  },

  {
    'sphamba/smear-cursor.nvim',
    event = 'VeryLazy',
    config = function()
      require('smear_cursor').enabled = true
    end,
  },
}
