set nocompatible
filetype off

" Set the run time path to Vundle package manager
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Vundle manages Vundle
Bundle 'gmarik/vundle'

" Sexy sexy bundles
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'tpope/vim-fugitive'
"Bundle 'Lokaltog/vim-easymotion' " removes the <number>f{char} from f{char} by showing all possibilities

" required for Vundle
filetype plugin indent on

set nu " Line numbers
set showcmd " Show current command
set backspace=indent,eol,start " Backspace at start of line goes to end of previous line
set history=1000 " Remember everything.
set laststatus=2 " Always show status bar at the bottom

" Tab completion of :commands
set wildmenu
set wildmode=list:longest

" Ignore case when searching unless searching with a capital letter
set ignorecase
set smartcase

" Appearance
set ruler
set title
set wrap
set cursorline
set scrolloff=5 " Always want some context around the cursor line

" Syntax!
syntax on

au BufRead,BufNewFile,BufWrite {*.less,*.sass,*.scss} set ft=css
au BufRead,BufNewFile,BufWrite {*.coffee,*.json} set ft=javascript

" Use jj to exit insert mode. Nobody ever types jj.
inoremap jj <Esc>

colorscheme railscasts

set hlsearch
hi Search guibg=Magenta
