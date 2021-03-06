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
Bundle 'edsono/vim-matchit'
Bundle 'jpo/vim-railscasts-theme'
Bundle 'altercation/vim-colors-solarized'
Bundle 'godlygeek/tabular'
Bundle 'kien/ctrlp.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-rails'
Bundle 'aaronjensen/vim-sass-status'
Bundle 'tpope/vim-surround'
Bundle 'airblade/vim-gitgutter'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-sleuth'
Bundle 'kchmck/vim-coffee-script'
Bundle 'mustache/vim-mustache-handlebars'
Bundle 'derekwyatt/vim-scala'
Bundle 'luochen1990/rainbow'
Bundle 'Blackrush/vim-gocode'
Bundle 'jistr/vim-nerdtree-tabs'
Bundle 'bling/vim-airline'
Bundle 'Valloric/YouCompleteMe'
Bundle 'gabrielelana/vim-markdown'
Bundle 'pangloss/vim-javascript'
Bundle 'FelikZ/ctrlp-py-matcher'

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

let g:mustache_abbreviations = 1
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
au BufRead,BufNewFile,BufWrite {*.json} set ft=javascript

" Markdown files
au BufRead,BufNewFile {*.md} set filetype=markdown
au BufRead,BufNewFile {*.md} setlocal spell
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
hi Comment cterm=bold ctermfg=DarkGray

" Auto-reload after making changes to the .vimrc
au! BufWritePost .vimrc source %
