set nocompatible              " required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
" utilities
Plugin 'scrooloose/nerdtree'
Plugin 'ctrlpvim/ctrlp.vim'             " fuzzy finder
Plugin 'vim-airline/vim-airline'        " tabs and statusline
Plugin 'vim-airline/vim-airline-themes'
" languages
" syntastic+ycm covers already: bash, c, c++, js, html, JavaScript, Python
Plugin 'sheerun/vim-polyglot'           " lang packs!
Plugin 'rust-lang/rust.vim'             " rust
Plugin 'fatih/vim-go'                   " go
" autocompletion
Plugin 'scrooloose/syntastic'           " linting
Plugin 'ludovicchabant/vim-gutentags'   " tags navigation Ctrl+] or Ctrl+click to jump, to use together with YCM GoTo on supported langs.
Plugin 'Valloric/YouCompleteMe'         " code completion engine (all language depend from this)
Plugin 'artur-shaik/vim-javacomplete2'  " java
" color schemes
Plugin 'flazz/vim-colorschemes'

call vundle#end()             " required

filetype plugin indent on     " required

" Autocomplete c/c++ already use omnicomplete
augroup omnifuncs
  autocmd!
  autocmd FileType c set omnifunc=ccomplete#Complete
  autocmd FileType cpp set omnifunc=cppcomplete#CompleteCPP
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd FileType java setlocal omnifunc=javacomplete#Complete
  autocmd FileType java JCEnable
augroup end

" Formatting
    " Ctrl+L Format Code
" This performs a write, and then pipes the file to the formatter 
" :w save file, :mkview remember line, :%!formatter % to format and output,
" :loadview to return to previous line
" autocmd BufWritePre calls Ctrl-L before saving, this will then auto-fmt when
" saving
augroup autoformat_settings
  autocmd FileType go noremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!gofmt %<CR>:loadview<CR>
  autocmd FileType go inoremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!gofmt %<CR>:loadview<CR>a
  autocmd FileType html,css,json noremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!js-beautify %<CR>:loadview<CR>
  autocmd FileType html,css,json inoremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!js-beautify %<CR>:loadview<CR>a
  autocmd FileType rust noremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!rustfmt %<CR>:loadview<CR>
  autocmd FileType rust inoremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!rustfmt %<CR>:loadview<CR>a
  autocmd FileType python noremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!autopep8 %<CR>:loadview<CR>
  autocmd FileType python inoremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!autopep8 %<CR>:loadview<CR>a
  autocmd FileType c,cpp,proto,javascript,java noremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!clang-format -style=Chromium %<CR>:loadview<CR>
  autocmd FileType c,cpp,proto,javascript,java inoremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!clang-format -style=Chromium %<CR>:loadview<CR>a
  autocmd FileType sh noremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!shfmt %<CR>:loadview<CR>
  autocmd FileType sh inoremap <buffer> <C-L> <Esc>:w<CR><Esc>:mkview<CR>:%!shfmt %<CR>:loadview<CR>a
augroup END
autocmd BufWritePre * execute "normal \<C-L>"

""" CtrlP
" set ctrlp to same working directory
let g:ctrlp_working_path_mode = 'ra'
" exclude compiled files class and svns
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn|bin|out)$',
  \ 'file': '\v\.(exe|so|dll|class|bin|out)$',
  \ }
" Use Ripgrep = superfast
set grepprg=rg\ --color=never
let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'

""" Airline -> bufferline
let g:airline#extensions#tabline#enabled = 1

""" GutenTags
let g:gutentags_enabled = 1
let g:gutentags_generate_on_empty_buffer = 1
let g:gutentags_cache_dir = "~/.vim/tags"
let g:gutentags_resolve_symlinks = 1
let g:gutentags_ctags_extra_args = ['--recurse=yes', '--extra=+f', '--fields=afmikKlnsStz']

"""  Syntastic
" C/C++
let g:syntastic_c_compiler_options = '--std=gnu11'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
" Yaml
let g:syntastic_yaml_checkers = ['js-yaml']
" Json
let g:syntastic_json_checkers = ['jsonlint']
" Java
let g:syntastic_java_javac_config_file_enabled = 1  " enables definition of .syntastic_java_config file for custom classpaths
let g:syntastic_java_checkers=['javac']
" Go
let g:syntastic_go_checkers=['golint', 'go']
" Rust
let g:syntastic_rust_checkers = ['rustc', 'cargo']
" Python
let g:syntastic_python_checkers = ['python', 'pylint', 'flake8', 'pycodestyle']
" Generic Options
let g:syntastic_check_on_open = 0
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_aggregate_errors = 1
let g:syntastic_enable_signs = 1

""" GENERIC PROGRAMMING
"
" Ctrl+] will perform GoTo. Available for c, c++, objc, objcpp, cs, go, javascript, python, rust
" will use CtrlPTags if not compatible
" On compatible langs, ú will open the GetDoc for the function.
" Ctrl+? will get the Docsets on Zeal/Dash
let g:subtype = ""
map <silent> <C-?> :<C-u>execute '!zeal ' . &filetype . "," . subtype . ":" . expand("<cword>") . " &>> /dev/null &"<CR><CR>
map <silent> <C-]> :CtrlPTag<cr><C-\>w
autocmd FileType c,cpp,objc,objcpp,cs,go,javascript,python,rust map <buffer> <C-]> :<C-u>YcmCompleter GoTo<CR>
autocmd FileType c,cpp,objc,objcpp,cs,go,javascript,python,rust map <buffer> <M-z> :<C-u>YcmCompleter GetDoc<CR>
" Ctrl+T fuzzy find ctags
noremap <C-T> :CtrlPTag<CR>
" Ctrl+P fuzzy find files
noremap <C-P> :CtrlP<CR>

" F-8 willl perform advanced code analyzing for JAVA
" depends on PMD and this file https://gist.github.com/89luca89/37930d89082d48441cd6fa42d1bd9bea
autocmd FileType java noremap <buffer> <F8> :<C-u>:new<CR>:0read !analyze-pmd.sh<CR>gg

" Ctrl+B open/close file explorer
noremap <C-B> :NERDTreeToggle<CR>
" Ctrl+N relocate file explorer to opened file
noremap <C-N> :NERDTreeFind<CR>R<c-w><c-p>

" Ctrl-E show/hide errors window
map <silent> <C-E> :<C-u>call ToggleErrors()<CR>
function! ToggleErrors()
    if empty(filter(tabpagebuflist(), 'getbufvar(v:val, "&buftype") is# "quickfix"'))
         " No location/quickfix list shown, open syntastic error location panel
         SyntasticCheck
         Errors
    else
        lclose
    endif
endfunction

" Ctrl+d Switch dark/light theme according to system theme
map <silent> <C-D> :<C-u>call ToggleTheme()<CR>
function! ToggleTheme()
  if &background == 'light'
        let g:airline_theme='jellybeans'
        colorscheme onedark
        set background=dark
    else
        let g:airline_theme='base16'
        colorscheme github
        set background=light
    endif
endfunction


" 2xESC exit terminal mode
tnoremap <ESC><ESC> <C-\><C-N>

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
" ==========================================================================="

syntax on

" Working with split screen nicely
" Resize Split When the window is resized"
autocmd VimResized * :wincmd =
autocmd VimEnter * :NERDTree
" Persistent undo
set undofile
set undodir=$HOME/.vim/undo
set undolevels=1000
set noswapfile

" play nicely with modern graphics
set encoding=utf8
set t_Co=256
set background=dark
colorscheme onedark
let g:airline_theme='jellybeans'

set lazyredraw ttyfast
set mouse=a                           " it's always useful to use the mouse then needed
set hidden                            " change buffer without saving
set cursorline                        " highlight current line
set wildmenu                          " Tab autocomplete in command mode
set backspace=indent,eol,start        " http://vi.stackexchange.com/a/2163
set laststatus=2                      " Show status line on startup
set splitright splitbelow             " Open new splits to the right and bottom
set autoindent smartindent                              " always set autoindenting on
set expandtab shiftwidth=4 tabstop=4 softtabstop=4      " Four spaces for tabs everywhere
set hlsearch incsearch ignorecase smartcase nohlsearch  " Highlight search results, ignore case if search is all lowercase
set nowrap                            " play nicely with long lines
set ruler
let &colorcolumn="80"
set number                            " Enable line numbers
