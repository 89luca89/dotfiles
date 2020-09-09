" Miscellaneous
let g:python_host_prog  = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'
set updatetime=300
set colorcolumn=80
set title nocompatible nowritebackup nobackup
set mouse=a undofile undolevels=1000 undodir=$HOME/.vim/undo
set directory=$HOME/.vim/swap
set path+=.,** wildmenu
set autoread hidden backspace=indent,eol,start
set splitright splitbelow
set autoindent smartindent copyindent smarttab expandtab
set shiftwidth=4 tabstop=4 softtabstop=4
set hlsearch incsearch ignorecase smartcase
set nowrap number nomodeline ttyfast lazyredraw
filetype off
call plug#begin('~/.vim/plugged')
" utilities
Plug 'yggdroot/indentLine'
Plug 'ap/vim-buftabline'
Plug 'mhinz/vim-signify'
" Lang Packs
Plug 'sheerun/vim-polyglot'
" Aestetics
Plug 'gruvbox-community/gruvbox'
" LSP
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-tags.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
call plug#end()
filetype plugin indent on
syntax on
" Theming
set noshowmode noshowcmd laststatus=0 ruler   " hide statusline
set rulerformat=%20(%m%r%w\ %y\ %l/%c%)\        " Modified+FileType+Ruler
set background=dark
set termguicolors
augroup customsyntax
    autocmd! customsyntax
    " Custom syntax highlight
    autocmd Syntax * syntax match myFunction '\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\ze\%(\s*(\)'
    autocmd Syntax * syntax match myDeclaration_1 '\v[_.[:alnum:]]+(,\s*[_.[:alnum:]]+)*\ze(\s*([-^+|^\/%&]|\*|\<\<|\>\>|\&\^)?\=[^=])'
    autocmd Syntax * syntax match myDeclaration_2 '\v\w+(,\s*\w+)*\ze(\s*:\=)'
augroup end
highlight link myFunction       Type
highlight link myDeclaration_1  Identifier
highlight link myDeclaration_2  Identifier
let g:gruvbox_contrast_light = 'hard'
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox
" indentline
let g:indentLine_char = '|'
let g:indentLine_concealcursor = ''
let g:indentLine_setConceal = 1
let g:intendLine_faser = 1
set list lcs=tab:\|\  " here is a space
" tabline
let g:buftabline_indicators = 1
let g:buftabline_separators = 1
let g:buftabline_plug_max   = 0
" Langs
let g:ansible_attribute_highlight       = 'ab'
let g:ansible_extra_keywords_highlight  = 1
let g:ansible_name_highlight            = 'd'
let g:ansible_normal_keywords_highlight = 'Special'
let g:ansible_with_keywords_highlight = 'Keyword'
let g:ansible_yamlKeyName = 'yamlKey'
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types       = 1
let g:go_highlight_fields            = 1
let g:go_highlight_function_calls    = 1
let g:go_highlight_function_parameters  = 1
let g:go_highlight_functions         = 1
let g:go_highlight_generate_tags     = 1
let g:go_highlight_operators         = 1
let g:go_highlight_types             = 1
let g:python_highlight_all  = 1
"""     Shortcuts   "
" do last action on a visual selection
vnoremap . :'<,'>:normal .<CR>
" navigate tabs Tab (fw) S-Tab (prev)
map <Tab>   :<C-u>bn!<CR>
map <S-Tab> :<C-u>bp!<CR>
" C-c close buffer
map <C-c> :<C-u>bp<BAR>sp<BAR>bn<BAR>bd<CR>
" Leader map
let mapleader = ' '
" leader y/p to use system clipboard, C-c in vmode for xclip
map <leader>y "+y
map <leader>p "+p
vnoremap <C-c> :'<,'>w !xclip -sel clip<CR><CR>
" " Resize split window horizontally and vertically
map <S-M-Down>  :<C-u>2winc-<CR>
map <S-M-Left>  :<C-u>2winc<<CR>
map <S-M-Right> :<C-u>2winc><CR>
map <S-M-Up>    :<C-u>2winc+<CR>
" Utility shortcuts with leader:
map <leader><leader>  :<C-u>cgete system("ls -1 --group-directories-first<BAR>xargs -I{} find {} -type f<BAR>xargs -I{} echo '{}:1:1: '")<CR>:copen<CR>G//<backspace>
map <leader>t  :<C-u>cgete system("cat tags<BAR>grep -v '^!_'<BAR>sort -ru<BAR>awk -F'\t' '{split($5,line,\":\");print $2\":\"line[2]\":0: \"$1}'")<CR>:copen<CR>G//<backspace>
map <leader>b  :<C-u>buffers<CR>:buffer<space>
" set filetype shortcut
nnoremap <leader>j :<C-u>set ft=.jinja2<C-left><right><right><right>
" FUNCTIONS --------------------------------------------------------------------
" Toggle Theme
function! ToggleTheme()
    if &background == 'light'
        set background=dark
    else
        set background=light
    endif
endfunction
" Lint the entire project using filetype as reference. out to quickfix
function! LintFile()
    silent!
    cgete system('lint-project ' . &filetype . " " .  expand('%') . " lint")
endfun
" Lint the entire project using filetype as reference. out to quickfix
function! LintProject()
    silent!
    cgete system('lint-project ' . &filetype . " . lint")
endfun
" Lint the entire project using filetype as reference. out to quickfix
function! FormatProject()
    silent!
    call system('lint-project ' . &filetype . " . format")
endfun
" Lint the entire project using filetype as reference. out to quickfix
function! TagsProject()
    silent!
    call system('lint-project ' . &filetype . " . tags")
endfun
" Generate tags
function! GenTags()
    if isdirectory(".git") || filereadable(".project")
        silent!
        exec "!ctags -R . -a"
        redraw!
    endif
endfun
" Remove Trailing Spaces and empty lines
function! StripTrailingWhiteSpace()
    " don't strip on these filetypes
    if &ft =~ 'markdown'
        return
    endif
    " Strip trailing spaces
    %s/\s\+$//e
    " Strip ending white lines
    %s/\($\n\s*\)\+\%$//e
    redraw!
endfun
" END FUNCTIONS --------------------------------------------------------------------
" Code help using external scripts: Lint, Format, DeepTags, Grep, vert-copen
nnoremap <silent> <C-e> :<C-u>call ToggleTheme()<CR>
nnoremap <leader>gf  :<C-u>:vertical wincmd f<CR>
nnoremap <leader>a  :<C-u>call LintFile()<CR>:copen<CR>
nnoremap <leader>A  :<C-u>call LintProject()<CR>:copen<CR>
nnoremap <leader>L  :<C-u>call FormatProject()<CR>
nnoremap <leader>T  :<C-u>call TagsProject()<CR>
nnoremap <leader>f  :<C-u>cgete system('grep --exclude tags -Rn ""')<BAR>copen<C-Left><Right>
"<Left><Left><Left>
nnoremap <leader>e  :<C-u>vert copen<BAR>vert resize 80<CR>
" Default IDE-Style keybindings EDMRL, errors, definition, references, rename, format
nnoremap <leader>d  :<C-u>vert stag <c-r>=expand("<cword>")<CR><CR>
nnoremap <leader>m  :<C-u>cgete system('grep --exclude tags -Rn "<c-r>=expand("<cword>")<CR>"')<CR>:copen<CR>
nnoremap <leader>r  :<C-u>!grep --exclude tags -Rl <c-r>=expand("<cword>")<CR><BAR>xargs sed -i 's/<c-r>=expand("<cword>")<CR>//g'<Left><Left><Left>
nnoremap <leader>l  :<C-u>mkview<CR>ggVG=:<C-u>loadview<CR>
" Override <leader>l formatting with corresponding formatter for each lang
augroup autoformat_settings
    autocmd! autoformat_settings
    autocmd FileType c,cpp        nnoremap <buffer> <leader>l <Esc>:w<CR>:mkview<CR>:%!clang-format -style=file %<CR>:loadview<CR>
    autocmd FileType go           nnoremap <buffer> <leader>l <Esc>:w<CR>:mkview<CR>:%!goimports %<CR>:loadview<CR>
    autocmd FileType json         nnoremap <buffer> <leader>l <Esc>:w<CR>:mkview<CR>:%!jsonlint -f %<CR>:loadview<CR>
    autocmd FileType python       nnoremap <buffer> <leader>l <Esc>:w<CR>:mkview<CR>:%!yapf --style=facebook %<CR>:w<CR>:%!isort -ac -d -y %<CR>:loadview<CR>
    autocmd FileType rust         nnoremap <buffer> <leader>l <Esc>:w<CR>:mkview<CR>:%!rustfmt %<CR>:loadview<CR>
    autocmd FileType sh           nnoremap <buffer> <leader>l <Esc>:w<CR>:mkview<CR>:%!shfmt -s %<CR>:loadview<CR>
    autocmd FileType terraform    nnoremap <buffer> <leader>l <Esc>:w<CR>:mkview<CR>:!terraform fmt %<CR>:loadview<CR><CR>
augroup end
" LSP SETUP --------------------------------------------------------------------
" Override IDE-Style keybindings EDMRL, errors, definition, references, rename, format
augroup lspbindings
    autocmd! lspbindings
    " IDE-like keybindings
    autocmd Filetype c,cpp,python,go,rust,terraform nnoremap <buffer> K  :<C-u>LspHover<CR>
    autocmd Filetype c,cpp,python,go,rust,terraform nnoremap <buffer> <leader>a :<C-u>LspDocumentDiagnostics<CR>
    autocmd Filetype c,cpp,python,go,rust,terraform nnoremap <buffer> <leader>d :<C-u>vsplit<BAR>LspDefinition<CR>
    autocmd Filetype c,cpp,python,go,rust,terraform nnoremap <buffer> <leader>m :<C-u>LspReferences<CR>
    autocmd Filetype c,cpp,python,go,rust,terraform nnoremap <buffer> <leader>r :<C-u>LspRename<CR>
augroup end
augroup misc
    autocmd! misc
    " Remove trailing whitespaces and lines
    autocmd BufWritePre * silent! :call StripTrailingWhiteSpace()
    " Refresh tags on save
    autocmd BufWritePost * silent! :call GenTags()
augroup end
" Fix ansible file detection
augroup ansible_vim_fthosts
    autocmd!
    autocmd BufNewFile,BufRead */*inventory*.y*ml set filetype=yaml.ansible
    autocmd BufNewFile,BufRead */roles/**/*.y*ml set filetype=yaml.ansible
    autocmd BufNewFile,BufRead */vars/*/**.y*ml set filetype=yaml.ansible
    autocmd BufNewFile,BufRead *main*.y*ml set filetype=yaml.ansible
    autocmd BufNewFile,BufRead hosts set filetype=ini.ansible
    autocmd BufNewFile,BufRead */*.j2 set filetype=jinja2
augroup END
" Asyncomplete + LSP
" let g:asyncomplete_auto_completeopt  = 0
let g:asyncomplete_smart_completion  = 1
let g:lsp_auto_enable                = 1
let g:lsp_diagnostics_echo_cursor    = 1
let g:lsp_diagnostics_enabled        = 1
let g:lsp_highlights_enabled         = 1
let g:lsp_highlight_references_enabled = 1
let g:lsp_log_file  = expand('/dev/null')
let g:lsp_semantic_enabled     = 1
let g:lsp_signs_enabled        = 1
let g:lsp_virtual_text_enabled = 1
"set completeopt=menu,menuone,popup,noselect,noinsert
"
augroup asyncompleteregister
    autocmd! asyncompleteregister
    " Lang specific keybindings
    autocmd VimEnter * call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
                \ 'name': 'file',
                \ 'whitelist': ['*'],
                \ 'priority': 10,
                \ 'completor': function('asyncomplete#sources#file#completor')
                \ }))
    autocmd VimEnter * call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
                \ 'name': 'tags',
                \ 'whitelist': ['*'],
                \ 'blacklist': ['go'],
                \ 'completor': function('asyncomplete#sources#tags#completor'),
                \ 'config': {
                \    'max_file_size': 50000000,
                \  },
                \ }))
    autocmd VimEnter * call lsp#register_server({
                \ 'name': 'clangd',
                \ 'whitelist': ['c', 'cpp'],
                \ 'cmd': {server_info->['clangd', '-background-index']},
                \ })
    autocmd VimEnter * call lsp#register_server({
                \ 'name': 'gopls',
                \ 'whitelist': ['go'],
                \ 'cmd': {server_info->['/home/luca-linux/.local/go/bin/gopls']},
                \ 'workspace_config': {
                \  'gopls' : {
                \       'hoverKind': "FullDocumentation",
                \       'usePlaceholders': v:true,
                \       'fuzzyMatching': v:true,
                \       'staticcheck': v:true,
                \       'deepCompletion': v:true,
                \       'completionDocumentation': v:true,
                \       'completeUnimported': v:true,
                \       'analyses': {
                \            'fillreturns': v:true,
                \           'undeclarename': v:true,
                \           'unusedparams': v:true,
                \           'nonewvars': v:true,
                \          }
                \     }
                \ },
                \ })
    autocmd VimEnter * call lsp#register_server({
                \ 'name': 'pyls',
                \ 'whitelist': ['python'],
                \ 'cmd': {server_info->['pyls']},
                \ })
    autocmd VimEnter * call lsp#register_server({
                \ 'name': 'rust-analyzer',
                \ 'whitelist': ['rust'],
                \ 'cmd': {server_info->['rust-analyzer']},
                \ })
    autocmd VimEnter * call lsp#register_server({
                \ 'name': 'terraform',
                \ 'whitelist': ['terraform'],
                \ 'cmd': {server_info->['terraform-ls', 'serve']},
                \ })
augroup end
