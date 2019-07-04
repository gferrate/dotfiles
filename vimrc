set nocompatible              " be iMproved, required
filetype off                  " required
"execute pathogen#infect()
call plug#begin('~/.vim/plugged')

" set the runtime path to include Vundle and initialize
"set rtp+=~/.vim/bundle/Vundle.vim
"call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
set runtimepath^=~/.vim/bundle/ctrlp.vim
set runtimepath+=~/.vim-plugins/LanguageClient-neovim


" let Vundle manage Vundle, required
Plug 'VundleVim/Vundle.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'hynek/vim-python-pep8-indent'
Plug 'kien/ctrlp.vim'
"Plug 'ajh17/VimCompletesMe'
Plug 'ervandew/supertab'
Plug 'ekalinin/Dockerfile.vim'
Plug 'easymotion/vim-easymotion'
Plug 'qpkorr/vim-bufkill'
Plug 'crusoexia/vim-monokai'
Plug 'vim-python/python-syntax'
Plug 'pangloss/vim-javascript'
Plug 'altercation/vim-colors-solarized'
Plug 'Matt-Deacalion/vim-systemd-syntax'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" All of your Plugins must be added before the following line
"call vundle#end()            " required
call plug#end()
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

" Vim configration ############################################################
syntax enable
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

"set foldmethod=syntax
"
"
"
""""""""""""""""""""GO TO DEFINITION""""""""""""""""""""""""2
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
" #############################################################################


" Solarized stuff
let g:solarized_termtrans = 1
set background=dark
colorscheme solarized

" Airline configuration #######################################################
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts=1
" #############################################################################

" CtrlP configuration #########################################################
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
" #############################################################################
let mapleader=","  " change the mapleader from \ to ,

let g:python_highlight_all = 1
let g:javascript_plugin_jsdoc = 1


" General Mappings and custom commands ########################################

map <C-h> <C-W>h<C-W>_
map <C-l> <C-W>l<C-W>_
imap jk <Esc>
imap ppp import pudb; pudb.set_trace()<Esc>

nnoremap <TAB> :bn<CR>
nnoremap <S-TAB> :bN<CR>

vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
:nnoremap <F5> :buffers<CR>:buffer<Space>
" #############################################################################
" Incsearch
nnoremap <leader><space> :nohlsearch<CR>

"Fold 
nnoremap <space> za

" Remove SignColumn color
highlight clear SignColumn
