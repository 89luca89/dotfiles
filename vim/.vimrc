" AUTO-INSTALL VIM-PLUG #######################################################
if empty(glob('$HOME/.vim/autoload/plug.vim'))
    silent !mkdir -p "$HOME/.vim/"{autoload,plugged,undo,view,spell}
    silent !curl -sfLo "$HOME/.vim/autoload/plug.vim" --create-dirs
                \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    autocmd VimEnter * PlugInstall --sync|qall
endif
"##############################################################################
source $VIMRUNTIME/defaults.vim
set autoindent copyindent expandtab shiftwidth=4 softtabstop=4 tabstop=4 smartindent smarttab
set autoread autowrite hidden
set colorcolumn=80 cursorline showmatch
set grepprg=grep\ --exclude=tags\ --exclude-dir=\".git\"\ -Irn
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
call plug#begin('~/.vim/plugged')
" utilities
Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-buftabline'
" Fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } | Plug 'junegunn/fzf.vim'
" " colorscheme
Plug 'gruvbox-community/gruvbox'
" Lang Packs
Plug 'sheerun/vim-polyglot'
" LSP & Diagnostics
Plug 'dense-analysis/ale'
call plug#end()
filetype plugin indent on
syntax on
let $FZF_DEFAULT_COMMAND='find . \! \( -type d -path ./.git -prune \) \! -type d -printf ''%P\n'''
augroup general
    autocmd! general
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
" SHORTCUTS####################################################################
" do last action on a visual selection
vnoremap .  :normal .<CR>
vnoremap < <gv
vnoremap > >gv
" navigate tabs Tab (fwd) S-Tab (prev)
nnoremap <C-T>   :<C-u>tabnew<CR>
nnoremap <S-Tab> :<C-u>bp<CR>
nnoremap <Tab>   :<C-u>bn<CR>
" C-c close buffer
nnoremap <C-c>   :<C-u>bp<BAR>sp<BAR>bn<BAR>bd<CR>
" copy to clipboard on a visual selection
vnoremap <C-c>   :w !xclip -sel clip<CR><CR>
" Leader map
let mapleader = ' '
nnoremap <leader><esc> :<C-u>let @/ = ""<CR>
" Utility shortcuts with leader:
map <leader><Tab>    :<C-u>Buffers<CR>
map <leader><leader> :<C-u>Files<CR>
map <leader>p        :<C-u>Commands<CR>
map <leader>t        :<C-u>Tags<CR>
" Easier completion shortcuts
inoremap <C-F> <C-X><C-F>
inoremap <C-L> <C-X><C-L>
" Code help using external scripts: Lint File, Lint Project, Format, DeepTags, Grep in project
nnoremap <leader>I   :<C-u>call system('project-utils format ' . &filetype . " .")<bar>mkview<bar>e!<CR>
nnoremap <leader>l   :<C-u>cgetexpr system('project-utils lint ' . &filetype . " " .  expand('%'))<bar>copen<CR>
nnoremap <leader>L   :<C-u>cgetexpr system('project-utils lint ' . &filetype . " .")<bar>copen<CR>
nnoremap <leader>T   :<C-u>!ctags -R .<CR><CR>
nnoremap <leader>gb  :<C-u>!tig blame +<C-r>=line('.')<CR> -- <C-r>=expand('%')<CR><CR>
nnoremap <leader>gd  :<C-u>!clear && git diff <C-r>=expand('%:p')<CR><CR>
nnoremap <leader>gs  :<C-u>!tig -C . status<CR><CR>
nnoremap <leader>td  :<C-u>cgetexpr system(&grepprg . ' "\<NOTE\>\\|\<OPTIMIZE\>\\|\<TODO\>\\|\<HACK\>\\|\<FIXME\>\\|\<BUG\>\\|\<XXX\>" .')<bar>copen<CR>
" Default IDE-Style keybindings: indent/format, definition, find, references
nnoremap <leader>i   :<C-u>mkview<CR>:w<CR>ggVG=:loadview<CR>
nnoremap <C-]>       :<C-u>stag <c-r>=expand("<cword>")<CR><CR>
nnoremap <leader>d   :<C-u>vert stag <c-r>=expand("<cword>")<CR><CR>
nnoremap <leader>f   :<C-u>cgetexpr system(&grepprg . ' "\<\>"')<bar>copen<C-Left><Right><Right><Right>
nnoremap <leader>F   :<C-u>cgetexpr system(&grepprg . ' "\<<c-r>=expand("<cword>")<CR>\>"')<bar>copen<CR>
augroup autoformat_settings
    autocmd!
    autocmd FileType c,cpp     nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!clang-format -style=Chromium %<CR>:loadview<CR>
    autocmd FileType go        nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!gofmt %<CR>:%!goimports %<CR>:loadview<CR>
    autocmd FileType json      nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!jq .<CR>
    autocmd FileType python    nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!yapf --style=facebook %<CR>:w<CR>:%!isort --ac --float-to-top -d %<CR>:loadview<CR>
    autocmd FileType rust      nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:!rustfmt %<CR><CR>:loadview<CR>
    autocmd FileType sh        nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!shfmt -s -ci -sr -kp %<CR>:loadview<CR>
augroup end
" LSP SETUP ####################################################################
" Override IDE-Style keybindings: definition, rename, references
augroup lspbindings
    autocmd!
    " IDE-like keybindings
    autocmd Filetype c,cc,cpp,go,python,rust nnoremap <buffer> K          :<C-u>ALEHover<CR>
    autocmd Filetype c,cc,cpp,go,python,rust nnoremap <buffer> <C-]>      :<C-u>ALEGoToDefinition<CR>
    autocmd Filetype c,cc,cpp,go,python,rust nnoremap <buffer> <leader>d  :<C-u>ALEGoToDefinition -vsplit<CR>
    autocmd Filetype c,cc,cpp,go,python,rust nnoremap <buffer> <leader>l  :<C-u>ALEPopulateQuickfix<bar>copen<CR>
    autocmd Filetype c,cc,cpp,go,python,rust nnoremap <buffer> <leader>m  :<C-u>ALEFix<CR>
    autocmd Filetype c,cc,cpp,go,python,rust nnoremap <buffer> <leader>r  :<C-u>ALERename<CR>
    autocmd Filetype c,cc,cpp,go,python,rust nnoremap <buffer> <leader>rf :<C-u>ALEFindReferences<CR>
augroup end
" AUTO LIGHT/DARK MODE ########################################################
function! s:set_bg(timer_id)
    let g:theme_changed = 1
    let g:theme = system("cat $HOME/.local/share/current_theme")
    if g:theme == 'light' && (&background != 'light' || a:timer_id == 0)
        set background=light notermguicolors
        colorscheme default
    elseif g:theme == 'dark' && (&background == 'light' || a:timer_id == 0)
        set background=dark  termguicolors
        try | colorscheme gruvbox | catch | endtry
    else
        let g:theme_changed = 0
    endif

    if g:theme_changed == 1
        highlight CursorColumn  ctermbg=254
        highlight CursorLine    ctermbg=254 cterm=NONE
        highlight Normal        ctermbg=NONE guibg=NONE
        highlight SignColumn    ctermbg=NONE guibg=NONE
        highlight TabLineFill   cterm=NONE   gui=NONE
        highlight link myDeclaration Identifier
        highlight link myFunction Special
    endif
endfun
" Execute bg_sync every 5 seconds
silent call timer_start(1000 * 5, function('s:set_bg'), {'repeat': -1})
" Execute now to set theme
silent call s:set_bg(0)
" ALE + LSP ###################################################################
set omnifunc=ale#completion#OmniFunc
let g:ale_completion_enabled    = 1
let g:ale_enabled               = 1
let g:ale_floating_preview      = 1
let g:ale_hover_cursor          = 0 " this triggers too many LSP starts.
let g:ale_lint_on_enter         = 0
let g:ale_lint_on_insert_leave  = 0
let g:ale_lint_on_save          = 1
let g:ale_lint_on_text_changed  = 0
let g:ale_virtualtext_cursor = 0
let g:ale_linters = {
            \   'c':      ['cc', 'ccls', 'clangd'],
            \   'cpp':    ['cc', 'ccls', 'clangd'],
            \   'go':     ['gobuild', 'gofmt', 'golangci-lint', 'golint', 'gopls', 'govet'],
            \   'python': ['flake8', 'mypy', 'pycodestyle', 'pydocstyle', 'pyflakes', 'pylint', 'pylsp'],
            \   'rust':   ['analyzer', 'cargo', 'clippy', 'rls', 'rustc'],
            \}
" LSP AUTOSTOP ################################################################
" Disable LSP after 5 minutes if in inactivity in normal mode.
let g:stoplsp = 1
augroup lsp_idle_saving
    autocmd!
    autocmd InsertEnter  * ALEEnable
    autocmd BufLeave     * let g:stoplsp = 1
    autocmd CursorHold   * let g:stoplsp = 1
    autocmd CursorMoved  * let g:stoplsp = 0
    autocmd CursorMovedI * let g:stoplsp = 0
    autocmd InsertEnter  * let g:stoplsp = 0
augroup end
function! s:disable_lsp(timer_id)
    if g:stoplsp == 1
        ALEStopAllLSPs
    endif
endfun
silent call timer_start(1000 * 300, function('s:disable_lsp'), {'repeat': -1})
