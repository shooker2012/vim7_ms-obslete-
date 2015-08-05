" Copyright (c) 2015
" shooker2012 <lovelywzz@gmail.com>
"
" When open *.vimproj or _vimproj, use some custom settings.
" 
" For Add net type project:
" 1. Write new [Typecustom] for new type.
" 2. Add new map to [TypeMap]
" 3. Add new [TypeAutocmd] for <type>.vimproj

" Do not load a.vim if is has already been loaded.
if exists("loaded_shookerVimProj")
    finish
endif
if (v:progname == "ex")
   finish
endif
let loaded_shookerVimProj = 1

" [TypeCustom]lua
function! <SID>LuaTypeCustom( )
	set grepprg=grep\ -n\ -r\ --include=*.lua\ $*\ *
	" set grepprg=ag\ --column

	let g:agprg="ag --column -G .*\\.lua"

	copen
	autocmd BufRead *.lua UpdateTypesFileOnly

	nnoremap <silent> <F5> :silent !ctags --langdef=MYLUA --langmap=MYLUA:.lua --regex-MYLUA="/^.*\s*function\s*(\w+):(\w+).*$/\2/f/" --regex-MYLUA="/^\s*(\w+)\s*=\s*[0-9]+.*$/\1/e/" --regex-MYLUA="/^.*\s*function\s*(\w+)\.(\w+).*$/\2/f/" --regex-MYLUA="/^.*\s*function\s*(\w+)\s*\(.*$/\1/f/" --regex-MYLUA="/^\s*(\w+)\s*=\s*\{.*$/\1/n/" --regex-MYLUA="/^\s*module\s+\""(\w+)\"".*$/\1/m,module/" --regex-MYLUA="/^\s*module\s+\""[a-zA-Z0-9._]+\.(\w+)\"".*$/\1/m,module/" --languages=MYLUA --excmd=number -R .<CR>
endfunction

" [TypeCustom]py
function! <SID>PythonTypeCustom( )
	" set grepprg=grep\ -n\ -r\ --include=*.lua\ $*\ *

	" let g:agprg="ag --column -G .*\\.lua"

	copen
	autocmd BufRead *.py UpdateTypesFileOnly
endfunction

" [TypeMap]
let dictionary_type_2_func = { }
let dictionary_type_2_func[ "lua" ] = function( "<SID>LuaTypeCustom" )
let dictionary_type_2_func[ "python" ] = function( "<SID>PythonTypeCustom" )

" map quick fix window.
function! s:MapQuickFixWindow()
	botright copen
	nnoremap <silent> <buffer> h  <C-W><CR><C-w>K
	nnoremap <silent> <buffer> H  <C-W><CR><C-w>K<C-w>b
	nnoremap <silent> <buffer> o  <CR>
	" nnoremap <silent> <buffer> t  <C-w><CR><C-w>T
	nnoremap <silent> <buffer> t  ^<C-w>gF:NERDTreeFind<CR><C-W>l:copen<CR><C-W>k
	" nnoremap <silent> <buffer> T  <C-w><CR><C-w>TgT<C-W><C-W>
	nnoremap <silent> <buffer> T  ^<C-w>gF:NERDTreeFind<CR><C-W>l:copen<CR><C-W>kgT
	" nnoremap <silent> <buffer> v  <C-w><CR><C-w>H<C-W>b<C-W>J<C-W>t

	nnoremap <silent> <buffer> e <CR><C-w><C-w>:cclose<CR>'
	nnoremap <silent> <buffer> go <CR>:copen<CR>
	nnoremap <silent> <buffer> q  :cclose<CR>
	nnoremap <silent> <buffer> gv :let b:height=winheight(0)<CR><C-w><CR><C-w>H:copen<CR><C-w>J:exe printf(":normal %d\<lt>c-w>_", b:height)<CR>
endfunc
command! Copen call <SID>MapQuickFixWindow()

"[function]ChangProjDir: When Open .vimproj file, change current directory
"and NerdTree to the folder of the file.
" function! SalChangeProjDir( type, dir )
function! SalChangeProjDir(...)
	if a:0 == 1
		let type = a:{1}
		let isChangeDir = 0
		let dirStr = ""
	elseif a:0 >= 2
		let type = a:{1}
		let isChangeDir = 1
		let dirStr = a:{2}
	endif

	if isChangeDir == 1
		if dirStr == ""
			set noautochdir
			cd %:p:h
			NERDTree %:p:h
		else
			set noautochdir

			echo dirStr
			exe "cd ".dirStr
			exe "NERDTree ".dirStr
		endif

		let g:ctrlp_working_path_mode = 'a'
	endif

	" Project custom config
	if has_key( g:dictionary_type_2_func, type ) == 1
		call g:dictionary_type_2_func[type]( )
	end

	call <SID>MapQuickFixWindow()
endfunc
