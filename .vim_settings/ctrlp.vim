let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others']

" Default to filename searches - so that appctrl will find application
" controller
let g:ctrlp_by_filename = 1

let g:ctrlp_map = ',t'
nnoremap <silent> <Leader>t :CtrlP<CR>

" Ctrl-P to clear the cache
nnoremap <C-P> :ClearCtrlPCache<cr>
