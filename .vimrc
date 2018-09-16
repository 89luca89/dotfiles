set nocompatible              " required
filetype off                  " required

call plug#begin('~/.vim/plugged')
" utilities
Plug 'scrooloose/nerdtree'                                      " split file manager
Plug 'vim-airline/vim-airline'                                  " tabs and statusline
Plug 'airblade/vim-gitgutter'                                   " +,-,~ on modified lines in git repo
Plug 'ctrlpvim/ctrlp.vim'                                       " fuzzy finder

" Deoplete
if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif

" Vim LanguageClient setup
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf'
Plug 'autozimu/languageclient-neovim', {
            \ 'branch': 'next',
            \ 'do': 'bash install.sh',
            \ }
" languages
Plug 'w0rp/ale'                                                 " linting!
Plug 'scrooloose/syntastic', { 'for': 'java' }                  " linting!
Plug 'ludovicchabant/vim-gutentags'                             " tags navigation Ctrl+] or Ctrl+click to jump
Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
" snippets
Plug 'sirver/ultisnips'
Plug 'honza/vim-snippets'

" Icons
Plug 'ryanoasis/vim-devicons'

" color schemes
Plug 'flazz/vim-colorschemes'

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
    autocmd FileType ansible,yaml noremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!yamlfmt<CR>:loadview<CR>
augroup END

""" Git signs in gutter
let g:gitgutter_grep = 'rg'

" Icons
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
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
" Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#auto_completion_start_length = 2
let g:deoplete#manual_completion_start_length = 0

let g:LanguageClient_serverCommands = {
            \ 'c': ['clangd'],
            \ 'cpp': ['clangd'],
            \ 'python': ['/usr/local/bin/pyls'],
            \ 'sh' : ['bash-language-server', 'start'],
            \ 'go' : ['~/.local/go/bin/go-langserver'],
            \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
            \ }
" ALE
let g:ale_enabled = 1
let g:ale_set_highlights = 1
let g:ale_lint_on_save = 1
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'
let g:ale_linters = {
            \ 'c': ['clang'],
            \ 'cpp': ['clang++'],
            \ 'python': ['python', 'pylint'],
            \ 'sh': ['bash', 'shellcheck'],
            \ 'go': ['go build', 'golint'],
            \ 'rust': ['rustc'],
            \ 'java': [],
            \ }
" We use syntastic for java only for this option
" we need custom classpaths and ALE does not support it.
" -> enables definition of .syntastic_java_config file for custom classpaths
let g:syntastic_java_javac_config_file_enabled = 1
let g:syntastic_java_checkers=['javac']
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ["java"],'passive_filetypes': [] }
let g:syntastic_aggregate_errors = 1
""" Airline -> bufferline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#ale#enabled = 1
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
" Ctrl+] CtrlPTags
" leader+[ will get the Docsets on Zeal/Dash
let g:subtype = ""
map <silent> <leader>[ :<C-u>execute '!zeal ' . &filetype . "," . subtype . ":" . expand("<cword>") . " &>> /dev/null &"<CR><CR>
map <silent> <C-]> :CtrlPTag<cr><C-\>w
" Ctrl+T fuzzy find ctags
noremap <C-T> :CtrlPTag<CR>
nnoremap <C-K> :call LanguageClient_contextMenu()<CR>
" Ctrl+P fuzzy find files
noremap <C-P> :CtrlP<CR>

" Ctrl+B open/close file explorer
noremap <C-B> :NERDTreeToggle<CR>
" Ctrl+N relocate file explorer to opened file
noremap <C-N> :NERDTreeFind<CR>

" Ctrl-E show/hide errors window
map <silent> <C-M> :<C-u>ALELint<CR>
autocmd FileType java map <silent> <C-M> :<C-u>SyntasticCheck<CR>

map <silent> <C-E> :<C-u>call ToggleErrors()<CR>
function! ToggleErrors()
    if exists("g:qwindow")
        lclose
        unlet g:qwindow
    else
        try
            lopen 10
            let g:qwindow = 1
        catch
            echo "No Errors found!"
        endtry
    endif
endfunction

""" Visual Mode
""" Ctrl-C copy visual selection to clipboard
vnoremap <C-c> :'<,'>w !xclip -sel clip<CR><CR>

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

map <silent> <C-D> :<C-u>call ToggleTheme()<CR>
function! ToggleTheme()
    if &background == 'light'
        set background=dark
        colorscheme hybrid
    else
        set background=light
        colorscheme eclipse
        highlight LineNr guibg=NONE
        highlight nonText guibg=NONE
    endif
endfunction

" ==========================================================================="
" Resize Split When the window is resized"
autocmd VimResized * :wincmd =

" Persistent undo
set undofile
set undodir=$HOME/.vim/undo
set undolevels=1000
set noswapfile

" play nicely with modern graphics
set encoding=utf8
set background=dark
colorscheme hybrid
set termguicolors

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
