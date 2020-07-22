" Miscellaneous
let g:python_host_prog  = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'
set updatetime=300
set colorcolumn=80
set title nocompatible nowritebackup nobackup
set mouse=a undofile undolevels=1000 undodir=$HOME/.vim/undo
set directory=$HOME/.vim/swap
set path+=** wildmenu
set autoread hidden backspace=indent,eol,start
set splitright splitbelow
set autoindent smartindent copyindent smarttab expandtab
set shiftwidth=4 tabstop=4 softtabstop=4
set hlsearch incsearch ignorecase smartcase
set nowrap number nomodeline ttyfast lazyredraw
set completeopt=noinsert,noselect,menu
filetype off
call plug#begin('~/.vim/plugged')
" utilities
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.local/bin/fzf', 'do': './install --all' }
Plug 'ap/vim-buftabline'
" Git
Plug 'mhinz/vim-signify'
" Lang Packs
Plug 'sheerun/vim-polyglot', { 'do': './build' }
" Aestetics
Plug 'gruvbox-community/gruvbox'
" LSP
Plug 'autozimu/languageclient-neovim', { 'branch': 'next', 'do': 'bash install.sh', }
" Deoplete
if has('nvim')
    Plug 'shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'deoplete-plugins/deoplete-tag'

call plug#end()
filetype plugin indent on
" Theming
set noshowmode noshowcmd laststatus=0 ruler   " hide statusline
set rulerformat=%20(%m%r%w\ %y\ %l/%c%)\        " Modified+FileType+Ruler
set background=dark
syntax on
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
highlight BufTabLineCurrent guifg=#262626 guibg=#8a8a8a
highlight BufTabLineActive  guifg=#898989 guibg=#505050
highlight BufTabLineHidden  guifg=#7c7c7c guibg=#363636
highlight BufTabLineFill    guifg=#1d2021 guibg=NONE
" tabline
let g:buftabline_indicators = 1
let g:buftabline_separators = 1
let g:buftabline_plug_max   = 0
" Git
let g:signify_sign_add               = '>'
let g:signify_sign_delete            = '<'
let g:signify_sign_change            = '~'
" Langs
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types       = 1
let g:go_highlight_fields            = 1
let g:go_highlight_function_calls    = 1
let g:go_highlight_function_parameters  = 1
let g:go_highlight_functions         = 1
let g:go_highlight_generate_tags     = 1
let g:go_highlight_operators         = 1
let g:go_highlight_types             = 1
let g:java_highlight_all    = 1
let g:python_highlight_all  = 1
" FZF fuzzy
let g:fzf_action = {'alt-enter':'vsplit' }
let g:fzf_files_options = "--preview 'if file {1} | grep -Ei \"text|JSON\"; then cat {1} ; fi'"
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
map <leader><leader>      :<C-u>Files<CR>
map <leader>b  :<C-u>Buffers<CR>
map <leader>t      :<C-u>Tags<CR>
" set filetype shortcut
nnoremap <leader>j :<C-u>set ft=
" FUNCTIONS --------------------------------------------------------------------
" Toggle Theme
function! ToggleTheme()
    if &background == 'light'
        set background=dark
        highlight BufTabLineCurrent guifg=#262626 guibg=#8a8a8a
        highlight BufTabLineActive  guifg=#898989 guibg=#505050
        highlight BufTabLineHidden  guifg=#7c7c7c guibg=#363636
        highlight BufTabLineFill    guifg=#1d2021 guibg=NONE
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
        exec "!rm -f ./tags; ctags -R . -a"
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
map <silent> <C-e> :<C-u>call ToggleTheme()<CR>
nnoremap <leader>a  :<C-u>call LintFile()<CR>
nnoremap <leader>A  :<C-u>call LintProject()<CR>
nnoremap <leader>L  :<C-u>call FormatProject()<CR>
nnoremap <leader>T  :<C-u>call TagsProject()<CR>
nnoremap <leader>f  :<C-u>cgete system('grep --exclude tags -Rn ""')<Left><Left><Left>
nnoremap <leader>e  :<C-u>vert copen<BAR>vert resize 80<CR>
" Default IDE-Style keybindings EDMRL, errors, definition, references, rename, format
nnoremap <leader>d  :<C-u>vert stag <c-r>=expand("<cword>")<CR><CR>
nnoremap <leader>m  :<C-u>cgete system('grep --exclude tags -Rn "<c-r>=expand("<cword>")<CR>"')<CR>
nnoremap <leader>r  :<C-u>!grep --exclude tags -Rl <c-r>=expand("<cword>")<CR><BAR>xargs sed -i 's/<c-r>=expand("<cword>")<CR>//g'<Left><Left><Left>
nnoremap <leader>l  :<C-u>mkview<CR>ggVG=:<C-u>loadview<CR>
" Override <leader>l formatting with corresponding formatter for each lang
augroup autoformat_settings
    autocmd! autoformat_settings
    autocmd FileType c,cpp,java   nnoremap <buffer> <leader>l <Esc>:w<CR>:mkview<CR>:%!clang-format -style=Chromium %<CR>:loadview<CR>
    autocmd FileType go           nnoremap <buffer> <leader>l <Esc>:w<CR>:mkview<CR>:%!goimports %<CR>:loadview<CR>
    autocmd FileType json         nnoremap <buffer> <leader>l <Esc>:w<CR>:mkview<CR>:%!jsonlint -f %<CR>:loadview<CR>
    autocmd FileType python       nnoremap <buffer> <leader>l <Esc>:w<CR>:mkview<CR>:%!yapf --style=facebook %<CR>:w<CR>:%!isort -ac -d -y %<CR>:loadview<CR>
    autocmd FileType rust         nnoremap <buffer> <leader>l <Esc>:w<CR>:mkview<CR>:%!rustfmt %<CR>:loadview<CR>
    autocmd FileType sh           nnoremap <buffer> <leader>l <Esc>:w<CR>:mkview<CR>:%!shfmt -s %<CR>:loadview<CR>
augroup end
" LSP SETUP --------------------------------------------------------------------
" Override IDE-Style keybindings EDMRL, errors, definition, references, rename, format
augroup lspbindings
    autocmd! lspbindings
    " IDE-like keybindings
    autocmd Filetype c,cpp,python,go nnoremap <buffer> K  :<C-u>call LanguageClient#textDocument_hover()<CR>
    autocmd Filetype c,cpp,python,go nnoremap <buffer> <leader>d :<C-u>call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>
    autocmd Filetype c,cpp,python,go nnoremap <buffer> <leader>m :<C-u>call LanguageClient#textDocument_references()<CR>
    autocmd Filetype c,cpp,python,go nnoremap <buffer> <leader>r :<C-u>call LanguageClient#textDocument_rename()<CR>
    autocmd Filetype c,cpp,python,go nnoremap <buffer> <leader>h :<C-u>call LanguageClient#textDocument_codeAction()<CR>
augroup end
augroup misc
    autocmd! misc
    " Async enable Deoplete for better performances
    autocmd InsertEnter * call deoplete#enable()
    " Remove trailing whitespaces and lines
    autocmd BufWritePre * silent! :call StripTrailingWhiteSpace()
    " Refresh tags on save
    autocmd BufWritePost * silent! :call GenTags()
augroup end
let g:deoplete#enable_at_startup = 0                " Start on insert mode
" LSP Language Client
let g:LanguageClient_autoStart  = 1
let g:LanguageClient_diagnosticsEnable  = 1
let g:LanguageClient_diagnosticsList = "Location"
let g:LanguageClient_selectionUI = "quickfix"
let g:LanguageClient_serverCommands     = {
            \ 'c': ['clangd'],
            \ 'cpp': ['clangd'],
            \ 'go': ['gopls'],
            \ 'python': ['pyls'],
            \ 'rust': ['rust-analyzer'],
            \}
