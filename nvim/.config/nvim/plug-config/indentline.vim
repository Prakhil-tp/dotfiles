let g:indentLine_color_dark = 1 
let g:indentLine_char = '┊'
"let g:indentLine_char_list = ['|', '¦', '┆', '┊']
" Disabling indentline for markdown, so that it will not set conceallevel to 2
" for markdow
let g:indentLine_setConceal = 0
autocmd FileType markdown let g:indentLine_enabled=0
