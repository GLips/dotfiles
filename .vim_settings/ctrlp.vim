let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'

" Default to filename searches - so that appctrl will find application
" controller
let g:ctrlp_by_filename = 1

let g:ctrlp_map = ',t'
nnoremap <silent> <Leader>t :CtrlP<CR>

" Ctrl-P to clear the cache
nnoremap <C-P> :ClearCtrlPCache<cr>

let g:ctrlp_max_files = 0
let g:ctrlp_max_depth = 100
let g:ctrlp_switch_buffer = 'ET' " Resuse buffers
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
if executable('ag')
  let g:ctrlp_user_command = ['ag %s -l --nocolor -g ""']
endif
