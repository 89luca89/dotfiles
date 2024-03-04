unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim
set autoindent shiftwidth=4 softtabstop=4 tabstop=4 smartindent smarttab
set autoread autowrite hidden
set colorcolumn=80 cursorline
set hlsearch ignorecase smartcase
set lazyredraw redrawtime=0 ttyfast
set nomodeline nofsync nowrap noswapfile nowritebackup nobackup noshowmode nofoldenable
set path+=** wildmode=longest:full,full wildignore+=**/tags,vendor/**,coverage/**target/**,node_modules/** wildignorecase wildmode=longest:full
set splitbelow splitright sidescroll=8 sidescrolloff=8 clipboard=unnamedplus
set title number relativenumber encoding=utf8 mouse=a nrformats+=unsigned isfname-== guioptions=
set undofile undolevels=10000
" Auto-install vim-plug #######################################################
if empty(glob('$HOME/.vim/autoload/plug.vim'))
    silent !mkdir -p "$HOME/.vim/"{autoload,plugged,undo,view,spell}
    silent !curl -sfLo "$HOME/.vim/autoload/plug.vim" --create-dirs
                \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    autocmd VimEnter * PlugInstall --sync|qall
endif
set grepprg=grep\ --exclude=tags\ --exclude-dir={.git,node_modules,coverage,target}\ -EIrn
set statusline=%{toupper(mode())}\ %<%f%m\ %{fugitive#statusline()}\ %=\ L:%l\/%L\ C:%c%V\ \[%{&ff}]:%y
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
Plug 'tpope/vim-sleuth'
" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
" Fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" colorscheme
Plug 'sainnhe/gruvbox-material'
" LSP & Diagnostics
Plug 'dense-analysis/ale'
call plug#end()
filetype plugin indent on
syntax on
augroup general
    autocmd! general
    autocmd InsertLeave * GitGutter
    "keep equal proportions when windows resized
    autocmd VimResized * wincmd = " equalize
    " Strip whitespaces and extra newlines
    autocmd BufWritePre * if &ft!~?'markdown'|%s/\($\n\s*\)\+\%$//e|endif
    autocmd BufWritePre * if &ft!~?'markdown'|%s/\s\+$//e|endif
    " Help indentation guides on yaml/json
    autocmd FileType json,python,yaml,yaml.* setlocal cursorcolumn
    " Custom syntax highlight
    autocmd Syntax * syntax match myDeclaration '\v[_.[:alnum:]]+(,\s*[_.[:alnum:]]+)*\ze(\s*([-^+|^\/%&]|\*|\<\<|\>\>|\&\^)?\=[^=])'
    autocmd Syntax * syntax match myDeclaration '\v\w+(,\s*\w+)*\ze(\s*:\=)'
    autocmd Syntax * syntax match myFunction    '\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\ze\%([a-zA-Z0-9]*(\)'
augroup end
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
nnoremap <C-c>   :<C-u>bp<BAR>sp<BAR>bn<BAR>bd<CR>
" Leader map
let mapleader = ' '
map <leader><Tab>    :<C-u>Buffers<CR>
map <leader><leader> :<C-u>Files<CR>
map <leader>p        :<C-u>Maps<CR>
map <leader>t        :<C-u>Tags<CR>
nnoremap <expr> <leader>e  "".(NERDTree.IsOpen() == 1 ? ':NERDTreeToggle' : ':NERDTreeFind'). "\<CR>"
" Git helpers
nnoremap <leader>gb  :<C-u>Git blame<CR>
nnoremap <leader>gd  :<C-u>vert Git diff %<CR>
nnoremap <leader>gh  :<C-u>GitGutterStageHunk<CR>
nnoremap <leader>gl  :<C-u>Commits %<CR>
nnoremap <leader>gs  :<C-u>Git<CR>
" Default IDE-Style keybindings: indent/format, definition, find, references
nnoremap <C-]>       :<C-u>stag <c-r>=expand("<cword>")<CR><CR>
nnoremap <leader>i   :<C-u>mkview<CR>:w<CR>gg=G:loadview<CR>
nnoremap <leader>d   :<C-u>vert stag <c-r>=expand("<cword>")<CR><CR>
nnoremap <leader>f   :<C-u>cgetexpr system(&grepprg . ' ""')<bar>copen<C-Left><Right>
nnoremap <leader>F   :<C-u>Rg <CR>
" LSP setup ###################################################################
" Override IDE-Style keybindings: definition, rename, references
augroup lspbindings
    autocmd!
    autocmd Filetype c,cpp,go,python inoremap <C-x><C-n>  <C-x><C-]>
    " IDE-like keybindings
    autocmd Filetype c,cpp,go,python,rust,typescript,typescriptreact,json,yaml nnoremap <buffer> <C-]>       :<C-u>ALEGoToDefinition<CR>
    autocmd Filetype c,cpp,go,python,rust,typescript,typescriptreact,json,yaml nnoremap <buffer> <leader>R   :<C-u>ALEFileRename<CR>
    autocmd Filetype c,cpp,go,python,rust,typescript,typescriptreact,json,yaml nnoremap <buffer> <leader>c   :<C-u>ALECodeAction<CR>
    autocmd Filetype c,cpp,go,python,rust,typescript,typescriptreact,json,yaml nnoremap <buffer> <leader>d   :<C-u>ALEGoToDefinition -vsplit<CR>
    autocmd Filetype c,cpp,go,python,rust,typescript,typescriptreact,json,yaml nnoremap <buffer> <leader>im  :<C-u>ALEGoToImplementation<CR>
    autocmd Filetype c,cpp,go,python,rust,typescript,typescriptreact,json,yaml nnoremap <buffer> <leader>l   :<C-u>ALELint<bar>ALEPopulateQuickfix<bar>copen<CR>
    autocmd Filetype c,cpp,go,python,rust,typescript,typescriptreact,json,yaml nnoremap <buffer> <leader>r   :<C-u>ALERename<CR>
    autocmd Filetype c,cpp,go,python,rust,typescript,typescriptreact,json,yaml nnoremap <buffer> <leader>rf  :<C-u>ALEFindReferences<CR>
    autocmd Filetype c,cpp,go,python,rust,typescript,typescriptreact,json,yaml nnoremap <buffer> <leader>td  :<C-u>ALEGoToTypeDefinition<CR>
    autocmd Filetype c,cpp,go,python,rust,typescript,typescriptreact,json,yaml nnoremap <buffer> K           :<C-u>ALEHover<CR>
    autocmd Filetype c,cpp,go,python,rust,typescript,typescriptreact,json,yaml,sh nnoremap <buffer> <leader>i   :<C-u>ALEFix<CR>
augroup end
" LSP -------------------------------------------------------------------
set omnifunc=ale#completion#OmniFunc
let g:ale_completion_enabled    = 1
let g:ale_enabled               = 1
let g:ale_floating_preview      = 1
let g:ale_lint_on_enter         = 0
let g:ale_lint_on_text_changed  = 0
let g:ale_fix_on_save           = 1
let g:ale_fixers = {
            \   'c':      ['clang-format'],
            \   'cpp':    ['clang-format'],
            \   'go':     ['gofmt', 'gofumpt', 'goimports', 'gopls'],
            \   'json':   ['jq'],
            \   'python': ['autoflake', 'autoimport', 'yapf', 'isort'],
            \   'rust':   ['rustfmt'],
            \   'sh':     ['shfmt'],
            \}
let g:ale_c_clangformat_options   = "--style=Chromium"
let g:ale_cpp_clangformat_options = "--style=Chromium"
let g:ale_python_isort_options    = "--ac --float-to-top"
let g:ale_rust_rustfmt_options    = "--edition 2021"
let g:ale_sh_shfmt_options        = "-s -ci -sr -kp"
let g:ale_linters = {
            \   'c':      ['cc', 'ccls', 'clangd'],
            \   'cpp':    ['cc', 'ccls', 'clangd'],
            \   'go':     ['gobuild', 'gofmt', 'golint', 'gopls', 'govet'],
            \   'json':   ['jq'],
            \   'python': ['flake8', 'mypy', 'pycodestyle', 'pydocstyle', 'pyflakes', 'pylint', 'pylsp'],
            \   'rust':   ['analyzer', 'cargo', 'rustc'],
            \   'sh':     ['shell', 'shellcheck'],
            \   'yaml':   ['yamllint'],
            \   'typescriptreact':   ['tsserver'],
            \}
" Auto light/dark mode ########################################################
function! s:set_bg(timer_id)
    let g:theme = system("dconf read /org/gnome/desktop/interface/color-scheme | tr -d \"\n\"")
    if g:theme == "'prefer-light'" && (&background == 'dark' || a:timer_id == 0)
        set background=light
        colorscheme wildcharm
    elseif g:theme == "'prefer-dark'" && (&background == 'light' || a:timer_id == 0)
        set background=dark
        let g:gruvbox_material_background = 'hard'
        colorscheme gruvbox-material
    else
        " nothing to do
        return
    endif
    highlight link myDeclaration Identifier
    highlight link myFunction Special
endfun
" Execute bg_sync every 5 seconds
silent call timer_start(1000 * 5, function('s:set_bg'), {'repeat': -1})
silent call s:set_bg(0)
