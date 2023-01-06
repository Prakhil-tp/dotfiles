
let g:vimwiki_list = [{'path': '~/documents/notes', 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_ex2syntax = {'.md':'markdown', '.markdown':'markdown', '.mdown':'markdown'}

" Makes markdown links as [text](text.md) instead of [text](text)
let g:vimwiki_markdown_link_ext = 1
let g:taskwiki_markup_syntax = 'markdown'
let g:markdown_folding = 1
let g:vimwiki_key_mappings = { 'table_mappings': 0, 'links': 0 }

nmap <CR> <Plug>VimwikiFollowLink
nmap <Backspace> <Plug>VimwikiGoBackLink
nmap <C-CR> <Plug>VimwikiVSplitLink

