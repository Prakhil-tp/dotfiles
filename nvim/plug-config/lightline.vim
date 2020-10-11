set laststatus=2
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly' ] ]
      \ },
      \ 'tabline': {
      \   'left': [ ['buffers'] ],
      \   'right': [['gitbranch']]
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel'
      \ },
      \ 'component_function': {
      \   'gitbranch':'gitbranch#name'
      \}
      \ }

" set statusline,tabline backgound as transparent
let s:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette
let s:palette.normal.middle = [ [ 'NONE', 'NONE', 'NONE', 'NONE' ] ]
let s:palette.insert.middle = s:palette.normal.middle
let s:palette.visual.middle = s:palette.normal.middle
let s:palette.inactive.middle = s:palette.normal.middle 
let s:palette.tabline.middle = s:palette.normal.middle

"let g:lightline.separator = { 'left': "\ue0b8", 'right': "\ue0be" }
"let g:lightline.subseparator = { 'left': "\ue0b9", 'right': "\ue0b9" }
"let g:lightline.tabline_separator = { 'left': "\ue0bc", 'right': "\ue0ba" }
"let g:lightline.tabline_subseparator = { 'left': "\ue0bb", 'right': "\ue0bb" }
let g:lightline#bufferline#show_number  = 1
