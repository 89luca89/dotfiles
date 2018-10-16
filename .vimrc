set nocompatible              " required
filetype off                  " required

call plug#begin('~/.vim/plugged')
" utilities
Plug 'scrooloose/nerdtree'                                      " split file manager
Plug 'vim-airline/vim-airline'                                  " tabs and statusline
Plug 'airblade/vim-gitgutter'                                   " +,-,~ on modified lines in git repo
Plug 'ctrlpvim/ctrlp.vim'                                       " fuzzy finder

" Vim LanguageClient setup
" download for java http://download.eclipse.org/jdtls/milestones/?d
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
Plug 'ludovicchabant/vim-gutentags'                             " tags navigation Ctrl+] or Ctrl+click to jump
" snippets
Plug 'sirver/ultisnips'
Plug 'honza/vim-snippets'

" color schemes
Plug 'flazz/vim-colorschemes'
Plug 'vim-airline/vim-airline-themes'

call plug#end()               " required
filetype plugin indent on     " required

" Formatting
" Ctrl+L Format Code
" This performs a write, and then pipes the file to the formatter (by default
" uses the default vim formatter)
" :w save file, :mkview remember line, :%!formatter % to format and output,
" :loadview to return to previous line
noremap <C-L> <Esc>:w<CR>:mkview<CR>ggVG=<CR>:loadview<CR>
augroup autoformat_settings
    autocmd FileType go noremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!gofmt %<CR>:loadview<CR>
    autocmd FileType html,css,json noremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!js-beautify %<CR>:loadview<CR>
    autocmd FileType rust noremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!rustfmt %<CR>:loadview<CR>
    autocmd FileType python noremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!autopep8 %<CR>:loadview<CR>
    autocmd FileType c,cpp,objc,proto,typescript,javascript,java noremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!clang-format -style=file %<CR>:loadview<CR>
    autocmd FileType sh noremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!shfmt %<CR>:loadview<CR>
    autocmd FileType yaml noremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!yamlfmt<CR>:loadview<CR>
augroup END

""" Git signs in gutter
let g:gitgutter_grep = 'rg'

" Icons
let NERDTreeShowHidden=1
let NERDTreeHijackNetrw=1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

""" CtrlP
" Use Ripgrep = superfast
set grepprg=rg
let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
let g:ctrlp_clear_cache_on_exit = 0
" set ctrlp to same working directory
let g:ctrlp_working_path_mode = 'ra'
" exclude compiled files class and svns
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/]\.(git|hg|svn|bin|out)$',
            \ 'file': '\v\.(exe|so|dll|class|bin|out)$',
            \ }

" Path to python interpreter for neovim
let g:python3_host_prog  = '/usr/bin/python3'
" Skip the check of neovim module
let g:python3_host_skip_check = 1
" Async Complete + LSP
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_remove_duplicates = 1
let g:lsp_signs_enabled = 1           " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
set completeopt+=preview
if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif
if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif
if executable('go-langserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'go-langserver',
        \ 'cmd': {server_info->['go-langserver', '-mode', 'stdio']},
        \ 'whitelist': ['go'],
        \ })
endif
if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
        \ 'whitelist': ['rust'],
        \ })
endif
if executable('jdtls')
    au FileType java let g:asyncomplete_remove_duplicates = 0
    au FileType java let g:lsp_signs_enabled = 0
    au User lsp_setup call lsp#register_server({
        \ 'name': 'jtdls',
        \ 'cmd': {server_info->[&shell, &shellcmdflag,'~/bin/jdtls']},
        \ 'whitelist': ['java'],
        \ })
endif

if executable('bash-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'bash-language-server',
        \ 'cmd': {server_info->['bash-language-server', 'start']},
        \ 'whitelist': ['sh'],
        \ })
endif
if has('python3')
    let g:UltiSnipsExpandTrigger="<c-e>"
    call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
        \ 'name': 'ultisnips',
        \ 'whitelist': ['*'],
        \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
        \ }))
endif

""" Airline -> bufferline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
""" GutenTags
let g:gutentags_enabled = 1
let g:gutentags_generate_on_empty_buffer = 1
let g:gutentags_cache_dir = "~/.vim/tags"
let g:gutentags_resolve_symlinks = 1
let g:gutentags_ctags_extra_args = ['--recurse=yes', '--extra=+f', '--fields=afmikKlnsStz']
" I Like snippets!
let g:UltiSnipsListSnippets="<c-h>"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

""" GENERIC PROGRAMMING
"
" leader+[ will get the Docsets on Zeal/Dash
let g:subtype = ""
map <silent> <leader>[ :<C-u>execute '!zeal ' . &filetype . "," . subtype . ":" . expand("<cword>") . " &>> /dev/null &"<CR><CR>

" Ctrl+] goTo Definition, default CtrlPTags, if present use Lang Server
map <silent> <C-]> :CtrlPTag<cr><C-\>w

" Language client shortcuts with leader:
map <silent> <leader>h :LspHover<cr>
map <silent> <leader>e :LspDocumentDiagnostics<cr>
map <silent> <leader>m :LspCodeAction<cr>
map <silent> <leader>r :LspRename<cr>
map <silent> <leader>t :LspWorkspaceSymbol<cr>
map <silent> <leader>g :LspDefinition<cr>
map <silent> <leader>rf :LspReferences<cr>
map <silent> <leader>l :LspDocumentFormat<cr>
map <silent> <leader>i :LspImplementation<cr>
map <silent> <leader>td :LspTypeDefinition<cr>
map <silent> <leader>ne :LspNextError<cr>
map <silent> <leader>pe :LspPreviousError<cr>


" Ctrl+T fuzzy find ctags
noremap <C-T> :CtrlPTag<CR>
" Ctrl+P fuzzy find files
noremap <C-P> :CtrlP<CR>

" Ctrl+B open/close file explorer
noremap <C-B> :NERDTreeToggle<CR>
" Ctrl+N relocate file explorer to opened file
noremap <C-N> :NERDTreeFind<CR>

""" Visual Mode
""" Ctrl-C copy visual selection to clipboard
vnoremap <C-c> :'<,'>w !xclip -sel clip<CR><CR>

map <silent> <C-D> :<C-u>call ToggleTheme()<CR>
function! ToggleTheme()
    if &background == 'light'
        set background=dark
        colorscheme hybrid
        highlight Normal guibg=#111111
    else
        set background=light
        colorscheme visualstudio
        highlight LineNr guibg=NONE
        highlight nonText guibg=NONE
    endif
endfunction

" ==========================================================================="
" Resize Split When the window is resized"
autocmd VimResized * :wincmd =

""" Tabs Navigation
" navigate tabs Tab (fw) S-Tab (prev)
map <Tab> :bn<CR>
map <S-Tab> :bp<CR>
" Ctrl+C close buffer ( pipe commands to fix behaviour with splits and netrw/nerdtree)
nnoremap <C-c> :bp<bar>sp<bar>bn<bar>bd!<CR>

" " Resize split window horizontally and vertically
" Shortcuts to Shift-Alt-Arrows - Alt is mapped as M in vim
noremap <S-M-Up> :2winc+<cr>
noremap <S-M-Down> :2winc-<cr>
noremap <S-M-Left> :2winc><cr>
noremap <S-M-Right> :2winc<<cr>

" Persistent undo
set undofile
set undodir=$HOME/.vim/undo
set undolevels=1000
set noswapfile

set signcolumn=yes
set lazyredraw ttyfast synmaxcol=200 ttimeoutlen=20
set mouse=a                                             " it's always useful to use the mouse then needed
set hidden                                              " change buffer without saving
set wildmenu                                            " Tab autocomplete in command mode
set backspace=indent,eol,start                          " http://vi.stackexchange.com/a/2163
set splitright splitbelow                               " Open new splits to the right and bottom
set autoindent smartindent                              " always set autoindenting on
set expandtab shiftwidth=4 tabstop=4 softtabstop=4      " Four spaces for tabs everywhere
set hlsearch incsearch ignorecase smartcase             " Highlight search results, ignore case if search is all lowercase
set nowrap                                              " play nicely with long lines
set number                                              " Enable line numbers
set updatetime=1000                                     " reduce update time from 4s to 1s
let &colorcolumn="80"
syntax on

" play nicely with modern graphics
set encoding=utf8
set background=dark
colorscheme hybrid
set termguicolors
highlight Normal guibg=#111111
