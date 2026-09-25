local parsers = {
  'bash',
  'c',
  'cpp',
  'css',
  'gdscript',
  'html',
  'java',
  'javascript',
  'json',
  'latex',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'toml',
  'tsx',
  'typst',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local ts = require('nvim-treesitter')
      ts.setup({})

      -- Neovim filetype names do not always match parser names.
      vim.treesitter.language.register('latex', 'tex')
      vim.treesitter.language.register('bash', 'sh')
      vim.treesitter.language.register('javascript', 'javascriptreact')
      vim.treesitter.language.register('tsx', 'typescriptreact')

      -- The current nvim-treesitter main branch is an installer/query provider.
      -- Highlighting itself is started through Neovim's native Tree-sitter API.
      if vim.fn.executable('tree-sitter') == 1 then
        ts.install(parsers)
      else
        vim.schedule(function()
          vim.notify(
            'Tree-sitter CLI not found. Install tree-sitter-cli, then run :TSUpdate.',
            vim.log.levels.WARN
          )
        end)
      end

      local group = vim.api.nvim_create_augroup('treesitter_highlighting', { clear = true })

      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        callback = function(args)
          local ok = pcall(vim.treesitter.start, args.buf)
          if ok then
            -- Tree-sitter is the only syntax highlighter in buffers where a
            -- parser exists. Vim regex syntax remains only as a fallback.
            vim.bo[args.buf].syntax = ''
          end
        end,
      })
    end,
  },
}
