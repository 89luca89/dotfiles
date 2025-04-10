set nocompatible                   " Modern Vim features, not Vi compatible
" Performance settings
let g:loaded_2html_plugin=1        " Disables :TOhtml command (converts buffer to HTML with syntax highlighting)
let g:loaded_getscriptPlugin=1     " Disables :GetScript command (script downloader from vim.org)
let g:loaded_logipat=1             " Disables :LogiPat command (logical pattern matching tool)
let g:loaded_matchparen=1          " Disables bracket matching - reduces CPU usage on cursor movement
let g:loaded_tarPlugin=1           " Disables ability to browse and edit files inside .tar archives
let g:loaded_tutor_mode_plugin=1   " Disables :Tutor command (interactive Vim tutorial)
let g:loaded_vimballPlugin=1       " Disables support for .vba (Vimball) plugin installation format
let g:loaded_zipPlugin=1           " Disables ability to browse and edit files inside .zip archives
let g:loaded_spellfile_plugin=1    " Disables automatic spell file downloading
let g:gitgutter_eager=0            " Don't update gitgutter eagerly
let g:gitgutter_enabled=0          " Enable it when needed
let g:gitgutter_max_signs=500      " Limit number of git gutter signs
set ttyfast                        " Faster terminal connection
set lazyredraw                     " Don't redraw screen during macros/scripts
set redrawtime=10000               " Allow more time for screen drawing - prevents timeouts
set updatetime=500                 " Faster update time (ms)
set timeoutlen=500                 " Time to wait for a mapped sequence (ms)
set ttimeout                       " time out for key codes
set ttimeoutlen=100                " wait up to 100ms after Esc for special key
set synmaxcol=256                  " Disable highlight after column 256
set t_Co=256                       " Default to 256 colors
" Other settings
set nofsync                        " Don't force disk synchronization
set noswapfile                     " Don't use swapfiles
set nowritebackup                  " Don't create a backup when overwriting a file
set nobackup                       " Don't keep backup files
set undofile                       " Save undo history to a file
set undolevels=10000               " Maximum number of changes that can be undone
set undodir=$HOME/.vim/undo        " Directory to store undo files
set autoread                       " Reload files changed outside vim
set hidden                         " Allow switching buffers without saving
set backspace=indent,eol,start     " Allow backspacing over indentation, line breaks and insertion start
set nrformats-=octal               " Don't treat numbers with leading zeros as octal
set textwidth=0                    " Disable automatic text width formatting
set autoindent                     " Copy indent from current line when starting a new line
set smartindent                    " Smart autoindenting for C-like programs
set shiftwidth=4                   " Width of indentation with >> or <<
set shiftround                     " Round indent to multiple of shiftwidth
set tabstop=4                      " Width of a tab character
set softtabstop=4                  " Number of spaces a tab counts for when editing
set smarttab                       " Insert blanks according to shiftwidth
set formatoptions+=j               " Delete comment character when joining commented lines.
set nowrap                         " Don't wrap lines
set nomodeline                     " Disable modeline for security
set isfname-==                     " Remove=from filename chars for gf command
set foldmethod=manual              " Don't auto-fold (faster)
set nofoldenable                   " Start with folds open (faster initial display)
set virtualedit=block              " Allow cursor to move where there is no text in visual block mode
set display+=truncate              " Show '@@@' when line truncated
set cursorline                     " Highlight the current line
set colorcolumn=80                 " Show column guide at 80 characters
set number                         " Show line numbers
set title                          " Set window title to reflect edited file
set noshowmode                     " Don't show mode in command line
set laststatus=2                   " Always show status line
set statusline=%{toupper(mode())}\ %<%f%m\ %=\ B:%n\ L:%l\/%L\ C:%c%V\ \[%{&ff}]:%y
set list                           " Show invisible characters
set listchars=tab:\|\              " Show tabs as |
set listchars+=lead:\.             " Show leading spaces as .
set scrolloff=5                    " Keep 5 lines below and above the cursor
set sidescrolloff=5                " Keep 5 columns to the left and right of the cursor
set sidescroll=1                   " Smoother horizontal scrolling
set noerrorbells                   " Don't beep
set visualbell                     " Use a visual error bell instead of beeping
set shortmess+=c                   " Don't pass messages to ins-completion-menu
set mousehide                      " Hide mouse when typing
set mouse=a                        " Enable mouse in all modes
set splitbelow                     " New horizontal splits open below current window
set splitright                     " New vertical splits open to the right
set diffopt+=vertical              " Start diff mode with vertical splits
set hlsearch                       " Highlight search results
set ignorecase                     " Ignore case in searches
set smartcase                      " Case sensitive when search includes uppercase
set incsearch                      " Show partial matches while typing search
set path+=**                       " Search paths for find command
set tags+=tags.**/tags             " Additional tags files
set wildmenu                       " Enhanced command line completion
set wildignore+=**/.git/**         " Ignore .git in search
set wildignore+=**/build/**        " Ignore build directory in search
set wildignore+=**/node_modules/** " Ignore node_modules in search
set wildignore+=**/tags,vendor/**  " Ignore tags and golang vendor
set wildignorecase                 " Case-insensitive filename completion
set wildmode=longest:full,full     " List all matches and complete to longest common string
set wildoptions+=pum               " Use popup menu for wildmenu completion
set nolangremap                    " Breaks some plugins
set grepprg=grep\ --exclude={tags,*.lock,*.jpg,*.jpeg,*.svg,*.png,*.raw,*.tar.*,*.img,*.iso}\ --exclude-dir={.git,node_modules,build,output}\ -EIrn
let $FZF_DEFAULT_COMMAND='find . \! \( -type d -path ./.git -prune \) \! -type d -printf ''%P\n'''
let g:netrw_liststyle=3            " Set nested style
" Syntax highlight improvements
let g:go_highlight_extra_types=1   " Improve golang syntax
let g:go_highlight_fields=1        " Improve golang syntax
let g:go_highlight_operators=1     " Improve golang syntax
let g:go_highlight_types=1         " Improve golang syntax
let g:go_highlight_function_parameters=1
let g:groovy_highlight_all=1       " Improve groovy syntax
let g:java_highlight_all=1         " Improve java syntax
let g:perl_highlight_data=1        " Improve perl syntax
let g:python_highlight_all=1       " Improve python syntax
let g:is_posix = 1                 " Correctly highlight $() and other modern affordances in filetype=sh
" Auto-install vim-plug #######################################################
if empty(glob('$HOME/.vim/autoload/plug.vim'))
	silent !mkdir -"$HOME/.vim/"{autoload,plugged,undo,view,spell}
	silent !curl -sfLo "$HOME/.vim/autoload/plug.vim" --create-dirs
				\ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
	autocmd VimEnter * PlugInstall --sync|q
endif
" Plugin setup with vim-plug
call plug#begin('~/.vim/plugged')
Plug 'ap/vim-buftabline'
Plug 'airblade/vim-gitgutter'
Plug 'tomasiser/vim-code-dark'
Plug 'junegunn/fzf.vim' | Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'dense-analysis/ale'
call plug#end()
" #############################################################################
" Enable filetype detection and syntax highlighting - moved to bottom for best performance
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
	autocmd BufWritePre *   if &ft!~?'markdown'|%s/\($\n\s*\)\+\%$//e|endif
	autocmd BufWritePre *   if &ft!~?'markdown'|%s/\s\+$//e|endif
	" Help indentation guides on yaml/json
	autocmd FileType json,yaml setlocal cursorcolumn
	" Custom syntax highlight
	autocmd Syntax * syntax match myComparison  '\v[_.[:alnum:]]+(,\s*[_.[:alnum:]]+)*\ze\s*(\=\=|!\=)'
	autocmd Syntax * syntax match myDeclaration '\v[_.[:alnum:]]+(,\s*[_.[:alnum:]]+)*\ze\s*(:\=|([-^+|^\/%&]|\*|\<\<|\>\>|\&\^)?\=[^=])'
	autocmd Syntax * syntax match myField       '\v[[:alpha:]]+:'
	autocmd Syntax * syntax match myFunction    '\v[[:alpha:]_]\w*\ze\s*\('
	autocmd Syntax * syntax match myImport      '\<\w\+\>\ze\.\w'

augroup end
" Auto light/dark mode ########################################################
function! SetTheme()
	if &background == "dark"
		silent! colorscheme wildcharm
		set background=light
	else
		silent! colorscheme codedark
		set background=dark
	endif
	highlight clear StatusLine
	highlight clear TabLinefill
	highlight link  myComparison Identifier
	highlight link  myDeclaration Identifier
	highlight link  myField Identifier
	highlight link  myFunction Function
	highlight link  myImport Identifier
endfun
nnoremap <C-e> :<C-u>call SetTheme()<cr>
call SetTheme()
" Shortcuts ###################################################################
let mapleader=' '
" Text editing shortcuts
vnoremap . :normal .<cr>
vnoremap < <gv
vnoremap > >gv
" Buffer navigation
nnoremap <S-Tab>            :<C-u>bp<cr>
nnoremap <Tab>              :<C-u>bn<cr>
nnoremap <C-c>              :<C-u>bp<bar>sp<bar>bn<bar>bd<cr>
" Copy to clipboard
vnoremap <C-c>              y:call system('wl-copy', @")<cr>
" File explorer
nnoremap <leader>e          :<C-u>25Lexplore<cr>
" Fuzzy finding
map <leader><Tab>           :<C-u>Buffers<cr>
map <leader><leader>        :<C-u>Files<cr>
map <leader>t               :<C-u>Tags<cr>
" Format code
nnoremap <leader>i          :<C-u>mkview<cr>:w<cr>gg=G:loadview<cr>
" IDE-Like functionality (non-LSP)
nnoremap <leader>K          :<C-u>call term_start('curl -s https://cheat.sh/' . &filetype . '/' . substitute(expand('<cword>'), ' ', '+', 'g'))<cr>
nnoremap <leader>d          :<C-u>vert stag <c-r>=expand("<cword>")<cr><cr>
nnoremap <leader>f          :<C-u>cgetexpr system(&grepprg . ' ""')<bar>copen<C-Left><Right>
nnoremap <leader>r          :<C-u>cgetexpr system(&grepprg . ' "\<<c-r>=expand("<cword>")<cr>\>"')<bar>copen<bar>cdo %s/<c-r>=expand("<cword>")<cr>//gc<Left><Left><Left>
nnoremap <leader>rf         :<C-u>cgetexpr system(&grepprg . ' "\<<c-r>=expand("<cword>")<cr>\>"')<bar>copen<cr>
" Git helpers
function! GitDiffWithHead()
	let f=expand('%')
	vert new
	exec 'r !git show HEAD:'.shellescape(f)
	setl bt=nofile ro
	diffthis
	winc p
	diffthis
endf
nnoremap <leader>gb         :<C-u>!tig blame +<C-r>=line('.')<cr> -- <C-r>=expand('%')<cr><cr>
nnoremap <leader>gs         :<C-u>!tig -C . status<cr><cr>
nnoremap <leader>gd         :<C-u>call GitDiffWithHead()<cr>
" Dev setup ###################################################################
set complete=.,w,b,u,t,i,d
set completeopt=menu,menuone,popup,noselect,noinsert
" Default to use standard completion on all filetypes
inoremap <Nul> <C-p>
" Language-specific omni completion
autocmd FileType c,cpp      setlocal omnifunc=ccomplete#Complete
autocmd FileType css        setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html       setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType php        setlocal omnifunc=phpcomplete#CompletePHP
autocmd FileType python     setlocal omnifunc=python3complete#Complete
autocmd FileType xml        setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType c,cpp,css,html,php,python,xml,javascript inoremap <buffer> <Nul> <C-x><C-o>
" Formatters for different languages
autocmd FileType c,cpp      setlocal equalprg=clang-format
autocmd FileType go         setlocal equalprg=goimports
autocmd FileType json       setlocal equalprg=jq\ --tab
autocmd FileType python     setlocal equalprg=yapf\ --style=facebook
autocmd FileType sh         setlocal equalprg=shfmt\ -s\ -ci\ -sr\ -kp\ -fn\ -i=0\ -p
" Project wide Linters for different languages
autocmd FileType go         nnoremap <buffer> <leader>L <Esc>:<C-u>cgetexpr system("golangci-lint run ./... --color never --out-format tab")<bar>copen<cr>
autocmd FileType json       nnoremap <buffer> <leader>L <Esc>:<C-u>cgetexpr system('jq . ' . expand('%') . ' > /dev/null')<bar>copen<cr>
autocmd FileType python     nnoremap <buffer> <leader>L <Esc>:<C-u>cgetexpr system("flake8 -j auto --max-line-length 80")<bar>copen<cr>
autocmd FileType sh         nnoremap <buffer> <leader>L <Esc>:<C-u>cgetexpr system("find . -path ./.git -prune -o -type f -print<bar>xargs -P9 -I{} sh -c 'file {}<bar> grep -q shell && shellcheck -f gcc -a -Sstyle {}'")<bar>copen<cr>
autocmd FileType yaml       nnoremap <buffer> <leader>L <Esc>:<C-u>cgetexpr system("find . -path ./.git -prune -o -type f -name '*.y*ml' -print <bar>xargs -P9 -I{} yamllint --format parsable {}")<bar>copen<cr>
" Setup ALE as LSP client when dependencies are met ##########################
let g:ale_completion_enabled=1
let g:ale_floating_preview=1
let g:ale_hover_cursor=0
let g:ale_lint_on_enter =0
let g:ale_lint_on_text_changed=0
let g:ale_linters={
			\   'go':     ['gopls'],
			\   'json':   ['jq'],
			\   'python': ['jedils', 'pylint', 'mypy'],
			\}
if executable('clangd') && executable('gopls') && executable('jedi-language-server')
	" Set up LSP completion
	autocmd FileType c,go,python  setlocal omnifunc=ale#completion#OmniFunc
	autocmd FileType c,go,python  inoremap <buffer> <Nul> <C-x><C-o>
	" Set up LSP commands for this buffer
	autocmd FileType c,go,python  nnoremap <buffer> K          :<C-u>ALEHover<cr>
	autocmd FileType c,go,python  nnoremap <buffer> <leader>d  :<C-u>ALEGoToDefinition -vsplit<cr>
	autocmd FileType c,go,python  nnoremap <buffer> <leader>l  :<C-u>ALELint<bar>ALEPopulateQuickfix<bar>copen<cr>
	autocmd FileType c,go,python  nnoremap <buffer> <leader>r  :<C-u>ALERename<cr>
	autocmd FileType c,go,python  nnoremap <buffer> <leader>rf :<C-u>ALEFindReferences<cr>
endif
" Disable LSP after 10  minutes if in inactivity in normal mode.
let g:stoplsp=1
augroup lsp_idle_saving
	autocmd!
	autocmd InsertEnter,BufWritePre * if g:stoplsp == 1 | echom "LSP servers enabled" | ALELint | endif
	autocmd BufLeave,CursorHold     * let g:stoplsp=1
	autocmd InsertEnter,CursorMoved,CursorMovedI * let g:stoplsp=0
augroup end
function! s:disable_lsp(timer_id)
	if g:stoplsp == 1
		echom "LSP servers disabled due to inactivity"
		ALEStopAllLSPs
	endif
endfun
silent call timer_start(1000 * 600, function('s:disable_lsp'), {'repeat': -1})
