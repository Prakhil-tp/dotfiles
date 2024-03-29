"map <C-n> :NERDTreeToggle<CR> "Nerd tree


"normal mode
" TAB in general mode will move to text buffer
nnoremap <TAB> :bnext<CR>
" SHIFT-TAB will go back
nnoremap <S-TAB> :bprevious<CR>
" Turn of search highlight
nnoremap <leader>/ :nohl<CR>
" Replace all is aliased with S
nnoremap S :%s//g<left><left>
" autochdir aliased to <space>ad
nnoremap <leader>ad :set autochdir<CR> 

"visual mode
" Quick search and replace on visual mode
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" check syntax hightlight by pressing F1
nm <silent> <F1> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name")
    \ . '> trans<' . synIDattr(synID(line("."),col("."),0),"name")
    \ . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
    \ . ">"<CR>
