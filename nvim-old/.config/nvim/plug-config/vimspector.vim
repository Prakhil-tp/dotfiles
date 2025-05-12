let g:vimspector_enable_mappings = 'HUMAN'

" :Debug to launch debugger
command! Debug silent! call vimspector#Launch()

" close debugger
nmap <leader>dx :VimspectorReset<CR> 
" :QuitDebug to close debugger
fun! SetupCommandAlias(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun
call SetupCommandAlias("QuitDebug","VimspectorReset")
