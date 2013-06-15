" Now using the middle finger of either hand you can type
" underscores with ctrl-k and dashes with ctrl-d
imap <silent> <C-k> _
imap <silent> <C-d> -

" Tabs {
map <C-t> <Esc>:tabnew<CR>
map <C-l> :tabnext<CR>
map <C-h> :tabprevious<CR>
" }

" Use jj to exit insert mode. Nobody ever types jj.
inoremap jj <Esc>

" Easily get out of auto completed ()'s and such
inoremap <C-g> <Esc>A

" Why shift when you can .. not?
nnoremap ; :

" Change paste--switch the word with the current contents of the register
nmap cp "_cw<C-R>"<Esc>

