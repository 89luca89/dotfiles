source $VIMRUNTIME/defaults.vim
set autoindent copyindent expandtab shiftwidth=4 softtabstop=4 tabstop=4 smartcase smartindent smarttab
set autoread autowrite hidden
set colorcolumn=80 cursorline
set formatoptions=tcqj
set grepprg=grep\ -rn hlsearch ignorecase clipboard+=unnamedplus
set guioptions=d mouse=a
set langnoremap langremap lazyredraw redrawtime=0 ttyfast
set list lcs=tab:\▏\  " here is a space, goes in hand with indentLine
set nomodeline nofsync nowrap noswapfile nowritebackup nobackup noshowmode noshowcmd nofoldenable
set omnifunc=syntaxcomplete#Complete completeopt=menu,menuone,popup,noselect,noinsert
set path+=.,** wildmode=longest:full,full wildignorecase
set splitbelow splitright
set title number encoding=utf8
set undodir=$HOME/.vim/undo undofile undolevels=10000
set laststatus=0 ruler rulerformat=%40(%F%m%r%w\ [%c-%l/%L]\ %y%)\     " Modified+FileType+Ruler
filetype off
call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
" utilities
Plug 'ap/vim-buftabline'
Plug 'yggdroot/indentLine'
" colorscheme
Plug 'cormacrelf/vim-colors-github'
Plug 'tomasr/molokai'
" Fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Lang Packs
Plug 'sheerun/vim-polyglot'
" LSP
Plug 'dense-analysis/ale'
Plug 'natebosch/vim-lsc'
call plug#end()
filetype plugin indent on
syntax on
" Theming
set termguicolors
set background=dark
set t_Co=256
set t_ut=
colorscheme molokai
highlight link myFunction Function
highlight link myDeclaration Identifier
augroup general
    autocmd! general
    " When editing a file, always jump to the last known cursor position.
    autocmd BufReadPost *
                \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
                \ |   exe "normal! g`\""
                \ | endif
    "keep equal proportions when windows resized
    autocmd VimResized * wincmd =
    " Strip whitespaces and extra newlines
    autocmd BufWritePre * if &ft!~?'markdown'|%s/\($\n\s*\)\+\%$//e|endif
    autocmd BufWritePre * if &ft!~?'markdown'|%s/\s\+$//e|endif
    " Custom syntax highlight
    autocmd Syntax * syntax match myDeclaration '\v[_.[:alnum:]]+(,\s*[_.[:alnum:]]+)*\ze(\s*([-^+|^\/%&]|\*|\<\<|\>\>|\&\^)?\=[^=])'
    autocmd Syntax * syntax match myDeclaration '\v\w+(,\s*\w+)*\ze(\s*:\=)'
    autocmd Syntax * syntax match myFunction    '\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\ze\%([a-zA-Z0-9]*(\)'
augroup end
let g:indentLine_fileTypeExclude = ['markdown', 'json']
" Languages
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types       = 1
let g:go_highlight_fields            = 1
let g:go_highlight_function_calls    = 1
let g:go_highlight_function_parameters  = 1
let g:go_highlight_functions         = 1
let g:go_highlight_generate_tags     = 1
let g:go_highlight_operators         = 1
let g:go_highlight_types             = 1
let g:java_highlight_all             = 1
let g:python_highlight_all  = 1
let g:indentLine_char = '▏'
"""""""""""""""""""""
"       Shortcuts   "
"""""""""""""""""""""
map <C-e>   :<C-u>call ToggleTheme()<CR>
" do last action on a visual selection
vnoremap . :normal .<CR>
" navigate tabs Tab (fwd) S-Tab (prev)
map <Tab>   :<C-u>bn<CR>
map <S-Tab> :<C-u>bp<CR>
" C-c close buffer
map <C-c> :<C-u>bp<BAR>sp<BAR>bn<BAR>bd<CR>
" copy to clipboard on a visual selection
vnoremap <C-c> :w !xclip -sel clip<CR><CR>
" Leader map
let mapleader = ' '
" Utility shortcuts with leader:
map <leader><Tab>    :<C-u>Buffers<CR>
map <leader><leader> :<C-u>Files<CR>
map <leader>n  :<C-u>Lexplore<CR>
map <leader>t  :<C-u>Tags<CR>
" Easier completion shortcuts
inoremap <C-L> <C-X><C-L>
inoremap <C-F> <C-X><C-F>
" Code help using external scripts: Lint File, Lint Project, Format, DeepTags, Grep in project
" Default IDE-Style keybindings: definition, indent, rename, references
nnoremap <leader>line  :<C-u>cgete system(&grepprg . ' ".\{100\}" ')<bar>copen<C-Left>
nnoremap <leader>l  :<C-u>cgete system('project-utils ' . &filetype . " " .  expand('%') . " lint")<CR>:copen<CR>
nnoremap <leader>L  :<C-u>cgete system('project-utils ' . &filetype . " . lint")<CR>:copen<CR>
nnoremap <leader>i  :<C-u>mkview<CR>:%s/\($\n\s*\)\+\%$//e<CR>:%s/\s\+$//e<CR>=G:loadview<CR>
nnoremap <leader>I  :<C-u>call system('project-utils ' . &filetype . " . format")<CR>
nnoremap <leader>T  :<C-u>call system('project-utils ' . &filetype . " . tags")<CR>
nnoremap <leader>f  :<C-u>call Grep("")<Left><Left>
nnoremap <leader>r  :<C-u>call Rename("<c-r>=expand("<cword>")<CR>", "")<Left><Left>
nnoremap <leader>rf :<C-u>call Grep("<c-r>=expand("<cword>")<CR>")<CR>
nnoremap <leader>td :<C-u>call Grep("TODO<bar>FIXME")<CR>
nnoremap <leader>gd :<C-u>vert stag <c-r>=expand("<cword>")<CR><CR>
nnoremap <leader>k  :<C-u>call CheatSheet("")<Left><Left>
nnoremap <leader>K  :<C-u>call CheatSheet("<c-r>=expand("<cword>")<CR>")<CR>
" Override <leader>i formatting with corresponding formatter for each lang
augroup autoformat_settings
    autocmd!
    autocmd FileType c,cpp,objc,objcpp,cc,java nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!clang-format -style=file %<CR>:loadview<CR>
    autocmd FileType go           nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!gofmt -s %<CR>:%!goimports %<CR>:loadview<CR>
    autocmd FileType json         nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!jq .<CR>
    autocmd FileType python       nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!yapf --style=facebook %<CR>:w<CR>:%!isort --ac --float-to-top -d %<CR>:loadview<CR>
    autocmd FileType sh           nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!shfmt -s %<CR>:loadview<CR>
    autocmd FileType terraform    nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:!terraform fmt %<CR>:loadview<CR><CR>
augroup end
" LSP SETUP --------------------------------------------------------------------
" Override IDE-Style keybindings: definition, rename, references
augroup lspbindings
    autocmd!
    " IDE-like keybindings
    autocmd Filetype c,cc,cpp,python,go nnoremap <buffer> <leader>gd  :<C-u>vert LSClientGoToDefinitionSplit<CR>
    autocmd Filetype c,cc,cpp,python,go nnoremap <buffer> <leader>r  :<C-u>LSClientRename<CR>
    autocmd Filetype c,cc,cpp,python,go nnoremap <buffer> <leader>rf :<C-u>LSClientFindReferences<CR>
    autocmd Filetype c,cc,cpp,python,go nnoremap <buffer> K  :<C-u>LSClientShowHover<CR>
augroup end
" Fix ansible file detection
augroup ansible_vim_fthosts
    autocmd!
    autocmd BufNewFile,BufRead */*.j2 set filetype=jinja2
    autocmd BufNewFile,BufRead */*inventory*.yml set filetype=yaml.ansible
    autocmd BufNewFile,BufRead */*vars/*/**.yml set filetype=yaml.ansible
    autocmd BufNewFile,BufRead */roles/**/*.yml set filetype=yaml.ansible
augroup END
" ALE + LSP -------------------------------------------------------------------
let g:ale_enabled       = 1
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_save  = 1
let g:ale_yaml_yamllint_options = '-d "{extends: default, rules: {line-length: disable, truthy: disable, key-duplicates: enable, comments: {min-spaces-from-content: 1}}}"'
let g:lsc_auto_completeopt='menu,menuone,popup,noselect,noinsert'
let g:lsc_server_commands  = {
            \ 'c' : 'clangd',
            \ 'cc' : 'clangd',
            \ 'cpp' : 'clangd',
            \ 'python': 'pylsp',
            \ "go": {
                \    "command": "gopls serve",
                \    "log_level": -1,
                \  },
                \}
" FUNCTIONS --------------------------------------------------------------------
function! CheatSheet(query)
    call term_start("sh -c \"curl https://cheat.sh/$(echo " . &filetype . "| cut -d'.' -f2)/$(echo " . a:query . "|tr ' ' '+')\"")
endfunction
function! Grep(...)
    cgetexpr system(&grepprg . ' "' . join(a:000, ' ') . '"' )
    copen
endfunction
function! Rename(old, new)
    call system("grep -rl " . shellescape(a:old) . " | xargs -P9 -I{} sed -i 's/" . shellescape(a:old) . "/" . shellescape(a:new) . "/g' {}")
endfunction
function! ToggleTheme()
    if &background == 'light'
        set background=dark
        colorscheme molokai
    else
        set background=light
        colorscheme github
    endif
    highlight link myFunction Function
    highlight link myDeclaration Identifier
    silent! edit
endfunction
