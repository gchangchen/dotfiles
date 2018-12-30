scriptencoding utf-8

" 通用配置[[[1
set nocompatible
set number
filetype plugin indent on
set history=1000
syntax on
"set smartindent
set noexpandtab
set tabstop=4
set shiftwidth=4
set vb t_vb=
set ruler
set showcmd
set nohls
set incsearch
set showmatch
set go=
set nobackup
set nowb
set noswapfile
set nobomb
set autoread
set wildmenu

set ttimeoutlen=100
cmap w!! w !sudo tee >/dev/null %

autocmd BufWritePost $MYVIMRC source $MYVIMRC
autocmd FileType c,cpp,json set foldmethod=syntax
autocmd FileType python,javascript,html set foldmethod=indent
"]]]

" 设置字符编码[[[1
set ffs=unix,dos,mac
if has("multi_byte")
	set encoding=utf-8
	set termencoding=utf-8
	set formatoptions+=mM
	set fencs=utf-8,gbk
	if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
		set ambiwidth=double
	endif
endif

if(has("win32") && has("gui_running"))
	set fenc=cp936
	set fileencodings=cp936,ucs-bom,utf-8
	source $VIMRUNTIME/delmenu.vim
	source $VIMRUNTIME/menu.vim
	language messages zh_CN.utf-8
	source $VIMRUNTIME/vimrc_example.vim
	source $VIMRUNTIME/mswin.vim
	behave mswin
endif
"]]]

" 自动切换fcitx状态 [[[1
let g:inputStatus = 0
function! ImActivateFunc(active)
	if a:active
		if g:inputStatus == 2
			call system("fcitx-remote -o")
		endif
	else
		let g:inputStatus = system("fcitx-remote")
		if g:inputStatus == 2
			call system("fcitx-remote -c")
		endif
	endif
endfunction
if has("xim")
	set iminsert=2
	set imactivatekey=C-space
	set imactivatefunc=ImActivateFunc
	if has("gui_running")
		au InsertEnter * call system("fcitx-remote -t")
	endif
endif

"]]]

" vim-plug [[[1
"call plug#begin('~/.vim/plugged')

"Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }

"call plug#end()
"]]]

" YouCompleteMe [[[1
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
"let g:ycm_add_preview_to_completeopt = 0
"let g:ycm_show_diagnostics_ui = 0
"let g:ycm_server_log_level = 'info'
"let g:ycm_min_num_identifier_candidate_chars = 2
"let g:ycm_collect_identifiers_from_comments_and_strings = 1
"let g:ycm_complete_in_strings=1
let g:ycm_key_invoke_completion = '<c-z>'
set completeopt=menu,menuone

noremap <c-z> <NOP>

let g:ycm_semantic_triggers =  {
			\ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
			\ 'cs,lua,javascript': ['re!\w{2}'],
			\ }

let g:ycm_filetype_whitelist = {
			\ "c":1,
			\ "cpp":1,
			\ "objc":1,
			\ "python":1,
			\ "sh":1,
			\ "zsh":1,
			\ "zimbu":1,
			\ }

"]]]

" vim:fdm=marker:fmr=[[[,]]]
