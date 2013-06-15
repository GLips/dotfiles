colorscheme solarized
set background=dark

if has("gui_running")
	let g:solarized_termcolors=256
	set t_Co=256
	autocmd VimEnter * set guitablabel=%N:\ %t\ %M
endif

