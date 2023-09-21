" AUTO-INSTALL VIM-PLUG #######################################################
if empty(glob('$HOME/.vim/autoload/plug.vim'))
    silent !mkdir -p "$HOME/.vim/"{autoload,plugged,undo,view,spell}
    silent !curl -sfLo "$HOME/.vim/autoload/plug.vim" --create-dirs
                \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    autocmd VimEnter * PlugInstall --sync|qall
endif
" AUTO-INSTALL DEVEL DEPS #####################################################
if empty(glob('$HOME/.local/share/vim_setup_done'))
    silent !type pyls || PIPX_HOME=$HOME/.local/share/pipx pipx install "python-language-server[all]" &&
                \ PIPX_HOME=$HOME/.local/share/pipx pipx inject python-language-server mypy yamllint
    silent !go install -v github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    silent !go install -v github.com/onsi/ginkgo/v2/ginkgo@latest
    silent !go install -v golang.org/x/tools/cmd/goimports@latest
    silent !go install -v golang.org/x/tools/gopls@latest
    silent !go install -v mvdan.cc/gofumpt@latest
    silent !go install -v sigs.k8s.io/kind@latest
    " symlink all binaries in path
    silent !find $HOME/.local/share/pipx/venvs/python-language-server/bin/ $HOME/.local/share/go/bin/
                \ -type f -executable  -exec ln -sf {} $HOME/.local/bin \;
    silent !touch $HOME/.local/share/vim_setup_done
endif
"##############################################################################
source $VIMRUNTIME/defaults.vim
set autoindent copyindent expandtab shiftwidth=4 softtabstop=4 tabstop=4 smartindent smarttab
set autoread autowrite hidden
set colorcolumn=80 cursorline showmatch
set hlsearch ignorecase smartcase
set lazyredraw redrawtime=0 ttyfast notermguicolors
set nomodeline nofsync nowrap noswapfile nowritebackup nobackup noshowmode nofoldenable
set path+=** wildmode=longest:full,full wildignore+=**/tags,vendor/**,coverage/**target/**,node_modules/** wildignorecase wildmode=longest:full
set splitbelow splitright sidescroll=1 sidescrolloff=7
set title number encoding=utf8 mouse=a nrformats+=unsigned isfname-==
set undofile undolevels=10000
set termguicolors
set completeopt=menu,menuone,popup,noselect,noinsert
set grepprg=grep\ --exclude=tags\ --exclude-dir={.git,vendor,node_modules,coverage,target}\ -EIrn
set laststatus=2 statusline=%m\ %f\ %y\ %{&fileencoding?&fileencoding:&encoding}\ %=%(C:%c\ L:%l\ %P%)
set list listchars=tab:\|\ " there is a space
set undodir=$HOME/.vim/undo
filetype off
call plug#begin('~/.vim/plugged')
" utilities
Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-buftabline'
" Fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" " colorscheme
Plug 'cormacrelf/vim-colors-github'
Plug 'tomasiser/vim-code-dark'
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
let g:python_highlight_all              = 1
" SHORTCUTS####################################################################
" do last action on a visual selection
vnoremap . :normal .<CR>
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
nnoremap <leader>l   :<C-u>cgetexpr system('project-utils lint ' . &filetype . " " . expand('%'))<bar>copen<CR>
nnoremap <leader>L   :<C-u>cgetexpr system('project-utils lint ' . &filetype . " .")<bar>copen<CR>
nnoremap <leader>gb  :<C-u>!tig blame +<C-r>=line('.')<CR> -- <C-r>=expand('%')<CR><CR>
nnoremap <leader>gd  :<C-u>!git diff <C-r>=expand('%:p')<bar>tig<CR><CR>
nnoremap <leader>gs  :<C-u>!tig -C . status<CR><CR>
" Default IDE-Style keybindings: indent/format, definition, find, references
nnoremap <leader>i   :<C-u>mkview<CR>:w<CR>ggVG=:loadview<CR>
nnoremap <C-]>       :<C-u>stag <c-r>=expand("<cword>")<CR><CR>
nnoremap <leader>d   :<C-u>vert stag <c-r>=expand("<cword>")<CR><CR>
nnoremap <leader>f   :<C-u>cgetexpr system(&grepprg . ' ""')<bar>copen<C-Left><Right>
nnoremap <leader>rf  :<C-u>cgetexpr system(&grepprg . ' "\<<c-r>=expand("<cword>")<CR>\>"')<bar>copen<CR>
augroup autoformat_settings
    autocmd!
    autocmd FileType c,cpp     nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!clang-format -style=Chromium %<CR>:loadview<CR>
    autocmd FileType go        nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:!gofmt -w %<CR><CR>:!goimports -w %<CR><CR>:!gofumpt -w %<CR><CR>:loadview<CR>
    autocmd FileType json      nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!jq .<CR>
    autocmd FileType python    nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!yapf --style=facebook %<CR>:w<CR>:%!isort --ac --float-to-top -d %<CR>:loadview<CR>
    autocmd FileType sh        nnoremap <buffer> <leader>i <Esc>:w<CR>:mkview<CR>:%!shfmt -s -ci -sr -kp %<CR>:loadview<CR>
augroup end
" LSP SETUP ####################################################################
" Override IDE-Style keybindings: definition, rename, references
augroup lspbindings
    autocmd!
    " IDE-like keybindings
    autocmd Filetype c,cc,cpp,go,python nnoremap <buffer> K          :<C-u>ALEHover<CR>
    autocmd Filetype c,cc,cpp,go,python nnoremap <buffer> <C-]>      :<C-u>ALEGoToDefinition<CR>
    autocmd Filetype c,cc,cpp,go,python nnoremap <buffer> <leader>d  :<C-u>ALEGoToDefinition -vsplit<CR>
    autocmd Filetype c,cc,cpp,go,python nnoremap <buffer> <leader>l  :<C-u>ALEPopulateQuickfix<bar>copen<CR>
    autocmd Filetype c,cc,cpp,go,python nnoremap <buffer> <leader>m  :<C-u>ALEFix<CR>
    autocmd Filetype c,cc,cpp,go,python nnoremap <buffer> <leader>r  :<C-u>ALERename<CR>
    autocmd Filetype c,cc,cpp,go,python nnoremap <buffer> <leader>R  :<C-u>ALEFindReferences<CR>
augroup end
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
let g:ale_linters = {
            \   'c':      ['cc', 'ccls', 'clangd'],
            \   'cpp':    ['cc', 'ccls', 'clangd'],
            \   'go':     ['gobuild', 'gofmt', 'golangci-lint', 'golint', 'gopls', 'govet'],
            \   'python': ['flake8', 'mypy', 'pycodestyle', 'pydocstyle', 'pyflakes', 'pylint', 'pylsp'],
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
" AUTO LIGHT/DARK MODE ########################################################
function! s:set_bg(timer_id)
    let g:theme = system("cat $HOME/.local/share/current_theme")
    if g:theme == 'light' && (&background != 'light' || a:timer_id == 0)
        " colorscheme default
        set background=light
        try | colorscheme github | catch | endtry
    elseif (g:theme == 'dark'|| g:theme == '') && (&background == 'light' || a:timer_id == 0)
        set background=dark
        try | colorscheme codedark | catch | endtry
    endif
    highlight clear SpecialKey
    highlight link  SpecialKey NonText
    highlight link BufTabLineActive TabLineSel
    highlight link BufTabLineCurrent PmenuSel
    highlight link myDeclaration Identifier
    highlight link myFunction Special
endfun
" Execute bg_sync every 5 seconds
silent call timer_start(1000 * 5, function('s:set_bg'), {'repeat': -1})
" Execute now to set theme
silent call s:set_bg(0)
