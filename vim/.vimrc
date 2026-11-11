let g:markdown_fenced_languages = ['diff', 'c', 'cpp', 'go', 'rust', 'python', 'sh', 'bash']
let g:netrw_altv = 1
let g:netrw_banner = 0
let g:netrw_browse_split = 4
let g:netrw_liststyle = 3
let g:netrw_winsize = -28
set t_Co=16 noxtermcodes
set timeoutlen=500 ttimeout ttimeoutlen=100 updatetime=500
set noswapfile nowritebackup
set undodir=$HOME/.vim/undo undofile undolevels=10000
set autoread
set hidden
set isfname-==
set nrformats-=octal
set autoindent shiftround smarttab smartindent copyindent preserveindent
set softtabstop=4 tabstop=4
set formatoptions+=j
set nomodeline
set nowrap
set nofoldenable
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
set wildignorecase wildmode=longest:full,full wildoptions+=pum
set wildignore+=*.o,*.obj,*/.git/**,*/.claude/**,*/.pi/**,*.rbc,*.pyc,*/__pycache__/**,*/node_modules/**,*/vendor/**
set grepprg=grep\ --exclude={tags,*.lock,*.jpg,*.jpeg,*.svg,*.png,*.raw,*.tar.*,*.img,*.iso}\ --exclude-dir={.git,.claude,.pi,node_modules,build,output}\ -EIrn
set path=.,**,**/.[a-z]*/**,**/.[A-Z]*/** " fuzzy find also hidden files, but exclude . and ..
set tags=./tags;,tags
" Auto-install vim-plug #######################################################
let s:plug = expand('~/.vim/autoload/plug.vim')
let s:url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
if !filereadable(s:plug)
	call mkdir(expand('~/.vim/autoload'), 'p')
	call mkdir(expand('~/.vim/undo'), 'p')
	execute 'silent !curl -fsSLo' shellescape(s:plug) s:url
				\ '|| wget -qO' shellescape(s:plug) s:url
	autocmd VimEnter * if exists(':PlugInstall') | PlugInstall --sync | q | endif
endif
" Plugin setup with vim-plug
call plug#begin('~/.vim/plugged')
Plug 'ap/vim-buftabline'
Plug 'airblade/vim-gitgutter'
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf.vim' | Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
call plug#end()
syntax sync fromstart
" #############################################################################
augroup general
	autocmd! general
	" Keep equal proportions when windows resized
	autocmd VimResized  * wincmd = " equalize
	autocmd! FileType fzf tnoremap <buffer> <Esc> <C-c>
	" Limit MatchParen to 1ms in files with a line with more than 1k chars
	autocmd BufWinEnter * if max(map(getline(1,'$'), 'len(v:val)')) > 1000 | let b:matchparen_timeout = 1 | let b:matchparen_insert_timeout = 1 | endif
	autocmd Syntax * syntax match myFunction    '\v[[:alpha:]_]\w*\ze\s*\('
augroup end
set background=dark
for s:g in ['SignColumn', 'Special', 'StatusLine', 'TabLineFill', 'VertSplit'] | execute 'highlight clear' s:g | endfor
highlight ColorColumn  ctermbg=234
highlight Constant     ctermfg=2
highlight CursorLine   ctermfg=NONE ctermbg=NONE cterm=bold
highlight CursorLineNr ctermfg=NONE ctermbg=NONE cterm=bold
highlight Identifier   cterm=italic
highlight DiffAdd      ctermfg=0 ctermbg=2
highlight DiffChange   ctermfg=0 ctermbg=3
highlight DiffDelete   ctermfg=0 ctermbg=1
highlight DiffText     ctermfg=0 ctermbg=11 cterm=bold
highlight Function     ctermfg=4
highlight LineNr       ctermfg=8
highlight MatchParen   ctermfg=NONE ctermbg=8 cterm=bold
highlight Pmenu        ctermfg=NONE ctermbg=8
highlight Statement    ctermfg=13
highlight Type    ctermfg=173
highlight Visual       ctermfg=NONE ctermbg=NONE cterm=reverse
for s:g in ['Comment', 'FoldColumn', 'NonText', 'SpecialKey', 'StatusLineNC', 'TabLine'] | execute 'highlight! link' s:g 'LineNr' | endfor
highlight! link Folded ColorColumn
for s:g in ['PreProc', 'myFunction'] | execute 'highlight! link' s:g 'Function' | endfor
highlight! link PmenuSel Visual
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
function! s:Osc52(text)
	let b64 = system('base64 -w0', a:text)
	if len(b64) > 8184
		echo "yank too large for OSC 52, use tmux buffer (+]")
		return
	elseif exists('$TMUX')
		call system('tmux load-buffer -w -', a:text)
	else
		call echoraw("\e]52;c;" . b64 . "\x07")
	endif
endfunction
autocmd general TextYankPost * if v:event.operator ==# 'y' | call s:Osc52(getreg('"')) | endif
" Escape
tnoremap <Esc>              <C-\><C-n>
inoremap jj                 <Esc>
" Fuzzy finding
let $FZF_DEFAULT_OPTS .= ' --walker-skip=.git,node_modules,.claude,.pi'
nnoremap <leader><Tab>      :<C-u>Buffers<cr>
nnoremap <leader><leader>   :<C-u>Files<cr>
nnoremap <leader>t          :<C-u>Tags<cr>
nnoremap <leader>T          :<C-u>call <SID>Ctags()<cr>
nnoremap <leader>f          :<C-u>RG<cr>
nnoremap <leader>n          :<C-u>Lexplore<cr>
nnoremap <leader>o          :<C-u>args `find . -type f -iname '**'`<Left><Left><Left>
" Git helpers
nnoremap <leader>gd         :<C-u>!git difftool --tool=vimdiff --no-prompt <C-r>=expand('%')<cr><cr>
nnoremap <leader>gb         :<C-u>!tig blame +<C-r>=line('.')<cr> -- <C-r>=expand('%')<cr><cr>
nnoremap <leader>gs         :<C-u>!tig -C . status<cr><cr>
" Dev setup ###################################################################
set completeopt=menu,menuone,popup,noselect,noinsert
let s:systags = {
			\ 'c': '-G --kinds-C=+p --kinds-C++=+p /usr/include',
			\ 'cpp': '-G --kinds-C=+p --kinds-C++=+p /usr/include',
			\ 'go': '--languages=Go "$(go env GOROOT)/src"',
			\ 'python': '--languages=Python'
			\ . ' "$(python3 -c ''import sysconfig; print(sysconfig.get_path("stdlib"))'')"',
			\ 'rust': '--languages=Rust "$(rustc --print sysroot)/lib/rustlib/src/rust/library"',
			\ }
function! s:Ctags() abort
	let cmd = '!'
	let f = '~/.vim/systags/' . &filetype
	if has_key(s:systags, &filetype) && !filereadable(expand(f))
		let cmd .= 'cd ~; mkdir -p ~/.vim/systags; ctags -R -f ' . f . ' ' . s:systags[&filetype]
					\ . ' 2>/dev/null; grep -qv "^._TAG_" ' . f . ' || rm ' . f . '; '
	endif
	execute cmd . 'cd ' . shellescape(expand('%:p:h'), 1)
				\ . ' && root=$(git rev-parse --show-toplevel) && cd "$root" && ctags -R'
endfunction
autocmd general FileType * execute 'setlocal tags+=~/.vim/systags/' . &filetype
autocmd general FileType c,cpp let &l:path = '.,/usr/include/**,' . &g:path
autocmd general FileType * if &omnifunc == '' | setlocal omnifunc=syntaxcomplete#Complete | endif
nnoremap <leader>F          :<C-u>cgetexpr system(&grepprg . ' ""')<bar>copen<C-Left><Right>
nnoremap <leader>d          :<C-u>vert stag <c-r>=expand("<cword>")<cr><cr>
nnoremap <leader>fr         :<C-u>cgetexpr system(&grepprg . ' "\<<c-r>=expand("<cword>")<cr>\>"')<bar>copen<cr>
nnoremap <leader>k          K
nnoremap <leader>r          :<C-u>%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
nnoremap <leader>i          :<C-u>ALEFix<cr>
nnoremap <leader>l          :<C-u>ALEPopulateQuickfix<cr>
let g:ale_floating_preview=1
let g:ale_hover_cursor=0
let g:ale_lint_on_enter =0
let g:ale_lint_on_text_changed=0
let g:ale_linters={
			\   'c':      ['clangd'],
			\   'cpp':    ['clangd'],
			\   'go':     ['gopls'],
			\   'json':   ['jq'],
			\   'python': ['jedils', 'pylint', 'mypy'],
			\   'rust':   ['analyzer'],
			\   'sh':     ['shellcheck'],
			\   'yaml':   ['yamllint'],
			\}
let g:ale_fixers = {
			\   '*':      ['trim_whitespace','remove_trailing_lines'],
			\   'c':      ['clang-format','trim_whitespace','remove_trailing_lines'],
			\   'cpp':    ['clang-format','trim_whitespace','remove_trailing_lines'],
			\   'go':     ['goimports','trim_whitespace','remove_trailing_lines'],
			\   'json':   ['jq','trim_whitespace','remove_trailing_lines'],
			\   'python': ['yapf','trim_whitespace','remove_trailing_lines'],
			\   'rust':   ['rustfmt','trim_whitespace','remove_trailing_lines'],
			\   'sh':     ['shfmt','trim_whitespace','remove_trailing_lines'],
			\}
let g:ale_json_jq_options     = '--tab'
let g:ale_python_pylint_options = '--max-line-length=80'
let g:ale_python_yapf_options = '--style=facebook'
let g:ale_sh_shfmt_options    = '-s -ci -sr -kp -fn -i=0'
let g:ale_sh_shellcheck_options = '-a -Sstyle'
let g:ale_rust_analyzer_config = {'check': {'command': 'clippy'}}
let s:lsp = {'c': 'clangd', 'cpp': 'clangd', 'go': 'gopls', 'python': 'jedi-language-server', 'rust': 'rust-analyzer'}
function! s:LspMappings()
	setlocal omnifunc=ale#completion#OmniFunc
	nnoremap <buffer> <C-]>      :<C-u>ALEGoToDefinition<cr>
	nnoremap <buffer> <leader>d  :<C-u>ALEGoToDefinition -vsplit<cr>
	nnoremap <buffer> <leader>fr :<C-u>ALEFindReferences<cr>
	nnoremap <buffer> <leader>k  :<C-u>ALEHover<cr>
	nnoremap <buffer> <leader>r  :<C-u>ALERename<cr>
endfunction
autocmd general FileType * if executable(get(s:lsp, &filetype, '')) && exists(':ALEHover')
			\ | call s:LspMappings() | endif
