return {
  {
    'stevearc/oil.nvim',
    cmd = 'Oil',
    keys = {
      { '<leader>e', '<cmd>Oil<CR>', desc = 'Oil file explorer' },
    },
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('oil').setup({
        default_file_explorer = true,
        columns = { 'icon' },
        buf_options = {
          buflisted = false,
          bufhidden = 'hide',
        },
        win_options = {
          wrap = false,
          signcolumn = 'no',
          cursorcolumn = false,
          foldcolumn = '0',
          spell = false,
          list = false,
          conceallevel = 3,
          concealcursor = 'nvic',
        },
        delete_to_trash = false,
        skip_confirm_for_simple_edits = false,
        prompt_save_on_select_new_entry = true,
        cleanup_delay_ms = 2000,
        keymaps = {
          ['g?'] = 'actions.show_help',
          ['<CR>'] = 'actions.select',
          ['<C-v>'] = 'actions.select_vsplit',
          ['<C-s>'] = 'actions.select_split',
          ['<C-t>'] = 'actions.select_tab',
          ['<C-p>'] = 'actions.preview',
          ['<C-c>'] = 'actions.close',
          ['<C-l>'] = 'actions.refresh',
          ['-'] = 'actions.parent',
          ['_'] = 'actions.open_cwd',
          ['`'] = 'actions.cd',
          ['~'] = 'actions.tcd',
          ['gs'] = 'actions.change_sort',
          ['gx'] = 'actions.open_external',
          ['g.'] = 'actions.toggle_hidden',
          ['g\\'] = 'actions.toggle_trash',
        },
        use_default_keymaps = true,
        view_options = {
          show_hidden = true,
          is_hidden_file = function(name)
            return vim.startswith(name, '.')
          end,
          is_always_hidden = function()
            return false
          end,
          sort = {
            { 'type', 'asc' },
            { 'name', 'asc' },
          },
        },
        float = {
          padding = 2,
          max_width = 0,
          max_height = 0,
          border = 'rounded',
          win_options = { winblend = 0 },
          override = function(conf) return conf end,
        },
        preview = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = 0.9,
          min_height = { 5, 0.1 },
          height = nil,
          border = 'rounded',
          win_options = { winblend = 0 },
        },
        progress = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = { 10, 0.9 },
          min_height = { 5, 0.1 },
          height = nil,
          border = 'rounded',
          minimized_border = 'none',
          win_options = { winblend = 0 },
        },
      })
    end,
  },

  {
    'nvim-pack/nvim-spectre',
    cmd = 'Spectre',
    keys = {
      { 'S', '<cmd>lua require("spectre").toggle()<CR>', desc = 'Toggle Spectre' },
      { 'sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', mode = 'n', desc = 'Search current word' },
      { 'sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', mode = 'v', desc = 'Search selection' },
      { 'sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', desc = 'Search current file' },
    },
    dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim' },
    config = function()
      require('spectre').setup()
    end,
  },

  {
    'kevinhwang91/nvim-ufo',
    -- Installed because you requested it, but no longer enabled on every buffer.
    -- This removes the black fold-column stripe while keeping zR/zM available.
    keys = {
      { 'zR', function() require('ufo').openAllFolds() end, desc = 'Open all folds' },
      { 'zM', function() require('ufo').closeAllFolds() end, desc = 'Close all folds' },
    },
    dependencies = { 'kevinhwang91/promise-async' },
    init = function()
      vim.o.foldcolumn = '0'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    config = function()
      vim.o.foldcolumn = '0'
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (' 󰁂 %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end

      require('ufo').setup({
        fold_virt_text_handler = handler,
        provider_selector = function()
          return { 'indent' }
        end,
      })
      require('config.colors').apply()
    end,
  },

  {
    'Pocco81/auto-save.nvim',
    event = { 'InsertLeave', 'TextChanged' },
    config = function()
      -- Use the plugin defaults.  The previous custom table could trip the
      -- plugin's nvim_echo path on some installed versions.
      local ok, autosave = pcall(require, 'auto-save')
      if ok then autosave.setup({}) end
    end,
  },
}
