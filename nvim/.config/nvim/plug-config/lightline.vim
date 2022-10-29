set laststatus=2
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'dracula',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly' ], ['filepath'] ]
      \ },
      \ 'tabline': {
      \   'left': [ ['buffers'] ],
      \   'right': [['gitbranch']]
      \ },
      \ 'component': {
      \   'filepath':'%f'
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel'
      \ },
      \ 'component_function': {
      \   'gitbranch':'gitbranch#name'
      \ }
      \ }

" set statusline,tabline backgound as transparent
let s:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette
let s:palette.normal.middle = [ [ 'NONE', 'NONE', 'NONE', 'NONE' ] ]
let s:palette.insert.middle = s:palette.normal.middle
let s:palette.visual.middle = s:palette.normal.middle
let s:palette.inactive.middle = s:palette.normal.middle 
let s:palette.tabline.middle = s:palette.normal.middle

let g:lightline#bufferline#show_number  = 1
