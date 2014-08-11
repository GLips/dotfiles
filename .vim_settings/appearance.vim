if has("gui_running")
	let g:solarized_termcolors=256
  let g:solarized_italic=1
  let g:solarized_bold=1
	set t_Co=256
	autocmd VimEnter * set guitablabel=%N:\ %t\ %M
endif

set background=dark
colorscheme solarized
