"Latex Config
let g:vimtex_quickfix_enabled = 0
let g:tex_flavor  = 'latex'
let g:vimtex_fold_manual = 1
let g:vimtex_compiler_latexmk = {
        \ 'continuous' : 1,
        \}
let g:vimtex_compiler_progname = 'nvr'
" use skim if you are on Mac
" zathura can be downloaded on latex with the command 'sudo pacman -S zathura'
" let g:vimtex_view_sioyek_exe = '/Applications/sioyek.app/Contents/MacOS/sioyek'
" configure sioyek /etc/sioyek
let g:vimtex_view_sioyek_exe = 'sioyek'
let g:vimtex_view_method = 'sioyek'
" let g:vimtex_view_method = "zathura"
let g:vimtex_compiler_method = "latexmk"
let g:vimtex_view_sioyek_option='--reuse-instance'
" let g:vimtex_callback_progpath ='/opt/homebrew/bin/nvim'
" let g:vimtex_view_method = 'zathura'
"switch back to this one later when it is fixed
" let g:vimtex_view_skim_sync = 1 # Value 1 allows forward search after every successful compilation
" let g:vimtex_view_skim_activate = 1 # Value 1 allows change focus to skim after command `:VimtexView` is given
" let g:vimtex_view_skim_sync = 1
" let g:vimtex_view_skim_activate = 1
" let g:vimtex_view_sioyek_option='--reuse-instance'
" let g:vimtex_view_general_hook_view = 's:TexFocusVim' 
" let g:vimtex_view_automatic = 0
au FileType tex let b:AutoPairs = AutoPairsDefine({'$':'$'})

" bring focus back to neovim after inverse or backward search

function! s:TexFocusVim() abort
  " Replace `TERMINAL` with the name of your terminal application
  " Example: execute "!open -a iTerm"  
  " Example: execute "!open -a Alacritty"
  silent execute "!open -a kitty"
  redraw!
endfunction

augroup vimtex_event_focus1
  au!
  au User VimtexEventViewReverse call s:TexFocusVim()
augroup END

augroup vimtex_event_focus2
  au!
  au User VimtexEventView call s:TexFocusVim()
augroup END

augroup init_vimtex1
  autocmd!
  autocmd User VimtexEventViewReverse call b:vimtex.viewer.xdo_focus_vim()
augroup END

augroup init_vimtex
  autocmd!
  autocmd User VimtexEventView call b:vimtex.viewer.xdo_focus_vim()
augroup END

let g:vimtex_quickfix_mode = 0
