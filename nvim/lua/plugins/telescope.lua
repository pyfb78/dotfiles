return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    keys = {
      { 'ff', '<cmd>Telescope find_files hidden=false<CR>', desc = 'Find files' },
      { 'fg', '<cmd>Telescope live_grep hidden=true<CR>', desc = 'Live grep' },
      { 'fb', '<cmd>Telescope buffers hidden=true<CR>', desc = 'Buffers' },
      { 'fh', '<cmd>Telescope help_tags hidden=true<CR>', desc = 'Help tags' },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-lua/popup.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-media-files.nvim',
      'LinArcX/telescope-env.nvim',
      'rcarriga/nvim-notify',
      'kyazdani42/nvim-web-devicons',
    },
    opts = {
      defaults = {
        -- The old file had `preview=false` and then overwrote it with
        -- `preview={treesitter=false}`. This keeps the intended fast behavior.
        preview = false,
        prompt_prefix = ' ',
        selection_caret = '󱞪 ',
        sorting_strategy = 'ascending',
        color_devicons = true,
        layout_config = {
          prompt_position = 'top',
          horizontal = {
            width_padding = 0.04,
            height_padding = 0.1,
            preview_width = 0.6,
          },
          vertical = {
            width_padding = 0.05,
            height_padding = 1,
            preview_height = 0.5,
          },
        },
        dynamic_preview_title = true,
      },
    },
    config = function(_, opts)
      local telescope = require('telescope')
      telescope.setup(opts)
      pcall(telescope.load_extension, 'env')
      pcall(telescope.load_extension, 'media_files')
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'notify')
      pcall(telescope.load_extension, 'lazygit')
    end,
  },
}
