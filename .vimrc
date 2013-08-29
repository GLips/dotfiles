let mapleader = ","

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
Bundle 'xenoterracide/html.vim'
Bundle 'tsaleh/vim-matchit'
Bundle 'jpo/vim-railscasts-theme'
Bundle 'altercation/vim-colors-solarized'
Bundle 'godlygeek/tabular'
Bundle 'kien/ctrlp.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'tpope/vim-rails'
Bundle 'aaronjensen/vim-sass-status'
Bundle 'tpope/vim-surround'
Bundle 'airblade/vim-gitgutter'

filetype plugin indent on
" }

" Settings files {
for f in split(glob('~/.vim_settings/*.vim'), '\n')
	exe 'source' f
endfor
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
set expandtab
set tabstop=2
set shiftwidth=2

set nowritebackup
set nobackup
set noswapfile

" Tab completion of :commands
set wildmenu
set wildmode=list:longest

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

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

" Syntax! {
syntax on
au BufRead,BufNewFile,BufWrite {*.less,*.sass,*.scss} set ft=css
au BufRead,BufNewFile,BufWrite {*.coffee,*.json} set ft=javascript

" Markdown files
au BufRead,BufNewFile {*.md} set filetype=markdown
au BufRead,BufNewFile {*.md} setlocal spell
au BufRead,BufNewFile {*.md} setlocal textwidth=80
" }

" Tabular mappings {
if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
endif
" }

set hlsearch
hi Search guibg=Magenta

" Auto-reload after making changes to the .vimrc
au! BufWritePost .vimrc source %
