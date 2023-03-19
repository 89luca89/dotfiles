source $VIMRUNTIME/defaults.vim
set autoindent copyindent expandtab shiftwidth=4 softtabstop=4 tabstop=4 smartindent smarttab
set autoread autowrite hidden
set colorcolumn=80 cursorline showmatch
set hlsearch ignorecase smartcase
set lazyredraw redrawtime=0 ttyfast
set nomodeline nofsync nowrap noswapfile nowritebackup nobackup noshowmode nofoldenable
set path+=** wildmode=longest:full,full wildignore+=**/tags wildignorecase
set splitbelow splitright sidescroll=1 sidescrolloff=7
set title number encoding=utf8 mouse=a nrformats+=unsigned isfname-==
set undodir=$HOME/.vim/undo undofile undolevels=10000
set completeopt=menu,menuone,popup,noselect,noinsert
set list listchars=tab:\|\ " there is a space
set laststatus=2 statusline=%m\ %f\ %y\ %{&fileencoding?&fileencoding:&encoding}\ %=%(C:%c\ L:%l\ %P%)
filetype off
" Auto-install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !mkdir -p $HOME/.vim/{autoload,plugged,undo,view}
    silent !curl -sfLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync |qall| source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
" utilities
Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-buftabline'
Plug 'preservim/nerdtree'
" Fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } | Plug 'junegunn/fzf.vim'
" " colorscheme
Plug 'rakr/vim-one'
" Lang Packs
Plug 'sheerun/vim-polyglot'
" LSP & Diagnostics
Plug 'dense-analysis/ale'
call plug#end()
filetype plugin indent on
syntax on
" Theming
let NERDTreeShowHidden=1
let $FZF_DEFAULT_COMMAND='find . \! \( -type d -path ./.git -prune \) \! -type d -printf ''%P\n'''
set t_Co=256
set termguicolors
set background=dark
augroup general
    autocmd! general
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
" Languages
let g:go_highlight_build_constraints    = 1
let g:go_highlight_extra_types          = 1
let g:go_highlight_fields               = 1
let g:go_highlight_function_calls       = 1
let g:go_highlight_function_parameters  = 1
let g:go_highlight_functions            = 1
let g:go_highlight_generate_tags        = 1
let g:go_highlight_operators            = 1
let g:go_highlight_types                = 1
let g:java_highlight_all                = 1
let g:python_highlight_all              = 1
"""""""""""""""""""""
"       Shortcuts   "
"""""""""""""""""""""
" do last action on a visual selection
vnoremap .  :normal .<CR>
vnoremap > >gv
vnoremap < <gv
" navigate tabs Tab (fwd) S-Tab (prev)
map <C-T>   :<C-u>tabnew<CR>
map <S-Tab> :<C-u>bp<CR>
map <Tab>   :<C-u>bn<CR>
" C-c close buffer
map <C-c>   :<C-u>bp<BAR>sp<BAR>bn<BAR>bd<CR>
" copy to clipboard on a visual selection
vnoremap <C-c> :w !xclip -sel clip<CR><CR>
" Leader map
let mapleader = ' '
nnoremap <leader><esc> /<C-u>slkdjcsd<CR>
" Utility shortcuts with leader:
map <leader><Tab>    :<C-u>Buffers<CR>
map <leader><leader> :<C-u>Files<CR>
map <leader>t        :<C-u>Tags<CR>
map <leader>p        :<C-u>Commands<CR>
" Easier completion shortcuts
inoremap <C-F> <C-X><C-F>
inoremap <C-L> <C-X><C-L>
" Code help using external scripts: Lint File, Lint Project, Format, DeepTags, Grep in project
nnoremap <expr> <leader>e g:NERDTree.IsOpen() ? ':NERDTreeClose<CR>' : @% == '' ? ':NERDTree<CR>' : ':NERDTreeFind<CR>'
nnoremap <leader>I   :<C-u>call system('project-utils format ' . &filetype . " .")<bar>mkview<bar>e!<CR>
nnoremap <leader>l   :<C-u>cgetexpr system('project-utils lint ' . &filetype . " " .  expand('%'))<bar>copen<CR>
nnoremap <leader>L   :<C-u>cgetexpr system('project-utils lint ' . &filetype . " .")<bar>copen<CR>
nnoremap <leader>T   :<C-u>!ctags -R .<CR><CR>
nnoremap <leader>gb  :<C-u>!tig blame +<C-r>=line('.')<CR> -- <C-r>=expand('%')<CR><CR>
nnoremap <leader>gd  :<C-u>!clear && git diff <C-r>=expand('%:p')<CR><CR>
nnoremap <leader>gs  :<C-u>!tig -C . status<CR><CR>
nnoremap <leader>td  :<C-u>vimgrep /\<NOTE\>\\|\<OPTIMIZE\>\\|\<TODO\>\\|\<HACK\>\\|\<FIXME\>\\|\<BUG\>\\|\<XXX\>\C/gj **/* **/.* <bar>copen<CR>
" Default IDE-Style keybindings: indent/format, definition, find, references
nnoremap <leader>i   :<C-u>mkview<CR>:w<CR>ggVG=:loadview<CR>
nnoremap <C-]>       :<C-u>stag <c-r>=expand("<cword>")<CR><CR>
nnoremap <leader>d   :<C-u>vert stag <c-r>=expand("<cword>")<CR><CR>
nnoremap <leader>f   :<C-u>vimgrep //gj **/* **/.* <bar>copen<C-Left><C-Left><C-Left><C-Left><Right>
nnoremap <leader>rf  :<C-u>vimgrep /<c-r>=expand("<cword>")<CR>/gj **/* **/.* <bar>copen<CR>
" Override <leader>i formatting with corresponding formatter for each lang
augroup autoformat_settings
    autocmd!
    autocmd FileType c,cpp,cc  nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!clang-format -style=Chromium %<CR>:loadview<CR>
    autocmd FileType go        nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!gofmt %<CR>:%!goimports %<CR>:%!golines %<CR>:loadview<CR>
    autocmd FileType json      nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!jq .<CR>
    autocmd FileType python    nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!yapf --style=facebook %<CR>:w<CR>:%!isort --ac --float-to-top -d %<CR>:loadview<CR>
    autocmd FileType rust      nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:!rustfmt %<CR><CR>:loadview<CR>
    autocmd FileType sh        nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!shfmt -s -ci -sr -kp %<CR>:loadview<CR>
augroup end
" LSP SETUP --------------------------------------------------------------------
" Override IDE-Style keybindings: definition, rename, references
augroup lspbindings
    autocmd!
    " IDE-like keybindings
    autocmd Filetype c,cc,cpp,go,python,rust nnoremap <buffer> K          :<C-u>ALEHover<CR>
    autocmd Filetype c,cc,cpp,go,python,rust nnoremap <buffer> <C-]>      :<C-u>ALEGoToDefinition<CR>
    autocmd Filetype c,cc,cpp,go,python,rust nnoremap <buffer> <leader>d  :<C-u>ALEGoToDefinition -vsplit<CR>
    autocmd Filetype c,cc,cpp,go,python,rust nnoremap <buffer> <leader>m  :<C-u>ALEFix<CR>
    autocmd Filetype c,cc,cpp,go,python,rust nnoremap <buffer> <leader>r  :<C-u>ALERename<CR>
    autocmd Filetype c,cc,cpp,go,python,rust nnoremap <buffer> <leader>rf :<C-u>ALEFindReferences<CR>
augroup end
" AUTO LIGHT/DARK MODE --------------------------------------------------------
function! s:set_bg(timer_id)
    silent call system("grep -q 'light' ~/.local/share/current_theme")
    if v:shell_error == 0
        if &background != 'light' || a:timer_id == 0
            set background=light
            try | colorscheme one | catch | endtry
        endif
    else
        if &background == 'light' || a:timer_id == 0
            set background=dark
            try | colorscheme one | catch | endtry
        endif
    endif
    highlight Normal guibg=NONE
    highlight link myDeclaration Special
    highlight link myFunction Type
endfun
" Execute bg_sync every 5 seconds
silent call timer_start(1000 * 5, function('s:set_bg'), {'repeat': -1})
" Execute now to set theme
silent call s:set_bg(0)
" ALE + LSP -------------------------------------------------------------------
set omnifunc=ale#completion#OmniFunc
let g:ale_completion_enabled    = 1
let g:ale_enabled               = 1
let g:ale_floating_preview      = 1
let g:ale_lint_on_enter         = 0
let g:ale_lint_on_text_changed  = 0
let g:ale_go_golangci_lint_options = ""
let g:ale_linters = {
            \   'c': ['clangd', 'gcc'],
            \   'cpp': ['clangd', 'gcc'],
            \   'go': ['gofmt', 'govet', 'gopls', 'golangci-lint'],
            \   'python': ['flake8', 'pylint', 'pylsp'],
            \   'rust': ['analyzer', 'cargo', 'clippy', 'rls', 'rustc'],
            \}
" Disable LSP after 60 seconds of inactivity in normal mode.
augroup lspidlesaving
    autocmd!
    autocmd BufEnter     * let g:stoplsp = 0
    autocmd BufEnter     * silent call timer_start(1000 * 60, function('s:disable_lsp'))
    autocmd BufLeave     * let g:stoplsp = 1
    autocmd BufLeave     * silent call timer_start(1000 * 60, function('s:disable_lsp'))
    autocmd CursorHold   * let g:stoplsp = 1
    autocmd CursorMoved  * let g:stoplsp = 0
    autocmd CursorMovedI * let g:stoplsp = 0
augroup end
function! s:disable_lsp(timer_id)
    if g:stoplsp == 1
        ALEStopAllLSPs
    endif
endfun
