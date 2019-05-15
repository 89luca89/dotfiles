set nocompatible              " required
filetype off                  " required

call plug#begin('~/.vim/plugged')
" utilities
Plug 'scrooloose/nerdtree'                                      " split file manager
Plug 'vim-airline/vim-airline'                                  " tabs and statusline
Plug 'airblade/vim-gitgutter'                                   " +,-,~ on modified lines in git repo
Plug 'yggdroot/indentline'
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
" download for java http://download.eclipse.org/jdtls/milestones/?d
Plug 'ludovicchabant/vim-gutentags'                             " tags navigation Ctrl+] or Ctrl+click to jump
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'pearofducks/ansible-vim'
Plug 'autozimu/languageclient-neovim', {
            \ 'branch': 'next',
            \ 'do': 'bash install.sh',
            \ }

" snippets
Plug 'sirver/ultisnips'
Plug 'honza/vim-snippets'

" color schemes
Plug 'vim-airline/vim-airline-themes'
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
    autocmd FileType html,css,json noremap <buffer> <C-L> <Esc>:w<CR>:mkview<CR>:%!jsonlint -f %<CR>:loadview<CR>
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
" Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#auto_completion_start_length = 2
let g:deoplete#manual_completion_start_length = 1
call deoplete#custom#source('LanguageClient',
            \ 'min_pattern_length',
            \ 2)
" Async Complete + LSP
set completeopt+=preview
set signcolumn=yes
let g:LanguageClient_autoStart = 1
let g:LanguageClient_diagnosticsEnable = 1
let g:LanguageClient_loadSettings = 1
let g:LanguageClient_serverCommands = {
            \ 'c': ['clangd'],
            \ 'cpp': ['clangd'],
            \ 'python': ['/usr/local/bin/pyls'],
            \ 'go' : ['~/.local/go/bin/go-langserver'],
            \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
            \ 'sh' : ['~/.npm-packages/bin/bash-language-server', 'start'],
            \ 'yaml': ['~/.npm-packages/bin/yaml-language-server', '--stdio'],
            \ 'yaml.ansible': ['~/.npm-packages/bin/yaml-language-server', '--stdio'],
            \ 'xml': ['~/bin/xmlls'],
            \ 'java': ['~/bin/jdtls'],
            \ }

function! s:setYamlSchema()
    echom &ft
    if &ft == "yaml.ansible"
        echom "Yaml-Language-Server using ansible schema."
        let config = json_decode(system("cat ~/.vim/yaml/ansible.json"))
        call LanguageClient#Notify('workspace/didChangeConfiguration', { 'settings': config })
    elseif &ft=="yaml"
        echom "Yaml-Language-Server using default schema."
        let config = json_decode(system("cat ~/.vim/yaml/default.json"))
        call LanguageClient#Notify('workspace/didChangeConfiguration', { 'settings': config })
    endif
endfunction

augroup LanguageClient_config
    autocmd!
    autocmd User LanguageClientStarted call s:setYamlSchema()
augroup END

""" Airline -> bufferline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" I Like snippets!
let g:UltiSnipsListSnippets="<c-h>"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

""" GENERIC PROGRAMMING
"
" leader+[ will get the Docsets on Zeal/Dash
" map <silent> <leader>[ :<C-u>execute '!zeal ' . &filetype . "," . subtype . ":" . expand("<cword>") . " &>> /dev/null &"<CR><CR>

" Ctrl+] goTo Definition, default CtrlPTags, if present use Lang Server
map <silent> <C-]> :CtrlPTag<cr><C-\>w
set formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
" Language client shortcuts with leader:
map <silent> <leader>h :call LanguageClient_textDocument_hover()<cr>
map <silent> <leader>m :call LanguageClient_contextMenu()<cr>
map <silent> <leader>r :call LanguageClient_textDocument_rename()<cr>
map <silent> <leader>t :call LanguageClient_textDocument_documentSymbol()<cr>
map <silent> <leader>g :call LanguageClient#textDocument_definition({'gotoCmd': 'split'})<cr>
map <silent> <leader>a :call LanguageClient#textDocument_codeAction()<cr>
map <silent> <leader>rf :call LanguageClient#textDocument_references()<cr>
map <silent> <leader>l :call LanguageClient#textDocument_formatting()<cr>
map <silent> <leader>i :call LanguageClient_textDocument_implementation()<cr>
map <silent> <leader>td :call LanguageClient_textDocument_typeDefinition()<cr>
map <silent> <leader>e :call LanguageClient#explainErrorAtPoint()<cr>

" Ctrl+T fuzzy find ctags
noremap <C-T> :CtrlPTag<CR>
" Ctrl+P fuzzy find files
noremap <C-P> :CtrlP<CR>

" Ctrl+B open/close file explorer
noremap <C-B> :NERDTreeToggle<CR>
" Ctrl+N relocate file explorer to opened file
noremap <C-N> :NERDTreeFind<CR>

""" Visual Mode
""" Ctrl-C copy isual selection to clipboard
vnoremap <C-c> :'<,'>w !xclip -sel clip<CR><CR>

map <silent> <C-e> :<C-u>call ToggleTheme()<CR>
function! ToggleTheme()
    if &background == 'light'
        set background=dark
        colorscheme hybrid
        AirlineTheme hybrid
        highlight ColorColumn ctermbg=235
    else
        set background=light
        colorscheme macvim-light
        AirlineTheme papercolor
        highlight ColorColumn ctermbg=255
        highlight VertSplit ctermbg=255 ctermfg=255
        highlight LineNr ctermbg=white ctermfg=black
        highlight nonText ctermbg=white ctermfg=black
        highlight Normal ctermbg=white ctermfg=black
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
set lazyredraw ttyfast ttimeoutlen=20
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
let &colorcolumn=join(range(81,999),",")
syntax on

" play nicely with modern graphics
set encoding=utf8
set background=dark
colorscheme hybrid
highlight ColorColumn ctermbg=235
