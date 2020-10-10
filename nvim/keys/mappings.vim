"map <C-n> :NERDTreeToggle<CR> "Nerd tree

" TAB in general mode will move to text buffer
nnoremap <TAB> :bnext<CR>
" SHIFT-TAB will go back
nnoremap <S-TAB> :bprevious<CR>
" Turn of search highlight
nnoremap <leader>/ :nohl<CR>

" Quick search and replace on visual mode
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
