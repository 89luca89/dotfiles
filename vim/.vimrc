unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim
set autoindent shiftwidth=4 softtabstop=4 tabstop=4 smartindent smarttab
set autoread autowrite hidden
set colorcolumn=80 cursorline
set hlsearch ignorecase smartcase
set nolazyredraw redrawtime=0 ttyfast
set nomodeline nofsync nowrap noswapfile nowritebackup nobackup noshowmode nofoldenable
set path+=** wildmode=longest:full,full wildignore+=**/tags,vendor/**,coverage/**target/**,node_modules/** wildignorecase wildmode=longest:full
set splitbelow splitright sidescroll=8 sidescrolloff=8
set title number encoding=utf8 mouse=a nrformats+=unsigned isfname-== guioptions=
set undofile undolevels=10000
" Auto-install vim-plug #######################################################
if empty(glob('$HOME/.vim/autoload/plug.vim'))
    silent !mkdir -p "$HOME/.vim/"{autoload,plugged,undo,view,spell}
    silent !curl -sfLo "$HOME/.vim/autoload/plug.vim" --create-dirs
                \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    autocmd VimEnter * PlugInstall --sync|qall
endif
set grepprg=grep\ --exclude={tags,*.lock,*.svg,*.png}\ --exclude-dir={.git,node_modules,vendor,coverage,target}\ -EIrn
set statusline=%{toupper(mode())}\ %<%f%m\ %=\ L:%l\/%L\ C:%c%V\ \[%{&ff}]:%y
set laststatus=2 termguicolors
set list listchars=tab:\|\ " there is a space
set listchars+=lead:\. " there is a space
set undodir=$HOME/.vim/undo
let $FZF_DEFAULT_COMMAND='find . \! \( -type d -path ./.git -prune -o -type d -path ./vendor -prune \) \! -type d -printf ''%P\n'''
filetype off
call plug#begin('~/.vim/plugged')
" utilities
Plug 'ap/vim-buftabline'
Plug 'preservim/nerdtree'
" Git
Plug 'airblade/vim-gitgutter'
" colorscheme
Plug 'sainnhe/gruvbox-material'
" Fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Lang support
Plug 'tpope/vim-sleuth' " tabs/spaces and editorconfig
" LSP & Diagnostics
Plug 'dense-analysis/ale'
call plug#end()
filetype plugin indent on
syntax on
augroup general
    autocmd! general
    " Make gitgutter more intentional
    autocmd InsertEnter  * GitGutterBufferEnable
    autocmd InsertLeave  * GitGutter
    autocmd BufWritePost * GitGutter
    autocmd BufWritePost * GitGutterBufferEnable
    "keep equal proportions when windows resized
    autocmd VimResized * wincmd = " equalize
    " Strip whitespaces and extra newlines
    autocmd BufWritePre * if &ft!~?'markdown'|%s/\($\n\s*\)\+\%$//e|endif
    autocmd BufWritePre * if &ft!~?'markdown'|%s/\s\+$//e|endif
    " Help indentation guides on yaml/json
    autocmd FileType json,yaml,yaml.* setlocal cursorcolumn
    " Custom syntax highlight
    autocmd Syntax * syntax match myDeclaration '\v[_.[:alnum:]]+(,\s*[_.[:alnum:]]+)*\ze(\s*([-^+|^\/%&]|\*|\<\<|\>\>|\&\^)?\=[^=])'
    autocmd Syntax * syntax match myDeclaration '\v\w+(,\s*\w+)*\ze(\s*:\=)'
    autocmd Syntax * syntax match myFunction    '\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\ze\%([a-zA-Z0-9]*(\)'
augroup end
let g:gitgutter_enabled = 0
" Languages
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_functions = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_operators = 1
let g:go_highlight_types = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_variable_declarations = 1
let g:python_highlight_all  = 1
" Shortcuts ###################################################################
" do last action on a visual selection
vnoremap . :normal .<CR>
vnoremap < <gv
vnoremap > >gv
" copy to clipboard on a visual selection
vnoremap <C-c>   :w !xclip -sel clip<CR><CR>
" navigate tabs Tab (fwd) S-Tab (prev)
nnoremap <S-Tab> :<C-u>bp<CR>
nnoremap <Tab>   :<C-u>bn<CR>
" C-c close buffer
nnoremap <C-c>   :<C-u>bp<bar>sp<bar>bn<bar>bd<CR>
" Leader map
let mapleader = ' '
" toggle file tree
let NERDTreeHijackNetrw = 1
let NERDTreeShowHidden  = 1
nnoremap <expr> <leader>e  "".(NERDTree.IsOpen() == 1 ? ':NERDTreeToggle' : ':NERDTreeFind'). "\<CR>"
" Fzf stuff
map <leader><Tab>    :<C-u>Buffers<CR>
map <leader><leader> :<C-u>Files<CR>
map <leader>t        :<C-u>Tags<CR>
" Git helpers
nnoremap <leader>gb  :<C-u>!tig blame +<C-r>=line('.')<CR> -- <C-r>=expand('%')<CR><CR>
nnoremap <leader>gd  :<C-u>!git diff <C-r>=expand('%:p')<CR><bar>tig<CR>
nnoremap <leader>gs  :<C-u>!tig -C . status<CR><CR>
" Auto light/dark mode ########################################################
if &term =~ '256color'
    set t_ut=
endif
function! SetTheme()
    let g:theme = system("dconf read /org/gnome/desktop/interface/color-scheme | tr -d \"\n\"")
    if g:theme == "'default'"
        set background=light
        colorscheme wildcharm
    elseif g:theme == "'prefer-dark'"
        set background=dark
        colorscheme gruvbox-material
        highlight Normal guibg=#171717 ctermbg=16
    endif
    highlight link myDeclaration Identifier
    highlight link myFunction Special
    highlight clear ColorColumn
    highlight link ColorColumn CursorLine
endfun
call SetTheme()
nnoremap <C-e>   :<C-u>call SetTheme()<CR>
" LSP setup ###################################################################
" Default IDE-Style keybindings: indent/format, definition, find, references
nnoremap <leader>d   :<C-u>vert stag <c-r>=expand("<cword>")<CR><CR>
nnoremap <leader>D   :<C-u>vert stag <c-r>=expand("<cword>")<CR><CR>
nnoremap <leader>f   :<C-u>cgetexpr system(&grepprg . ' ""')<bar>copen<C-Left><Right>
nnoremap <leader>F   :<C-u>cgetexpr system(&grepprg . ' "<c-r>=expand("<cword>")<CR>"')<bar>copen<C-Left><Right>
nnoremap <leader>i   :<C-u>mkview<CR>:w<CR>gg=G:loadview<CR>
" Override IDE-Style keybindings: definition, rename, references
function s:setup_lsp()
    set omnifunc=ale#completion#OmniFunc
    let g:ale_completion_enabled    = 1
    let g:ale_enabled               = 1
    let g:ale_floating_preview      = 1
    let g:ale_lint_on_enter         = 0
    let g:ale_lint_on_text_changed  = 0
    let g:ale_python_pylsp_executable = "pyls"
    let g:ale_linters = {
                \   'c':      ['cc', 'ccls', 'clangd'],
                \   'cpp':    ['cc', 'ccls', 'clangd'],
                \   'go':     ['gobuild', 'gofmt', 'golint', 'gopls', 'govet'],
                \   'json':   ['jq'],
                \   'python': ['flake8', 'mypy', 'pycodestyle', 'pydocstyle', 'pyflakes', 'pylint', 'pylsp'],
                \   'rust':   ['analyzer', 'cargo', 'rustc'],
                \   'sh':     ['shell', 'shellcheck'],
                \   'yaml':   ['yamllint'],
                \}
    " IDE-like keybindings
    nnoremap <buffer> K           :<C-u>ALEHover<CR>
    nnoremap <buffer> <leader>c   :<C-u>ALECodeAction<CR>
    nnoremap <buffer> <leader>d   :<C-u>ALEGoToDefinition<CR>
    nnoremap <buffer> <leader>im  :<C-u>ALEGoToImplementation<CR>
    nnoremap <buffer> <leader>l   :<C-u>ALELint<bar>ALEPopulateQuickfix<bar>copen<CR>
    nnoremap <buffer> <leader>r   :<C-u>ALERename<CR>
    nnoremap <buffer> <leader>rf  :<C-u>ALEFindReferences<CR>
    nnoremap <buffer> <leader>td  :<C-u>ALEGoToTypeDefinition<CR>
    nnoremap <buffer> <leader>vd  :<C-u>ALEGoToDefinition -vsplit<CR>
    nnoremap <buffer> <leader>vim :<C-u>ALEGoToImplementation -vsplit<CR>
    nnoremap <buffer> <leader>vtd :<C-u>ALEGoToTypeDefinition -vsplit<CR>
endfun
autocmd Filetype c,cpp,go,python,rust,json,sh call s:setup_lsp()
" formatters
autocmd FileType c,cpp     nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!clang-format -style=Chromium %<CR>:loadview<CR>
autocmd FileType go        nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:!gofmt -w %<CR><CR>:!goimports -w %<CR><CR>:!gofumpt -w %<CR><CR>:loadview<CR>
autocmd FileType json      nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!jq .<CR>
autocmd FileType python    nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!yapf --style=facebook %<CR>:w<CR>:%!isort --ac --float-to-top -d %<CR>:loadview<CR>
autocmd FileType rust      nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!rustfmt --edition 2021<CR>:loadview<CR>
autocmd FileType sh        nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:!shfmt -w -s -ci -sr -kp -fn -i=0 -p %<CR>:loadview<CR>
