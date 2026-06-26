return {
  {
    'neoclide/coc.nvim',
    branch = 'release',
    event = { 'BufReadPre', 'BufNewFile' },
    init = function()
      vim.g.coc_global_extensions = {
        'coc-pyright',
        'coc-texlab',
        'coc-clangd',
        'coc-html',
        'coc-tsserver',
        'coc-json',
        'coc-eslint',
        'coc-prettier',
        'coc-tslint-plugin',
        'coc-sh',
        'coc-css',
        'coc-lsp-wl',
        'coc-java',
        'coc-ltex',
        'coc-lua',
      }

      vim.g.SuperTabDefaultCompletionType = ''
      vim.g.coc_snippet_next = '?'
      vim.g.coc_snippet_prev = ''
      vim.g.coc_filetype_map = { tex = 'latex' }
      vim.g.python3_host_prog = vim.env.PYTHON3_HOST_PROG or '/usr/bin/python3'

      vim.opt.backup = false
      vim.opt.writebackup = false
      vim.opt.updatetime = 300
      vim.opt.signcolumn = 'yes'
    end,
    config = function()
      vim.cmd([[
        autocmd FileType scss setlocal iskeyword+=@-@

        function! CheckBackspace() abort
          let col = col('.') - 1
          return !col || getline('.')[col - 1] =~# '\s'
        endfunction

        inoremap <silent><expr> <TAB>
              \ coc#pum#visible() ? coc#pum#next(1) :
              \ CheckBackspace() ? "\<Tab>" :
              \ coc#refresh()
        inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
        inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

        if has('nvim')
          inoremap <silent><expr> <c-space> coc#refresh()
        else
          inoremap <silent><expr> <c-@> coc#refresh()
        endif

        nmap <silent> [g <Plug>(coc-diagnostic-prev)
        nmap <silent> ]g <Plug>(coc-diagnostic-next)
        nmap <silent> gd <Plug>(coc-definition)
        nmap <silent> gy <Plug>(coc-type-definition)
        nmap <silent> gi <Plug>(coc-implementation)
        nmap <silent> gr <Plug>(coc-references)
        nmap <silent> gt :call CocAction('jumpDefinition', 'tabe')<CR>

        nnoremap <silent> K :call ShowDocumentation()<CR>
        function! ShowDocumentation()
          if CocAction('hasProvider', 'hover')
            call CocActionAsync('doHover')
          else
            call feedkeys('K', 'in')
          endif
        endfunction

        autocmd CursorHold * silent call CocActionAsync('highlight')
        nmap <leader>rn <Plug>(coc-rename)
        xmap <leader>f  <Plug>(coc-format-selected)
        nmap <leader>f  <Plug>(coc-format-selected)

        augroup coc_user_config
          autocmd!
          autocmd FileType typescript,json setlocal formatexpr=CocAction('formatSelected')
          autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
          autocmd BufWritePre *.ts,*.tsx silent! CocCommand tsserver.executeFormat
        augroup end

        xmap <leader>a  <Plug>(coc-codeaction-selected)
        nmap <leader>a  <Plug>(coc-codeaction-selected)
        nmap <leader>ac <Plug>(coc-codeaction)
        nmap <leader>qf <Plug>(coc-fix-current)
        nmap <leader>cl <Plug>(coc-codelens-action)

        xmap if <Plug>(coc-funcobj-i)
        omap if <Plug>(coc-funcobj-i)
        xmap af <Plug>(coc-funcobj-a)
        omap af <Plug>(coc-funcobj-a)
        xmap ic <Plug>(coc-classobj-i)
        omap ic <Plug>(coc-classobj-i)
        xmap ac <Plug>(coc-classobj-a)
        omap ac <Plug>(coc-classobj-a)

        if has('nvim-0.4.0') || has('patch-8.2.0750')
          nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
          nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
          inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
          inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
          vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
          vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
        endif

        nmap <silent> <C-s> <Plug>(coc-range-select)
        xmap <silent> <C-s> <Plug>(coc-range-select)

        command! -nargs=0 Format :call CocActionAsync('format')
        command! -nargs=? Fold :call CocAction('fold', <f-args>)
        command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')

        nnoremap <silent><nowait> <space>a :<C-u>CocList diagnostics<CR>
        nnoremap <silent><nowait> <space>e :<C-u>CocList extensions<CR>
        nnoremap <silent><nowait> <space>c :<C-u>CocList commands<CR>
        nnoremap <silent><nowait> <space>o :<C-u>CocList outline<CR>
        nnoremap <silent><nowait> <space>s :<C-u>CocList -I symbols<CR>
        nnoremap <silent><nowait> <space>j :<C-u>CocNext<CR>
        nnoremap <silent><nowait> <space>k :<C-u>CocPrev<CR>
        nnoremap <silent><nowait> <space>p :<C-u>CocListResume<CR>
      ]])
    end,
  },
}
