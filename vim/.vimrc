set nocompatible                   " Modern Vim features, not Vi compatible
let g:loaded_2html_plugin=1        " Disables :TOhtml command (converts buffer to HTML with syntax highlighting)
let g:loaded_getscriptPlugin=1     " Disables :GetScript command (script downloader from vim.org)
let g:loaded_logipat=1             " Disables :LogiPat command (logical pattern matching tool)
" let g:loaded_matchparen=1          " Disables bracket matching - reduces CPU usage on cursor movement
let g:loaded_tarPlugin=1           " Disables ability to browse and edit files inside .tar archives
let g:loaded_tutor_mode_plugin=1   " Disables :Tutor command (interactive Vim tutorial)
let g:loaded_vimballPlugin=1       " Disables support for .vba (Vimball) plugin installation format
let g:loaded_zipPlugin=1           " Disables ability to browse and edit files inside .zip archives
let g:loaded_spellfile_plugin=1    " Disables automatic spell file downloading
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
set autoindent noexpandtab shiftround smartindent smarttab
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
call plug#end()
" #############################################################################
" Enable filetype detection and syntax highlighting - moved to bottom for best performance
augroup general
	autocmd! general
	" Keep equal proportions when windows resized
	autocmd VimResized  * wincmd = " equalize
	" Auto close quickfix when I select something
	autocmd FileType qf   nnoremap <buffer> <cr> <cr>:<C-u>lclose<cr>
	" Strip whitespaces and extra newlines
	autocmd BufWritePre * if &ft!~?'markdown'|%s/\($\n\s*\)\+\%$//e|endif
	autocmd BufWritePre * if &ft!~?'markdown'|%s/\s\+$//e|endif
	" When editing a file, always jump to the last cursor position
	autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
	" Auto day/night theme
	autocmd BufEnter,SigUSR1 * call ToggleTheme()
augroup end
" Toggle light/dark mode ######################################################
function! ToggleTheme()
	let theme = trim(readfile(expand('~/.local/share/theme'))[0])
	colorscheme lunaperche
	if theme == "light"
		set background=light
	else
		set background=dark
	endif
	highlight Normal ctermbg=NONE
	highlight StatusLineNC cterm=NONE ctermbg=NONE
	highlight VertSplit ctermbg=NONE
	highlight clear Comment
	highlight clear StatusLine
	highlight clear TabLine
	highlight clear TabLineFill
	highlight link Comment NonText
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
" Fuzzy finding
nnoremap <leader><Tab>      :<C-u>call feedkeys(":buffer \<Tab>", 't')<cr>
nnoremap <leader><leader>   :<C-u>lgetexpr system(&grepprg . ' -l .<bar>sed "s/\(.*\)/\1:1: /"')<bar>lopen<cr>/
nnoremap <leader>n          :<C-u>Lexplore<cr>
nnoremap <leader>o          :<C-u>args `find . -type f -iname '**'`<Left><Left><Left>
nnoremap <leader>t          :<C-u>call feedkeys(":tag \<Tab>", 't')<cr>
" Git helpers
nnoremap <leader>gd         :<C-u>!git difftool --tool=vimdiff --no-prompt <C-r>=expand('%')<cr><cr>
nnoremap <leader>gb         :<C-u>!tig blame +<C-r>=line('.')<cr> -- <C-r>=expand('%')<cr><cr>
nnoremap <leader>gs         :<C-u>!tig -C . status<cr><cr>
" IDE-Like functionality (non-LSP)
nnoremap <leader>d          :<C-u>vert stag <c-r>=expand("<cword>")<cr><cr>
nnoremap <leader>f          :<C-u>cgetexpr system(&grepprg . ' ""')<bar>copen<C-Left><Right>
nnoremap <leader>fr         :<C-u>cgetexpr system(&grepprg . ' "\<<c-r>=expand("<cword>")<cr>\>"')<bar>copen<cr>
" Dev setup ###################################################################
" Formatters for different languages
autocmd FileType c,cpp      setlocal equalprg=clang-format
autocmd FileType go         setlocal equalprg=goimports
autocmd FileType json       setlocal equalprg=jq\ --tab
autocmd FileType python     setlocal equalprg=yapf\ --style=facebook
autocmd FileType sh         setlocal equalprg=shfmt\ -s\ -ci\ -sr\ -kp\ -fn\ -i=0
" Format code
nnoremap <leader>i          :<C-u>mkview<cr>:w<cr>gg=G:loadview<cr>
" Project wide Linters for different languages
autocmd FileType c          nnoremap <buffer> <leader>l <Esc>:<C-u>cgetexpr system('clang-tidy -p compile-commands.json ' . expand('%') . ' <bar>grep ' . expand('%'))<bar>copen<cr>
autocmd FileType go         nnoremap <buffer> <leader>l <Esc>:<C-u>cgetexpr system("golangci-lint run ./... --color never --out-format tab")<bar>copen<cr>
autocmd FileType json       nnoremap <buffer> <leader>l <Esc>:<C-u>cgetexpr system('jq . ' . expand('%') . ' > /dev/null')<bar>copen<cr>
autocmd FileType python     nnoremap <buffer> <leader>l <Esc>:<C-u>cgetexpr system("flake8 -j auto --max-line-length 80")<bar>copen<cr>
autocmd FileType sh         nnoremap <buffer> <leader>l <Esc>:<C-u>cgetexpr system("shellcheck -f gcc -a -Sstyle " . expand('%'))<bar>copen<cr>
autocmd FileType yaml       nnoremap <buffer> <leader>l <Esc>:<C-u>cgetexpr system("yamllint --format parsable " . expand('%'))<bar>copen<cr>
" Setup ALE as LSP client when dependencies are met ###########################
set complete=.,w,b,u,t,i,d
set completeopt=menu,menuone,popup,noselect,noinsert
let g:ale_completion_enabled=1
let g:ale_floating_preview=1
let g:ale_hover_cursor=0
let g:ale_lint_on_enter =0
let g:ale_lint_on_text_changed=0
if executable('clangd') && executable('gopls') && executable('jedi-language-server')
	let g:ale_linters={
				\   'go':     ['gopls'],
				\   'json':   ['jq'],
				\   'python': ['jedils', 'pylint', 'mypy'],
				\}
	" Set up LSP completion and commands
	autocmd FileType c,go,python  setlocal omnifunc=ale#completion#OmniFunc
	autocmd FileType c,go,python  nnoremap <buffer> <leader>k  :<C-u>ALEHover<cr>
	autocmd FileType c,go,python  nnoremap <buffer> <C-]>      :<C-u>ALEGoToDefinition<cr>
	autocmd FileType c,go,python  nnoremap <buffer> <leader>d  :<C-u>ALEGoToDefinition -vsplit<cr>
	autocmd FileType c,go,python  nnoremap <buffer> <leader>fr :<C-u>ALEFindReferences<cr>
	autocmd FileType c,go,python  nnoremap <buffer> <leader>r  :<C-u>ALERename<cr>
endif
