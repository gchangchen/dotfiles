set nocompatible
set number
filetype plugin indent on
set history=1000
syntax on
set smartindent
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
set ffs=unix,dos,mac
set nobackup
set nowb
set noswapfile
set nobomb

set guifont=AR\ PL\ UKai\ TW\ MBE\ 12

set ttimeoutlen=50
cmap w!! w !sudo tee >/dev/null %

autocmd FileType c,cpp set foldmethod=syntax
autocmd FileType python set foldmethod=indent

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
