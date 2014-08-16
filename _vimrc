" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Jul 02
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set hlsearch

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

set number

set tabstop=4
set shiftwidth=4

"set encoding
set fileencoding=utf-8
set encoding=utf-8
lang messages zh_CN.UTF-8 "解决console输入乱码
set termencoding=utf-8
set fileencodings=utf-8,cp936,ucs-bom,shift-jis,latin1,big5,gb18030,gbk,gb2312

source $VIMRUNTIME/delmenu.vim
set guifont=Consolas:h12
set guifontwide=NSimSun:h12

"remove scratch preview window
set completeopt-=preview

"set list char
set listchars=tab:→→,trail:□

"set swap files directory
set directory=$TEMP

"set backup files directory
set backupdir=$TEMP

"map , to copy and pase
nnoremap <silent> , "*
vnoremap <silent> , "*

"set syntax rules for glsl and hlsl
au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl,*.fsh,*.vsh setf glsl
au BufNewFile,BufRead *.hlsl,*.fx,*.fxh,*.vsh,*.psh setf fx


" [plugin]pathogen config
execute pathogen#infect()

" [plugin]solarized config
syntax enable
set background=dark
colorscheme solarized

" [plugin]commentary config
autocmd FileType lua set commentstring=--\ %s

"[plugin]tagbar config
nnoremap <silent> <F4> :TagbarToggle<CR>

"[plugin]ctags config
set autochdir

"shortcut
nnoremap <silent> <C-l>	:<C-u>nohlsearch<CR><C-l>

" In visual mode, map* and # to search current selected.
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>

function! s:VSetSearch()
	let temp = @s
	norm! gv"sy
	let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
	let @s = temp
endfunction

"map & to :&&. means reapeat the last :substitute command with flags.
nnoremap & :&&<CR>
xnoremap & :&&<CR>

"[plugin]neocomplcache installation
let g:neocomplcache_enable_at_startup = 1

"[plugin]clang_complete
let g:clang_complete_copen=1
let g:clang_periodic_quickfix=1
let g:clang_snippets=1
let g:clang_close_preview=1
let g:clang_use_library=1
let g:clang_library_path="D:\\Program\ Files\ (x86)\\LLVM\\bin"
let g:clang_user_options='-stdlib=libc++ -std=c++11 -IIncludePath'

"[plugin]SuperTab
let g:SuperTabDefaultCompletionType = "<c-n>"
let g:SuperTabContextDefaultCompletionType = "<c-n>"

"[plugin]Tabular
" let g:tabular_loaded = 0

"[plugin]EasyMotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
nmap s <Plug>(easymotion-s)
nmap s <Plug>(easymotion-s2)
let g:EasyMotion_smartcase = 1
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>j <Plug>(easymotion-j)
map <Leader>w <Plug>(easymotion-w)
map <Leader>W <Plug>(easymotion-W)
map <Leader>b <Plug>(easymotion-b)
map <Leader>B <Plug>(easymotion-B)

