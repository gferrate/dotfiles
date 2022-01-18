set nocompatible
filetype off
call plug#begin('~/.vim/plugged')

" Set the runtime path to include Vundle and initialize #######################
set runtimepath^=~/.vim/bundle/ctrlp.vim

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
Plug 'junegunn/fzf'
Plug 'raphamorim/lucario'
Plug 'NLKNguyen/papercolor-theme'
Plug 'wincent/terminus'
Plug 'lepture/vim-jinja'


call plug#end()

" Vim configration ############################################################
syntax enable
filetype plugin indent on
set hlsearch
set wildmode=list:longest,full
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
"set relativenumber
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,venv/*
"set ttymouse=sgr "Mouse works after col 220
set cursorline
set signcolumn=yes

" GO TO DEFINITION ############################################################


" Colorscheme #################################################################
colorscheme lucario
set t_Co=256   " This is may or may not needed.

"set background=light
"colorscheme PaperColor

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

" Jinja highliting ############################################################
au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm set ft=jinja


" font: https://github.com/tonsky/FiraCode
