" Miscellaneous
" exluding vim-yaml from polyglot as it's not working
let g:polyglot_disabled = ['yaml']
let g:python3_host_prog = '/usr/bin/python3'
let g:python_host_prog  = '/usr/bin/python2'
set autoindent
set autoread
set backspace=indent,eol,start
set colorcolumn=80
set copyindent
set cursorline
set encoding=utf8
set expandtab
set formatoptions=tcqj
set grepprg=rg\ --vimgrep\ --smart-case\ --follow
set guioptions=d
set hidden
set hlsearch
set ignorecase
set incsearch
set langnoremap
set langremap
set lazyredraw
set mouse=a
set nobackup
set nocompatible
set nofsync
set nomodeline
set noswapfile
set nowrap
set nowritebackup
set number
set path+=.,**
set scrolloff=8
set shiftwidth=4
set sidescroll=1
set smartcase
set smartindent
set smarttab
set softtabstop=4
set splitbelow
set splitright
set tabstop=4
set title
set ttyfast
set undodir=$HOME/.vim/undo
set undofile
set undolevels=10000
set updatetime=50
set wildignore+=tags
set wildmenu
set wildmode=list:longest,full
set ttimeoutlen=50
" Bottom bar
set noshowmode noshowcmd laststatus=0 ruler   " hide statusline
set rulerformat=%20(%m%r%w\ %y\ %l/%c%)\        " Modified+FileType+Ruler
filetype off
call plug#begin('~/.vim/plugged')
" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
" utilities
Plug 'ap/vim-buftabline'
Plug 'yggdroot/indentLine'
" Fzf
Plug 'junegunn/fzf', { 'dir': '~/.local/bin/fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Lang Packs
Plug 'sheerun/vim-polyglot'
Plug 'stephpy/vim-yaml'
" Aestetics
Plug 'acarapetis/vim-colors-github'
Plug 'tomasiser/vim-code-dark'
" LSP
Plug 'dense-analysis/ale'
Plug 'natebosch/vim-lsc'
" Snippets
Plug 'honza/vim-snippets'
Plug 'phenomenes/ansible-snippets'
Plug 'sirver/ultisnips'
call plug#end()
filetype plugin indent on
syntax on
" Theming
augroup customsyntax
    autocmd! customsyntax
    " Strip whitespaces
    autocmd BufWritePre * %s/\s\+$//e
    autocmd BufWritePre * %s/\($\n\s*\)\+\%$//e
    " Custom syntax highlight
    autocmd Syntax * syntax match myDeclaration '\v[_.[:alnum:]]+(,\s*[_.[:alnum:]]+)*\ze(\s*([-^+|^\/%&]|\*|\<\<|\>\>|\&\^)?\=[^=])'
    autocmd Syntax * syntax match myDeclaration '\v\w+(,\s*\w+)*\ze(\s*:\=)'
    autocmd Syntax * syntax match myFunction    '\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\ze\%([a-zA-Z0-9]*(\)'
augroup end
set background=dark
set termguicolors
colorscheme codedark
highlight myDeclaration     ctermfg=117 guifg=#9CDCFE
highlight myFunction        ctermfg=214 guifg=#fabd2f
" bufline
let g:buftabline_indicators = 1
let g:buftabline_separators = 1
let g:buftabline_plug_max   = 0
" indentline
let g:indentLine_char = '|'
let g:indentLine_concealcursor = ''
let g:indentLine_setConceal = 1
let g:intendLine_faser = 1
set list lcs=tab:\|\  " here is a space
" Langs
let g:ansible_attribute_highlight       = 'ab'
let g:ansible_extra_keywords_highlight  = 1
let g:ansible_name_highlight            = 'd'
let g:ansible_normal_keywords_highlight = 'Constant'
let g:ansible_unindent_after_newline  = 1
let g:ansible_with_keywords_highlight = 'Conditional'
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
let g:java_highlight_all             = 1
let g:java_highlight_java_lang_ids   = 1
let g:python_highlight_all  = 1
let g:yaml_limit_spell      = 1
" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
"""""""""""""""""""""
"       Shortcuts   "
"""""""""""""""""""""
" do last action on a visual selection
vnoremap . :'<,'>:normal .<CR>
" navigate tabs Tab (fw) S-Tab (prev)
map <Tab>   :<C-u>bn<CR>
map <S-Tab> :<C-u>bp<CR>
" C-c close buffer
map <C-c> :<C-u>bp<BAR>sp<BAR>bn<BAR>bd<CR>
" Visual mode, C-c copy line
vnoremap <C-c> :'<,'>w !xclip -sel clip<CR><CR>
" Leader map
let mapleader = ' '
" Utility shortcuts with leader:
map <leader><leader>  :<C-u>Files<CR>
map <leader><tab>  :<C-u>Buffers<CR>
map <leader>t  :<C-u>Tags<CR>
map <leader>s  :<C-u>Snippets<CR>
" set filetype shortcut
nnoremap <leader>ft :<C-u>set ft=
" Code help using external scripts: Lint, Format, DeepTags, Grep, vert-copen
nnoremap <silent> <C-e> :<C-u>call ToggleTheme()<CR>
nnoremap <leader>A  :<C-u>cgete system('lint-project ' . &filetype . " . lint<bar>sort -u")<CR>:copen<CR>
nnoremap <leader>I  :<C-u>call  system('lint-project ' . &filetype . " . format")<CR>
nnoremap <leader>T  :<C-u>call  system('lint-project ' . &filetype . " . tags")<CR>
nnoremap <leader>a  :<C-u>cgete system('lint-project ' . &filetype . " " .  expand('%') . " lint<bar>sort -u")<CR>:copen<CR>
nnoremap <leader>f  :<C-u>vimgrep "" **/*<BAR>copen<C-Left><C-Left><Right>
" Default IDE-Style keybindings EDMRL, errors, definition, references, rename, format
nnoremap <leader>d  :<C-u>vert stag <c-r>=expand("<cword>")<CR><CR>
nnoremap <leader>rf :<C-u>vimgrep "<c-r>=expand("<cword>")<CR> **/*<CR>:copen<CR>
nnoremap <leader>r  :<C-u>!grep --exclude tags -Rl <c-r>=expand("<cword>")<CR><BAR>xargs sed -i 's/<c-r>=expand("<cword>")<CR>//g'<Left><Left><Left>
nnoremap <leader>i  :<C-u>mkview<CR>:%s/\($\n\s*\)\+\%$//e<CR>:%s/\s\+$//e<CR>=G:loadview<CR>
" Override <leader>i formatting with corresponding formatter for each lang
augroup autoformat_settings
    autocmd!
    autocmd FileType c,cpp,objc,objcpp,cc,java nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!clang-format -style=file %<CR>:loadview<CR>
    autocmd FileType go           nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!gofmt -s %<CR>:%!goimports %<CR>:loadview<CR>
    autocmd FileType json         nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!jq .<CR>
    autocmd FileType python       nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!yapf --style=facebook %<CR>:w<CR>:%!isort --ac --float-to-top -d %<CR>:loadview<CR>
    autocmd FileType sh           nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!shfmt -s %<CR>:loadview<CR>
    autocmd FileType terraform    nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:!terraform fmt %<CR>:loadview<CR><CR>
    autocmd FileType yaml         nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:!yamlfmt -w %<CR>:loadview<CR><CR>
    autocmd FileType yaml.ansible nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:!yamlfmt -w %<CR>:loadview<CR><CR>
augroup end
" LSP SETUP --------------------------------------------------------------------
" Override IDE-Style keybindings EDMRL, errors, definition, references, rename, format
augroup lspbindings
    autocmd!
    " IDE-like keybindings
    autocmd Filetype c,cc,cpp,python,go,terraform nnoremap <buffer> <leader>d :<C-u>vert LSClientGoToDefinitionSplit<CR>
    autocmd Filetype c,cc,cpp,python,go,terraform nnoremap <buffer> <leader>m :<C-u>LSClientFindReferences<CR>
    autocmd Filetype c,cc,cpp,python,go,terraform nnoremap <buffer> <leader>r :<C-u>LSClientRename<CR>
    " Add shell and ansible on this one
    autocmd Filetype yaml.ansible nnoremap <buffer> K  :<C-u>!ansible-doc <c-r>=expand("<cword>")<CR><bar>less<CR>
    autocmd Filetype c,cc,cpp,python,go,terraform nnoremap <buffer> K  :<C-u>LSClientShowHover<CR>
augroup end
" FUNCTIONS --------------------------------------------------------------------
" Toggle Theme
function! ToggleTheme()
    if &background == 'light'
        set background=dark
        colorscheme codedark
        highlight myDeclaration     ctermfg=117 guifg=#9CDCFE
        highlight myFunction        ctermfg=214 guifg=#fabd2f
        edit
    else
        set background=light
        colorscheme github
        highlight SpecialKey        guibg=NONE guifg=#CCCCCC ctermbg=NONE ctermfg=252
        highlight myDeclaration     term=bold gui=bold cterm=bold ctermfg=28 guifg=#159828
        highlight myFunction        ctermfg=31 guifg=#0086B3
        edit
    endif
endfunction
" ALE + LSP -------------------------------------------------------------------
let g:ale_enabled           = 1
let g:ale_yaml_yamllint_options     = '-d "{extends: default, rules: {line-length: disable, truthy: disable}}"'
let g:lsc_auto_completeopt='menu,menuone,popup,noselect,noinsert'
let g:lsc_server_commands  = {
            \ 'c' : 'clangd',
            \ 'cc' : 'clangd',
            \ 'cpp' : 'clangd',
            \ 'python': 'pyls',
            \ 'terraform' : 'terraform-ls',
            \ "go": {
            \    "command": "gopls serve",
            \    "log_level": -1,
            \ },
            \}
