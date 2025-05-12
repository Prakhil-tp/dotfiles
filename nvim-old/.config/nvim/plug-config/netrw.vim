"Set default width of explorer to make it appear like a sidebar. Also defaults to tree style.
let g:netrw_liststyle = 3
let g:netrw_winsize = 20
let g:netrw_altv = 1         " open splits to the right
let g:netrw_keepdir = 0      " keep the current directory and browsing directory synced 
let g:netrw_banner = 0       "Hide banner inside netrw
let g:netrw_browse_split = 4 "Hide banner inside netrw

" Toggle netrw
noremap <silent> <C-E> :Lexplore<CR>

" key mappings
function! NetrwMapping()
  nmap <buffer> H u
  nmap <buffer> h -^
  nmap <buffer> l <CR>

  nmap <buffer> . gh
  nmap <buffer> P <C-w>z

  nmap <buffer> L <CR>:Lexplore<CR>
	noremap <buffer> <C-l> <C-w>l
endfunction

" call netrw_mapping whenever the vim opens
augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END
