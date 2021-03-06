" Tabs {
map <C-t> <Esc>:tabfind %:h<CR>
map <C-l> :tabnext<CR>
map <C-h> :tabprevious<CR>
" }

" Splits {
" Mac style remappings of alt keys
noremap ˙ <C-w>h
noremap ¬ <C-w>l
noremap ∆ <C-w>j
noremap ˚ <C-w>k
" }

" Splits {
" Mac style mappings to move the current tab to the left and right
nnoremap <silent> Ó :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> Ò :execute 'silent! tabmove ' . tabpagenr()<CR>
" }

" Use jj to exit insert mode. Nobody ever types jj.
inoremap jj <Esc>

" Easily get out of auto completed ()'s and such
inoremap <C-g> <Esc>A

" Why shift when you can .. not?
nnoremap ; :

" make Y consistent with C and D
nnoremap <silent> Y y$

" Change paste--switch the word with the current contents of the register
nmap cp "_cw<C-R>"<Esc>

