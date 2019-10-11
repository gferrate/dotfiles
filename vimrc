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
Plug 'scrooloose/nerdtree'          "nerd-tree
Plug 'zivyangll/git-blame.vim'          "git-blame in the status bar
"Plug 'ryanoasis/vim-devicons'       "dev-icons of files
Plug 'maksimr/vim-jsbeautify'
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


" ------ RUN NERDTREE automatically ------ "
" keep the focus on main window
augroup NERD
    au!
    autocmd VimEnter * NERDTree
    autocmd VimEnter * wincmd p
augroup END
" close NerdTree together with the last buffer oppened
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" ------------- DEVICONS ----------------- "
" whether or not to show the nerdtree brackets around flags
let g:webdevicons_conceal_nerdtree_brackets = 0
" Devicons in
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_ctrlp = 1


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

" -------------- GIT BLAME -------------- "
nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>

" Remove SignColumn color
highlight clear SignColumn

" Remove trailing whitespaces in python files
autocmd BufWritePre *.py %s/\s\+$//e

"vim pureta
let vimpureta=1
if vimpureta
    map <up> <nop>
    map <down> <nop>
    map <left> <nop>
    map <right> <nop>
endif

"CTRL+N open/close NerdTree
map <C-n> :NERDTreeToggle<CR>


""" ##################### JS BEAUTIFLIER ################
autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
" for json
autocmd FileType json noremap <buffer> <c-f> :call JsonBeautify()<cr>
" for jsx
autocmd FileType jsx noremap <buffer> <c-f> :call JsxBeautify()<cr>
" for html
autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
" for css or scss
autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>


"Add this to ~/.vim/editorconfig
"
"";.editorconfig
"
"root = true
"
"[**.js]
"indent_style = space
"indent_size = 4
"
"[**.json]
"indent_style = space
"indent_size = 4
"
"[**.jsx]
"e4x = true
"indent_style = space
"indent_size = 4
"
"[**.css]
"indent_style = space
"indent_size = 4
"
"[**.html]
"indent_style = space
"indent_size = 4

""##############################################
