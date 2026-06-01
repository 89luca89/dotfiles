set nocompatible                   " Modern Vim features, not Vi compatible
let g:gitgutter_eager=0            " Don't update gitgutter eagerly
let g:netrw_altv = 1
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_liststyle = 3
let g:netrw_winsize = -28
set t_Co=256
set timeoutlen=500 ttimeout ttimeoutlen=100 ttyfast updatetime=500
set nobackup noswapfile nowritebackup
set undodir=$HOME/.vim/undo undofile undolevels=10000
set autoread
set hidden
set backspace=indent,eol,start
set isfname-==
set nrformats-=octal
set autoindent noexpandtab shiftround smarttab smartindent copyindent preserveindent
set shiftwidth=8 softtabstop=8 tabstop=8 textwidth=0
set formatoptions+=j
set nomodeline
set nowrap
set foldmethod=manual nofoldenable
set colorcolumn=80
set cursorline
set virtualedit=block
set number
set title statusline=%{toupper(mode())}\ %<%f%m\ %=\ B:%n\ L:%l\/%L\ C:%c%V\ \[%{&ff}]:%y
set list listchars=tab:\|\ ,lead:\. " Show tabs as | and spaces as .
set mouse=a
set scrolloff=5
set diffopt+=vertical splitbelow splitright
set hlsearch ignorecase incsearch smartcase
set wildignorecase wildmenu wildmode=longest:full,full wildoptions+=pum
set wildignore+=*.o,*.obj,*/.git/**,*.rbc,*.pyc,*/__pycache__/**,*/node_modules/**,tags,*/vendor/**
set grepprg=grep\ --exclude={tags,*.lock,*.jpg,*.jpeg,*.svg,*.png,*.raw,*.tar.*,*.img,*.iso}\ --exclude-dir={.git,node_modules,build,output}\ -EIrn
set path=.,**,**/.[a-z]*/**,**/.[A-Z]*/** " fuzzy find also hidden files, but exclude . and ..
set tags+=tags.**/tags
syntax sync fromstart
" Auto-install vim-plug #######################################################
if empty(glob('$HOME/.vim/autoload/plug.vim'))
	silent !mkdir -"$HOME/.vim/"{autoload,plugged,undo,view,spell}
	silent !wget -qO "$HOME/.vim/autoload/plug.vim" "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
	autocmd VimEnter * PlugInstall --sync|q
endif
" Plugin setup with vim-plug
call plug#begin('~/.vim/plugged')
Plug 'ap/vim-buftabline'
Plug 'airblade/vim-gitgutter'
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf.vim' | Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
call plug#end()
" #############################################################################
" Enable filetype detection and syntax highlighting - moved to bottom for best performance
augroup general
	autocmd! general
	" Keep equal proportions when windows resized
	autocmd VimResized  * wincmd = " equalize
	autocmd! FileType fzf tnoremap <buffer> <Esc> <C-c>
	" Auto day/night theme
	autocmd BufEnter,SigUSR1 * call ToggleTheme()
	" Disable MatchParen for files with a line with more than 1k chars
	autocmd BufWinEnter * exe max(map(getline(1,'$'), 'len(v:val)')) > 1000 ? 'NoMatchParen' : ''
	autocmd Syntax * syntax match myFunction    '\v[[:alpha:]_]\w*\ze\s*\('
augroup end
" Toggle light/dark mode ######################################################
function! ToggleTheme()
	let theme = trim(readfile(expand('~/.local/share/theme'))[0])
	if theme == "light"
		set background=light
		colorscheme wildcharm
	else
		set background=dark
		colorscheme retrobox
	endif
	highlight link myFunction Function
endfun
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
vnoremap <C-X>              y:call system('wl-copy-remote', @")<cr>
" Escape
tnoremap <Esc>              <C-\><C-n>
inoremap jj                 <Esc>
" Fuzzy finding
nnoremap <leader><Tab>      :<C-u>Buffers<cr>
nnoremap <leader><leader>   :<C-u>Files<cr>
nnoremap <leader>t          :<C-u>Tags<cr>
nnoremap <leader>f          :<C-u>RG<cr>
nnoremap <leader>n          :<C-u>Lexplore<cr>
nnoremap <leader>o          :<C-u>args `find . -type f -iname '**'`<Left><Left><Left>
" Git helpers
nnoremap <leader>gd         :<C-u>!git difftool --tool=vimdiff --no-prompt <C-r>=expand('%')<cr><cr>
nnoremap <leader>gb         :<C-u>!tig blame +<C-r>=line('.')<cr> -- <C-r>=expand('%')<cr><cr>
nnoremap <leader>gs         :<C-u>!tig -C . status<cr><cr>
" Dev setup ###################################################################
" Setup ALE as LSP client when dependencies are met ###########################
set complete=.,w,b,u,t,i,d
set completeopt=menu,menuone,popup,noselect,noinsert
let g:ale_floating_preview=1
let g:ale_hover_cursor=0
let g:ale_lint_on_enter =0
let g:ale_lint_on_text_changed=0
let g:ale_linters={
			\   'go':     ['gopls'],
			\   'json':   ['jq'],
			\   'python': ['jedils', 'pylint', 'mypy'],
			\   'rust':   ['analyzer'],
			\}
let g:ale_fixers = {
			\   '*':      ['trim_whitespace','remove_trailing_lines'],
			\   'c':      ['clang-format'],
			\   'cpp':    ['clang-format'],
			\   'go':     ['goimports'],
			\   'json':   ['jq'],
			\   'python': ['yapf'],
			\   'rust':   ['rustfmt'],
			\   'sh':     ['shfmt'],
			\}
let g:ale_json_jq_options     = '--tab'
let g:ale_python_yapf_options = '--style=facebook'
let g:ale_sh_shfmt_options    = '-s -ci -sr -kp -fn -i=0'
" Set up LSP completion and commands
nnoremap <leader>i :<C-u>ALEFix<cr>
nnoremap <leader>d          :<C-u>vert stag <c-r>=expand("<cword>")<cr><cr>
nnoremap <leader>F          :<C-u>cgetexpr system(&grepprg . ' ""')<bar>copen<C-Left><Right>
nnoremap <leader>fr         :<C-u>cgetexpr system(&grepprg . ' "\<<c-r>=expand("<cword>")<cr>\>"')<bar>copen<cr>
autocmd FileType c,cpp,,go,python,rust  setlocal omnifunc=ale#completion#OmniFunc
autocmd FileType c,cpp,,go,python,rust  nnoremap <buffer> <leader>k  :<C-u>ALEHover<cr>
autocmd FileType c,cpp,,go,python,rust  nnoremap <buffer> <C-]>      :<C-u>ALEGoToDefinition<cr>
autocmd FileType c,cpp,,go,python,rust  nnoremap <buffer> <leader>d  :<C-u>ALEGoToDefinition -vsplit<cr>
autocmd FileType c,cpp,,go,python,rust  nnoremap <buffer> <leader>fr :<C-u>ALEFindReferences<cr>
autocmd FileType c,cpp,,go,python,rust  nnoremap <buffer> <leader>r  :<C-u>ALERename<cr>
" Project wide Linters for different languages
autocmd FileType c,cpp      nnoremap <buffer> <leader>l <Esc>:<C-u>cgetexpr system('clang-tidy -p compile-commands.json ' . expand('%') . ' <bar>grep ' . expand('%'))<bar>copen<cr>
autocmd FileType go         nnoremap <buffer> <leader>l <Esc>:<C-u>cgetexpr system("golangci-lint run ./... --color never --out-format tab")<bar>copen<cr>
autocmd FileType json       nnoremap <buffer> <leader>l <Esc>:<C-u>cgetexpr system('jq . ' . expand('%') . ' > /dev/null')<bar>copen<cr>
autocmd FileType python     nnoremap <buffer> <leader>l <Esc>:<C-u>cgetexpr system("flake8 -j auto --max-line-length 80")<bar>copen<cr>
autocmd FileType rust       nnoremap <buffer> <leader>l <Esc>:<C-u>cgetexpr system("cargo clippy --message-format short 2>&1")<bar>copen<cr>
autocmd FileType sh         nnoremap <buffer> <leader>l <Esc>:<C-u>cgetexpr system("shellcheck -f gcc -a -Sstyle " . expand('%'))<bar>copen<cr>
autocmd FileType yaml       nnoremap <buffer> <leader>l <Esc>:<C-u>cgetexpr system("yamllint --format parsable " . expand('%'))<bar>copen<cr>
