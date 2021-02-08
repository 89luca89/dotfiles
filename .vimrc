" Miscellaneous
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
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
" utilities
Plug 'ap/vim-buftabline'
Plug 'yggdroot/indentLine'
" Fzf
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.local/bin/fzf', 'do': './install --all' }
" Lang Packs
Plug 'sheerun/vim-polyglot', { 'tag': 'v4.9.2' }
" Aestetics
Plug 'acarapetis/vim-colors-github'
Plug 'morhetz/gruvbox'
" LSP
Plug 'dense-analysis/ale'
Plug 'natebosch/vim-lsc'
" Snippets
Plug 'sirver/ultisnips'
Plug 'honza/vim-snippets'
Plug 'phenomenes/ansible-snippets'
call plug#end()
filetype plugin indent on
syntax on
" Theming
augroup customsyntax
    autocmd! customsyntax
    " Custom syntax highlight
    autocmd Syntax * syntax match myDeclaration '\v[_.[:alnum:]]+(,\s*[_.[:alnum:]]+)*\ze(\s*([-^+|^\/%&]|\*|\<\<|\>\>|\&\^)?\=[^=])'
    autocmd Syntax * syntax match myDeclaration '\v\w+(,\s*\w+)*\ze(\s*:\=)'
    autocmd Syntax * syntax match myFunction    '\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\ze\%([a-zA-Z0-9]*(\)'
augroup end
" bufline
let g:buftabline_indicators = 1
let g:buftabline_separators = 1
let g:buftabline_plug_max   = 0
" themes
let g:gruvbox_contrast_dark = "hard"
set background=dark
set termguicolors
colorscheme gruvbox
highlight myDeclaration     ctermfg=117 guifg=#9CDCFE
highlight myFunction        ctermfg=208 guifg=#fe8019
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
" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
"""     Shortcuts   "
" do last action on a visual selection
vnoremap . :'<,'>:normal .<CR>
" navigate tabs Tab (fw) S-Tab (prev)
map <Tab>   :<C-u>bn!<CR>
map <S-Tab> :<C-u>bp!<CR>
" C-c close buffer
map <C-c> :<C-u>bp<BAR>sp<BAR>bn<BAR>bd<CR>
" Visual mode, C-c copy line
vnoremap <C-c> :'<,'>w !xclip -sel clip<CR><CR>
" Leader map
let mapleader = ' '
" Utility shortcuts with leader:
" map <leader><leader>  :<C-u>cgete system("ls -1 --group-directories-first<BAR>xargs -I{} find {} -type f<BAR>xargs -I{} echo '{}:1:1: '")<CR>:copen<CR>G//<backspace>
" map <leader>b  :<C-u>buffers<CR>:buffer<space>
" map <leader>t  :<C-u>cgete system("grep -v '^!_' tags<BAR>sort -ru<BAR>awk -F'\t' '{split($5,line,\":\");print $2\":\"line[2]\":0: \"$1}'")<CR>:copen<CR>G//<backspace>
map <leader><leader>  :<C-u>Files<CR>
map <leader><tab>  :<C-u>Buffers<CR>
map <leader>t  :<C-u>Tags<CR>
map <leader>s  :<C-u>Snippets<CR>
" set filetype shortcut
nnoremap <leader>ft :<C-u>set ft=
" Code help using external scripts: Lint, Format, DeepTags, Grep, vert-copen
nnoremap <silent> <C-e> :<C-u>call ToggleTheme()<CR>
nnoremap <leader>A  :<C-u>call LintProject()<CR>:copen<CR>
nnoremap <leader>L  :<C-u>call FormatProject()<CR>
nnoremap <leader>T  :<C-u>call TagsProject()<CR>
nnoremap <leader>a  :<C-u>call LintFile()<CR>:copen<CR>
nnoremap <leader>f  :<C-u>vimgrep "" **/*<BAR>copen<C-Left><C-Left><Right>
" Default IDE-Style keybindings EDMRL, errors, definition, references, rename, format
nnoremap <leader>d  :<C-u>vert stag <c-r>=expand("<cword>")<CR><CR>
nnoremap <leader>m  :<C-u>vimgrep "<c-r>=expand("<cword>")<CR> **/*<CR>:copen<CR>
nnoremap <leader>r  :<C-u>!grep --exclude tags -Rl <c-r>=expand("<cword>")<CR><BAR>xargs sed -i 's/<c-r>=expand("<cword>")<CR>//g'<Left><Left><Left>
nnoremap <leader>i  :<C-u>mkview<CR>ggVG=:<C-u>loadview<CR>
" Override <leader>i formatting with corresponding formatter for each lang
augroup autoformat_settings
    autocmd!
    autocmd FileType c,cpp        nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!clang-format -style=file %<CR>:loadview<CR>
    autocmd FileType go           nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!gofmt -s %<CR>:%!goimports %<CR>:loadview<CR>
    autocmd FileType json         nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!jsonlint -f %<CR>:loadview<CR>
    autocmd FileType python       nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!yapf --style=facebook %<CR>:w<CR>:%!isort --ac --float-to-top -d %<CR>:loadview<CR>
    autocmd FileType sh           nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!shfmt -s %<CR>:loadview<CR>
    autocmd FileType terraform    nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:!terraform fmt %<CR>:loadview<CR><CR>
augroup end
" LSP SETUP --------------------------------------------------------------------
" Override IDE-Style keybindings EDMRL, errors, definition, references, rename, format
augroup lspbindings
    autocmd!
    " IDE-like keybindings
    autocmd Filetype c,cpp,python,go nnoremap <buffer> <leader>d :<C-u>vert LSClientGoToDefinitionSplit<CR>
    autocmd Filetype c,cpp,python,go nnoremap <buffer> <leader>m :<C-u>LSClientFindReferences<CR>
    autocmd Filetype c,cpp,python,go nnoremap <buffer> <leader>r :<C-u>LSClientRename<CR>
    autocmd Filetype c,cpp,python,go nnoremap <buffer> K  :<C-u>LSClientShowHover<CR>
    " Ansible-doc
    autocmd Filetype yaml.ansible nnoremap <buffer> K  :<C-u>!ansible-doc <c-r>=expand("<cword>")<CR><bar>less<CR>
augroup end
" Fix ansible file detection
augroup ansible_vim_fthosts
    autocmd!
    autocmd BufNewFile,BufRead */*.j2 set filetype=jinja2
    autocmd BufNewFile,BufRead */*inventory*.yml set filetype=yaml.ansible
    autocmd BufNewFile,BufRead */roles/**/*.yml set filetype=yaml.ansible
    autocmd BufNewFile,BufRead */tasks/**/*.yml set filetype=yaml.ansible
    autocmd BufNewFile,BufRead */vars/*/**.yml set filetype=yaml.ansible
    autocmd BufNewFile,BufRead *main*.yml set filetype=yaml.ansible
    autocmd BufNewFile,BufRead hosts set filetype=ini.ansible
augroup END
" ALE + LSP -------------------------------------------------------------------
let g:ale_enabled           = 1
let g:ale_fix_on_save       = 1
let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace'],}
let g:ale_yaml_yamllint_options     = '-d "{extends: default, rules: {line-length: disable, truthy: disable}}"'
let g:lsc_auto_completeopt='menu,menuone,popup,noselect,noinsert'
let g:lsc_server_commands  = {
            \ "python": "pyls",
            \ "go": {
            \    "command": "gopls serve",
            \    "log_level": -1,
            \ },
            \ 'cpp' : {
            \   'name': 'cpp',
            \   'command': 'clangd',
            \ },
            \ 'c' : {
            \   'name': 'c',
            \   'command': 'clangd',
            \ },
            \ 'terraform' : {
            \   'name': 'terraform',
            \   'command': 'terraform-ls',
            \ },
            \}
" FUNCTIONS --------------------------------------------------------------------
" Toggle Theme
function! ToggleTheme()
    if &background == 'light'
        set background=dark
        colorscheme gruvbox
        highlight myDeclaration     ctermfg=117 guifg=#9CDCFE
        highlight myFunction        ctermfg=208 guifg=#fe8019
        edit
    else
        set background=light
        colorscheme github
        highlight SpecialKey        guibg=NONE guifg=#CCCCCC ctermbg=NONE ctermfg=252
        highlight myDeclaration     ctermfg=28 guifg=#159828
        highlight myFunction        ctermfg=88 guifg=#990000
        edit
    endif
endfunction
" Lint the entire project using filetype as reference. out to quickfix
function! LintFile()
    silent!
    cgete system('lint-project ' . &filetype . " " .  expand('%') . " lint | sort -u")
endfun
" Lint the entire project using filetype as reference. out to quickfix
function! LintProject()
    silent!
    cgete system('lint-project ' . &filetype . " . lint | sort -u")
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
