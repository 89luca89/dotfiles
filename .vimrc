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
Plug 'rakr/vim-one'
" LSP
Plug 'autozimu/languageclient-neovim', { 'branch': 'next', 'do': 'bash install.sh', }
" Deoplete + Dependencies
Plug 'shougo/deoplete.nvim'
Plug 'deoplete-plugins/deoplete-tag'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
call plug#end()

call plug#end()
filetype plugin indent on
syntax on
" tabline
let g:buftabline_indicators = 1
let g:buftabline_separators = 1
let g:buftabline_plug_max   = 0
" Git
let g:signify_sign_add               = '>'
let g:signify_sign_delete            = '<'
let g:signify_sign_change            = '~'
" Langs
let g:ansible_attribute_highlight       = 'ab'
let g:ansible_extra_keywords_highlight  = 1
let g:ansible_name_highlight            = 'd'
let g:ansible_normal_keywords_highlight = 'Define'
let g:ansible_yamlKeyName               = 'yamlKey'
let g:go_highlight_array_whitespace_error   = 1
let g:go_highlight_build_constraints        = 1
let g:go_highlight_chan_whitespace_error    = 1
let g:go_highlight_extra_types      = 1
let g:go_highlight_fields           = 1
let g:go_highlight_function_calls   = 1
let g:go_highlight_function_parameters  = 1
let g:go_highlight_functions        = 1
let g:go_highlight_generate_tags    = 1
let g:go_highlight_operators        = 1
let g:go_highlight_space_tab_error  = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_highlight_types                 = 1
let g:go_highlight_variable_assignments  = 1
let g:go_highlight_variable_declarations = 1
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
map <leader><Tab>  :<C-u>Buffers<CR>
map <leader>b      :<C-u>Files<CR>
map <leader>f      :<C-u>Rg<CR>
map <leader>t      :<C-u>Tags<CR>
" Utility for Markdown and Ansible
nnoremap <leader>j :<C-u>set ft=
" Theming
set noshowmode noshowcmd laststatus=0 ruler   " hide statusline
set rulerformat=%20(%m%r%w\ %y\ %l/%c%)\        " Modified+FileType+Ruler
set background=dark
set termguicolors
augroup customsyntax
    autocmd! customsyntax
    " Remove trailing whitespaces and lines
    autocmd BufWritePre * silent! :call StripTrailingWhiteSpace()
    " Refresh tags on save
    autocmd BufWritePost * silent! :call GenTags()
    " Custom syntax highlight
    autocmd Syntax,InsertEnter * syntax match myFunction /\<\k\+\ze(/
    autocmd Syntax,InsertEnter * syntax match myDeclaration_1 /\<\k\+\ze\s*=[a-zA-Z0-9 $:.\/\\]/
    autocmd Syntax,InsertEnter * syntax match myDeclaration_2 /\<.*\k\+\ze\s*:=[a-zA-Z0-9 $:.\/\\]/
augroup end
highlight link myFunction       Function
highlight link myDeclaration_1  Keyword
highlight link myDeclaration_2  Keyword
colorscheme one
highlight Normal        guibg=#101010
highlight TabLineSel    guifg=#262626 guibg=#8a8a8a
" FUNCTIONS --------------------------------------------------------------------
" Toggle Theme
map <silent> <C-e> :<C-u>call ToggleTheme()<CR>
function! ToggleTheme()
    if &background == 'light'
        set background=dark
        highlight Normal        guibg=#101010
        highlight TabLineSel    guifg=#262626 guibg=#8a8a8a
    else
        set background=light
        highlight Normal        guibg=#FFFFFF
    endif
endfunction
" Lint the entire project using filetype as reference. out to quickfix
function! LintProject()
    silent!
    cgete system('lint-project ' . &filetype . " .")
    :vert copen
    :vert resize 80
endfun
" Lint the entire project using filetype as reference. out to quickfix
function! FormatProject()
    silent!
    call system('lint-project ' . &filetype . " . f")
endfun
" Generate tags
function! GenTags()
    if isdirectory(".git") || filereadable(".project")
        silent!
        exec "!rm -f ./tags; ctags -R ."
        redraw!
    endif
endfun
" Remove Trailing Spaces and empty lines
function! StripTrailingWhiteSpace()
    " don't strip on these filetypes
    if &ft =~ 'markdown'
        return
    endif
    %s/\s\+$//e
    %s/\($\n\s*\)\+\%$//e
    redraw!
endfun
" Default IDE-Style keybindings EDMRL, errors, definition, references, rename, indent
nnoremap <leader>A  :<C-u>call LintProject()<CR>
nnoremap <leader>L  :<C-u>call FormatProject()<CR>
nnoremap <leader>R  :<C-u>cgete system('grep --exclude tags -Rn ""')<Left><Left><Left>
nnoremap <leader>e  :<C-u>vert copen<BAR>vert resize 80<CR>
nnoremap <leader>d  :<C-u>vert stag <c-r>=expand("<cword>")<CR><CR>
nnoremap <leader>m  :<C-u>cgete system('grep --exclude tags -Rn "<c-r>=expand("<cword>")<CR>"')<CR>
nnoremap <leader>r  :<C-u>!grep --exclude tags -Rl <c-r>=expand("<cword>")<CR><BAR>xargs sed -i 's/<c-r>=expand("<cword>")<CR>//g'<Left><Left><Left>
nnoremap <leader>l  :<C-u>mkview<CR>ggVG=:<C-u>loadview<CR>
" LSP SETUP --------------------------------------------------------------------
" Override IDE-Style keybindings EDMRL, errors, definition, references, rename, indent
augroup lspbindings
    autocmd! lspbindings
    " IDE-like keybindings
    autocmd Filetype c,cpp,python,go nnoremap <buffer> K  :<C-u>call LanguageClient#textDocument_hover()<CR>
    autocmd Filetype c,cpp,python,go nnoremap <buffer> <leader>d :<C-u>call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>
    autocmd Filetype c,cpp,python,go nnoremap <buffer> <leader>m :<C-u>call LanguageClient#textDocument_references()<CR>
    autocmd Filetype c,cpp,python,go nnoremap <buffer> <leader>r :<C-u>call LanguageClient#textDocument_rename()<CR>
    autocmd Filetype c,cpp,python,go nnoremap <buffer> <leader>h :<C-u>call LanguageClient#textDocument_codeAction()<CR>
augroup end
" Override <leader>l formatting with corresponding formatter for each lang
augroup autoformat_settings
    autocmd FileType c,cpp,java   nnoremap <buffer> <leader>l <Esc>:w<CR>:mkview<CR>:%!clang-format -style=Chromium %<CR>:loadview<CR>
    autocmd FileType python       nnoremap <buffer> <leader>l <Esc>:w<CR>:mkview<CR>:%!yapf --style=facebook %<CR>:loadview<CR>
    autocmd FileType go           nnoremap <buffer> <leader>l <Esc>:w<CR>:mkview<CR>:%!goimports %<CR>:loadview<CR>
augroup end
" Async enable Deoplete for better performances
autocmd InsertEnter * call deoplete#enable()
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
            \}
