set nocompatible
filetype off

" Vundle {
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Vundle manages Vundle
Bundle 'gmarik/vundle'
" Github sources
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'vim-scripts/AutoClose'
Bundle 'ervandew/supertab'

filetype plugin indent on
" }

" Settings {
set nu " Line numbers
set showcmd " Show current command
set backspace=indent,eol,start " Backspace at start of line goes to end of previous line
set history=1000 " Remember everything.
set laststatus=2 " Always show status bar at the bottom
set autoindent
set cindent
set incsearch " Search as you type

set nowritebackup
set nobackup
set noswapfile

" Tab completion of :commands
set wildmenu
set wildmode=list:longest

" Ignore case when searching unless searching with a capital letter
set ignorecase
set smartcase
" }

" Appearance {
set ruler
set title
set wrap
set cursorline
set scrolloff=5 " Always want some context around the cursor line
" }

" Tabs {
map <C-t> <Esc>:tabnew<CR>
map <C-l> :tabnext<CR>
map <C-h> :tabprevious<CR>
" }

" Syntax! {
syntax on
au BufRead,BufNewFile,BufWrite {*.less,*.sass,*.scss} set ft=css
au BufRead,BufNewFile,BufWrite {*.coffee,*.json} set ft=javascript
" }

" Use jj to exit insert mode. Nobody ever types jj.
inoremap jj <Esc>

" Why shift when you can .. not?
nnoremap ; :

colorscheme railscasts

set hlsearch
hi Search guibg=Magenta

" Auto-reload after making changes to the .vimrc
au! BufWritePost .vimrc source %
