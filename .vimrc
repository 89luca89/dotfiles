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
Plug 'ap/vim-buftabline'
Plug 'mhinz/vim-signify'
Plug 'yggdroot/indentLine'
" Fzf
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.local/bin/fzf', 'do': './install --all' }
" Lang Packs
Plug 'sheerun/vim-polyglot', { 'tag': 'v4.9.2' }
" Aestetics
Plug 'gruvbox-community/gruvbox'
" LSP
Plug 'dense-analysis/ale'
Plug 'natebosch/vim-lsc'
call plug#end()
filetype plugin indent on
syntax on
" Theming
set noshowmode noshowcmd laststatus=0 ruler   " hide statusline
set rulerformat=%20(%m%r%w\ %y\ %l/%c%)\      " Modified+FileType+Ruler
set background=dark
set termguicolors
augroup customsyntax
    autocmd! customsyntax
    " Custom syntax highlight
    autocmd Syntax * syntax match myFunction    '\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\ze\%(\s*(\)'
    autocmd Syntax * syntax match myDeclaration '\v[_.[:alnum:]]+(,\s*[_.[:alnum:]]+)*\ze(\s*([-^+|^\/%&]|\*|\<\<|\>\>|\&\^)?\=[^=])'
    autocmd Syntax * syntax match myDeclaration '\v\w+(,\s*\w+)*\ze(\s*:\=)'
    autocmd Syntax * highlight myFunction      guifg=#b8bb26
    autocmd Syntax * highlight myDeclaration   guifg=#83a598
augroup end
let g:gruvbox_contrast_dark = "hard"
let g:gruvbox_contrast_light = "hard"
colorscheme gruvbox
highlight Normal          guibg=#1c1c1c
" indentline
let g:indentLine_char = '|'
let g:indentLine_concealcursor = ''
let g:indentLine_setConceal = 1
let g:intendLine_faser = 1
set list lcs=tab:\|\  " here is a space
" tabline
let g:buftabline_indicators = 1
let g:buftabline_plug_max   = 0
let g:buftabline_separators = 1
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
" map <leader><leader>  :<C-u>cgete system("ls -1 --group-directories-first<BAR>xargs -I{} find {} -type f<BAR>xargs -I{} echo '{}:1:1: '")<CR>:copen<CR>G//<backspace>
" map <leader>t  :<C-u>cgete system("cat tags<BAR>grep -v '^!_'<BAR>sort -ru<BAR>awk -F'\t' '{split($5,line,\":\");print $2\":\"line[2]\":0: \"$1}'")<CR>:copen<CR>G//<backspace>
" map <leader>b  :<C-u>buffers<CR>:buffer<space>
map <leader><leader>  :<C-u>Files<CR>
map <leader>t  :<C-u>Tags<CR>
map <leader>b  :<C-u>Buffers<CR>
" set filetype shortcut
nnoremap <leader>j :<C-u>set ft=.jinja2<C-left><right><right><right>
" FUNCTIONS --------------------------------------------------------------------
" Toggle Theme
function! ToggleTheme()
    if &background == 'light'
        set background=dark
        highlight Normal          guibg=#1c1c1c
        highlight myFunction      guifg=#b8bb26
        highlight myDeclaration   guifg=#83a598
    else
        set background=light
        highlight Normal          guibg=#ffffff
        highlight myFunction      guifg=#427b58
        highlight myDeclaration   guifg=#076678
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
" Generate tags
function! GenTags()
    if isdirectory(".git") || filereadable(".project")
        silent!
        exec "!ctags -R . -a"
        redraw!
    endif
endfun
" END FUNCTIONS --------------------------------------------------------------------
" Code help using external scripts: Lint, Format, DeepTags, Grep, vert-copen
nnoremap <silent> <C-e> :<C-u>call ToggleTheme()<CR>
nnoremap <leader>f  :<C-u>cgete system('grep --exclude tags -Rn ""')<BAR>copen<C-Left><Right>
nnoremap <leader>a  :<C-u>call LintFile()<CR>:copen<CR>
nnoremap <leader>A  :<C-u>call LintProject()<CR>:copen<CR>
nnoremap <leader>E  :<C-u>vert copen<BAR>vert resize 80<CR>
nnoremap <leader>L  :<C-u>call FormatProject()<CR>
nnoremap <leader>T  :<C-u>call TagsProject()<CR>
" Default IDE-Style keybindings EDMRL, errors, definition, references, rename, format
nnoremap <leader>d  :<C-u>vert stag <c-r>=expand("<cword>")<CR><CR>
nnoremap <leader>m  :<C-u>cgete system('grep --exclude tags -Rn "<c-r>=expand("<cword>")<CR>"')<CR>:copen<CR>
nnoremap <leader>r  :<C-u>!grep --exclude tags -Rl <c-r>=expand("<cword>")<CR><BAR>xargs sed -i 's/<c-r>=expand("<cword>")<CR>//g'<Left><Left><Left>
nnoremap <leader>l  :<C-u>mkview<CR>ggVG=:<C-u>loadview<CR>
" Override <leader>l formatting with corresponding formatter for each lang
augroup autoformat_settings
    autocmd! autoformat_settings
    autocmd FileType c,cpp        nnoremap <buffer> <leader>l <Esc>:w<CR>:mkview<CR>:%!clang-format -style=file %<CR>:loadview<CR>
    autocmd FileType python       nnoremap <buffer> <leader>l <Esc>:w<CR>:mkview<CR>:%!yapf --style=facebook %<CR>:w<CR>:%!isort --ac --float-to-top -d %<CR>:loadview<CR>
    autocmd FileType go           nnoremap <buffer> <leader>l <Esc>:w<CR>:mkview<CR>:%!gofmt -s %<CR>:%!goimports %<CR>:loadview<CR>
    autocmd FileType json         nnoremap <buffer> <leader>l <Esc>:w<CR>:mkview<CR>:%!jsonlint -f %<CR>:loadview<CR>
    autocmd FileType sh           nnoremap <buffer> <leader>l <Esc>:w<CR>:mkview<CR>:%!shfmt -s %<CR>:loadview<CR>
    autocmd FileType terraform    nnoremap <buffer> <leader>l <Esc>:w<CR>:mkview<CR>:!terraform fmt %<CR>:loadview<CR><CR>
augroup end
" LSP SETUP --------------------------------------------------------------------
" Override IDE-Style keybindings EDMRL, errors, definition, references, rename, format
augroup lspbindings
    autocmd! lspbindings
    " IDE-like keybindings
    autocmd Filetype c,cpp,python,go nnoremap <buffer> K  :<C-u>LSClientShowHover<CR>
    autocmd Filetype c,cpp,python,go nnoremap <buffer> <leader>d :<C-u>vert LSClientGoToDefinitionSplit<CR>
    autocmd Filetype c,cpp,python,go nnoremap <buffer> <leader>m :<C-u>LSClientFindReferences<CR>
    autocmd Filetype c,cpp,python,go nnoremap <buffer> <leader>r :<C-u>LSClientRename<CR>
augroup end
augroup misc
    autocmd! misc
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
" ALE
let g:ale_disable_lsp       = 0
let g:ale_enabled           = 1
let g:ale_fix_on_save       = 1
let g:ale_yaml_yamllint_options     = '-d "{extends: default, rules: {line-length: disable, truthy: disable}}"'
let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace'],}
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
            \}
