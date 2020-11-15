set nocompatible
filetype off
call plug#begin('~/.vim/plugged')

" Set the runtime path to include Vundle and initialize #######################
set runtimepath^=~/.vim/bundle/ctrlp.vim
set runtimepath+=~/.vim-plugins/LanguageClient-neovim

" Plugins #####################################################################
" Plug 'ajh17/VimCompletesMe'
Plug 'VundleVim/Vundle.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'hynek/vim-python-pep8-indent'
Plug 'kien/ctrlp.vim'
Plug 'ervandew/supertab'
Plug 'ekalinin/Dockerfile.vim'
Plug 'easymotion/vim-easymotion'
Plug 'qpkorr/vim-bufkill'
Plug 'vim-python/python-syntax'
Plug 'pangloss/vim-javascript'
Plug 'altercation/vim-colors-solarized'
Plug 'Matt-Deacalion/vim-systemd-syntax'
Plug 'posva/vim-vue'
Plug 'zivyangll/git-blame.vim'
Plug 'maksimr/vim-jsbeautify'
Plug 'tpope/vim-surround'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'raphamorim/lucario'

call plug#end()

" Vim configration ############################################################
syntax enable
filetype plugin indent on
set hlsearch
set autoindent nosmartindent
set nostartofline
set number
set shiftwidth=4
set softtabstop=4
set expandtab
set colorcolumn=80
set scrolloff=8
set enc=utf-8
set mouse=a
set hidden
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,venv/*
set ttymouse=sgr "Mouse works after col 220
set cursorline
set signcolumn=yes

" GO TO DEFINITION ############################################################
set hidden

let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ 'python': ['/usr/local/bin/pyls'],
    \ 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'],
    \ }


nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

" Colorscheme #################################################################
colorscheme lucario
" Solarized stuff
"let g:solarized_termtrans = 1
"set background=light
"colorscheme solarized

" Airline configuration #######################################################
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts=1

" CtrlP configuration #########################################################
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'


" General Mappings and custom commands ########################################
let mapleader=","  " change the mapleader from \ to ,
let g:python_highlight_all = 1
let g:javascript_plugin_jsdoc = 1
map <C-h> <C-W>h<C-W>_
map <C-l> <C-W>l<C-W>_
imap jk <Esc>
imap ppp import pudb; pudb.set_trace()<Esc>
nnoremap <TAB> :bn<CR>
nnoremap <S-TAB> :bN<CR>
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
:nnoremap <F5> :buffers<CR>:buffer<Space>

" Incsearch ###################################################################
nnoremap <leader><space> :nohlsearch<CR>

" Fold ########################################################################
nnoremap <space> za

" Git Blame ###################################################################
nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>

" Remove SignColumn color  ####################################################
highlight clear SignColumn

" Remove trailing whitespaces in python files #################################
autocmd BufWritePre *.py %s/\s\+$//e

" VIM pureta ##################################################################
let vimpureta=0
if vimpureta
    map <up> <nop>
    map <down> <nop>
    map <left> <nop>
    map <right> <nop>
endif

" JS BEAUTIFLIER ##############################################################
autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
" for json
autocmd FileType json noremap <buffer> <c-f> :call JsonBeautify()<cr>
" for jsx
autocmd FileType jsx noremap <buffer> <c-f> :call JsxBeautify()<cr>
" for html
autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
" for css or scss
autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>
